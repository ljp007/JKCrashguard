//
//  NSObject+KVOCrashguard.m
//  JKCushionCrash
//
//  Created by 林 on 2022/12/17.
//

#import "NSObject+KVOCrashguard.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSObject (KVOCrashguard)

+ (void)enableKVOCrashguard{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            
            [objc_getClass("NSObject") swizzleMethod:@selector(removeObserver:forKeyPath:) swizzledSelector:@selector(safe_removeObserver:forKeyPath:)];
            [objc_getClass("NSObject") swizzleMethod:@selector(addObserver:forKeyPath:options:context:) swizzledSelector:@selector(safe_addObserver:forKeyPath:options:context:)];
            
        }
        
    });
}

// 交换后的方法
- (void)safe_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    if ([self observerKeyPath:keyPath observer:observer]) {
        [self safe_removeObserver:observer forKeyPath:keyPath];
    }
}


// 交换后的方法
- (void)safe_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    
    objc_setAssociatedObject(self, "addObserverFlag", @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (![self observerKeyPath:keyPath observer:observer]) {
        [self safe_addObserver:observer forKeyPath:keyPath options:options context:context];
    }
}


// 进行检索获取Key
- (BOOL)observerKeyPath:(NSString *)key observer:(id )observer
{
    id info = self.observationInfo;
    NSArray *array = [info valueForKey:@"_observances"];
    for (id objc in array) {
        id Properties = [objc valueForKeyPath:@"_property"];
        id newObserver = [objc valueForKeyPath:@"_observer"];
        
        NSString *keyPath = [Properties valueForKeyPath:@"_keyPath"];
        if ([key isEqualToString:keyPath] && [newObserver isEqual:observer]) {
            return YES;
        }
    }
    return NO;
}


@end
