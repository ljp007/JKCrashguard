//
//  WildPointerChecker.m
//  WildPointerCheckerDemo
//
//  Created by RenTongtong on 16/8/26.
//  Copyright © 2016年 hdurtt. All rights reserved.
//

//野指针探测实现
//这个实现主要依据腾讯Bugly工程师:陈其锋的分享，在其代码中的主要思路是
//1、通过fishhook替换C函数的free方法为自定义的safe_free，类似于Method Swizzling
//2、在safe_free方法中对已经释放变量的内存，填充0x55，使已经释放变量不能访问，从而使某些野指针的crash从不必现安变成必现。
//为了防止填充0x55的内存被新的数据内容填充，使野指针crash变成不必现，在这里采用的策略是，safe_free不释放这片内存，而是自己保留着，即safe_free方法中不会真的调用free。
//同时为了防止系统内存过快消耗（因为要保留内存），需要在保留的内存大于一定值时释放一部分，防止被系统杀死，同时，在收到系统内存警告时，也需要释放一部分内存
//
//3、发生crash时，得到的崩溃信息有限，不利于问题排查，所以这里采用代理类（即继承自NSProxy的子类），重写消息转发的三个方法（参考这篇文章iOS-底层原理 14：消息流程分析之 动态方法决议 & 消息转发），以及NSObject的实例方法，来获取异常信息。但是这的话，还有一个问题，就是NSProxy只能做OC对象的代理，所以需要在safe_free中增加对象类型的判断


#import "JKWildPointerChecker.h"
#import "malloc/malloc.h"
#import "pthread.h"
#import "fishhook.h"
#import <objc/runtime.h>
#import "JKZombieObject.h"

//define
#define MAX_UNFREE_POINTER 1024*1024*10  //10MB
#define MAX_UNFREE_MEM     1024*1024*100 //100MB
#define FREE_POINTER_NUM   100           //每次释放100个指针

typedef struct unfreeMem {
    void *p;
    struct unfreeMem *next;
}UNFREE_MEM, *PUNFREE_MEM;

typedef struct unfreeList {
    PUNFREE_MEM header_list;
    PUNFREE_MEM tail_list;
    size_t      unfree_count;
    size_t      unfree_size;
}UNFREE_LIST, *PUNFREE_LIST;

void (*orig_free)(void *);
void myfree(void *p);
PUNFREE_LIST createList();
void addUnFreeMemToListSync(PUNFREE_LIST unfreeList, void *p);
void freeMemInListSync(PUNFREE_LIST unfreeList, size_t freeNum);

PUNFREE_LIST global_unfree_list = NULL;
pthread_mutex_t global_mutex;
Class global_zombie;
size_t global_zombie_size;
CFMutableSetRef global_registerdClasses;
BOOL isRunningWildPointerCheck = NO;

//method
void startWildPointerCheck()
{
    //获取已注册的类
    global_registerdClasses = CFSetCreateMutable(NULL, 0, NULL);

    //可以在这里生成白名单,white_Classes ......
    
    unsigned int count = 0;
    Class *classes = objc_copyClassList(&count);
    for (unsigned int i = 0; i < count; i++) {
        CFSetAddValue(global_registerdClasses, (__bridge const void *)(classes[i]));
    }
    free(classes);
    classes = NULL;
    //获取僵尸对象和其大小
    global_zombie = objc_getClass("JKZombieObject");
    global_zombie_size = class_getInstanceSize(global_zombie);
    //创建未释放内存的链表(带链表头)
    global_unfree_list = createList();
    //创建同步互斥量
    pthread_mutex_init(&global_mutex, NULL);
    //hook free
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        rebind_symbols((struct rebinding[1]){{"free", myfree, (void *)&orig_free}}, 1);
    });
    
    isRunningWildPointerCheck = YES;
}

void stopWildPointerCheck()
{
    isRunningWildPointerCheck = NO;
}

