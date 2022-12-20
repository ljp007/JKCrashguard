//
//  NSMutableSet+Crashguard.m
//  JKCushionCrash
//
//  Created by 林 on 2022/12/13.
//

#import "NSMutableSet+Crashguard.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSMutableSet (Crashguard)

+ (void)enableCrashguard{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSSetM") swizzleMethod:@selector(addObject:) swizzledSelector:@selector(safe_addObject:)];
            [objc_getClass("__NSSetM") swizzleMethod:@selector(removeObject:) swizzledSelector:@selector(safe_removeObject:)];
        };
    });
}

- (void)safe_addObject:(id)object{
    if(!object){
        return;
    }
    [self safe_addObject:object];
}

- (void)safe_removeObject:(id)object{
    if(!object){
        return;
    }
    [self safe_removeObject:object];
}

@end
