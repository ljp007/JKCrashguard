//
//  NSObject+Swizzling.m
//  JKCushionCrash
//
//  Created by 林 on 2022/12/12.
//

#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzling)

+ (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector{
    
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzleMethod = class_getInstanceMethod(class, swizzledSelector);
    
    //先尝试給源SEL添加IMP，这里是为了避免源SEL没有实现IMP的情况
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    
    if(didAddMethod){ //添加成功：说明源SEL没有实现IMP，将源SEL的IMP替换到交换SEL的IMP
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }else{//添加失败：说明源SEL已经有IMP，直接将两个SEL的IMP交换即可
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
    
    
}

+ (void)swizzleClassMethod:(SEL)originalSelector swizzledSelector:(nonnull SEL)swizzledSelector{
    Class class = [self class];
    
    // Method中包含IMP函数指针，通过替换IMP，使SEL调用不同函数实现
    Method origMethod = class_getClassMethod(class, originalSelector);
    Method replaceMeathod = class_getClassMethod(class, swizzledSelector);
    Class metaKlass = objc_getMetaClass(NSStringFromClass(class).UTF8String);

    // class_addMethod:如果发现方法已经存在，会失败返回，也可以用来做检查用,我们这里是为了避免源方法没有实现的情况;如果方法没有存在,我们则先尝试添加被替换的方法的实现
    BOOL didAddMethod = class_addMethod(metaKlass,
                                        originalSelector,
                                        method_getImplementation(replaceMeathod),
                                        method_getTypeEncoding(replaceMeathod));
    if (didAddMethod) {
        // 原方法未实现，则替换原方法防止crash
        class_replaceMethod(metaKlass,
                            swizzledSelector,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
    }else {
        // 添加失败：说明源方法已经有实现，直接将两个方法的实现交换即
        method_exchangeImplementations(origMethod, replaceMeathod);
    }
}


@end