void myfree(void *p)
{
    if (!isRunningWildPointerCheck) {
        orig_free(p);
        return;
    }
    
    if (global_unfree_list->unfree_count > MAX_UNFREE_POINTER * 0.9 || global_unfree_list->unfree_size > MAX_UNFREE_MEM) {
        freeMemInListSync(global_unfree_list, FREE_POINTER_NUM);
    }
    
    size_t size = malloc_size(p);
    if (size >= global_zombie_size) {
        __unsafe_unretained id obj = (__bridge id)p;
        Class originClass = object_getClass(obj);
        
        //判断是不是objc对象
        char *type = @encode(typeof(obj));
        /*
            - strcmp 字符串比较
            - CFSetContainsValue 查看已注册类中是否有origClass这个类
            如果都满足，则将这块内存填充0x55,使已经释放变量不能访问，从而使某些野指针的crash从不必现安变成必现
        */

        if (strcmp("@", type) == 0 && originClass && CFSetContainsValue(global_registerdClasses, (__bridge const void *)(originClass))) {
            //内存上填充0x55
            memset(p, 0x55, size);
            //将自己类的isa复制过去
            memcpy(p, &global_zombie, sizeof(void *));
            
//            //为obj设置指定的类
//            object_setClass(obj, [JKZombieObject class]);
//            //保留obj原本的类
//            ((JKZombieObject*)obj).originClass = originClass;
            
            JKZombieObject * zombie = (__bridge JKZombieObject *)p;
            zombie.originClass = originClass;
            
        } else {
            memset(p, 0x55, size);
        }
    } else {
        memset(p, 0x55, size);
    }
    
    addUnFreeMemToListSync(global_unfree_list, p);
}

PUNFREE_LIST createList()
{
    PUNFREE_LIST unfreeList = (PUNFREE_LIST)malloc(sizeof(UNFREE_LIST));
    unfreeList->header_list = (PUNFREE_MEM)malloc(sizeof(UNFREE_MEM));
    unfreeList->header_list->p = NULL;
    unfreeList->header_list->next = NULL;
    unfreeList->tail_list = unfreeList->header_list;
    unfreeList->unfree_count = 0;
    unfreeList->unfree_size = 0;
    return unfreeList;
}

void addUnFreeMemToListSync(PUNFREE_LIST unfreeList, void *p)
{
    pthread_mutex_lock(&global_mutex);
    if (!unfreeList || !p) {
        pthread_mutex_unlock(&global_mutex);
        return;
    }
    
    PUNFREE_MEM unfreeMem = (PUNFREE_MEM)malloc(sizeof(UNFREE_MEM));
    unfreeMem->p = p;
    unfreeMem->next = NULL;
    
    unfreeList->tail_list->next = unfreeMem;
    unfreeList->tail_list = unfreeMem;
    unfreeList->unfree_count++;
    unfreeList->unfree_size += malloc_size(p);
    pthread_mutex_unlock(&global_mutex);
}

void freeMemInListSync(PUNFREE_LIST unfreeList, size_t freeNum)
{
    pthread_mutex_lock(&global_mutex);
    if (!unfreeList || freeNum <= 0) {
        pthread_mutex_unlock(&global_mutex);
        return;
    }
    
    if (!unfreeList->header_list->next) {
        pthread_mutex_unlock(&global_mutex);
        return;
    }
    
    for (int i = 0; i < freeNum && unfreeList->header_list->next; i++) {
        PUNFREE_MEM memToDelete = unfreeList->header_list->next;
        if (memToDelete == unfreeList->tail_list) {
            unfreeList->tail_list = unfreeList->header_list;
        }
        unfreeList->header_list->next = memToDelete->next;
        unfreeList->unfree_size -= malloc_size(memToDelete->p);
        unfreeList->unfree_count--;
        orig_free(memToDelete->p);
        orig_free(memToDelete);
    }
    pthread_mutex_unlock(&global_mutex);
}
