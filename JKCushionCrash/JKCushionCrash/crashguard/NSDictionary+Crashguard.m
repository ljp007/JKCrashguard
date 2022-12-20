//
//  NSDictionary+Crashguard.m
//  JKCushionCrash
//
//  Created by 林 on 2022/12/13.
//

#import "NSDictionary+Crashguard.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSDictionary (Crashguard)

+ (void)enableCrashguard {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSPlaceholderDictionary") swizzleMethod:@selector(initWithObjects:forKeys:count:) swizzledSelector:@selector(safe_initWithObjects:forKeys:count:)];
            [objc_getClass("__NSDictionaryM") swizzleMethod:@selector(setObject:forKey:) swizzledSelector:@selector(safe_setObject:forKey:)];
            [objc_getClass("__NSDictionaryM") swizzleMethod:@selector(removeObjectForKey:) swizzledSelector:@selector(safe_removeObjectForKey:)];
        }
    });
}

- (instancetype)safe_initWithObjects:(id *)objects forKeys:(id<NSCopying> *)keys count:(NSUInteger)count{
    NSUInteger rightCount = 0;
    for (NSUInteger i = 0; i < count; i++) {
        if (!(keys[i] && objects[i])) {
            break;
        }else{
            rightCount++;
        }
    }
    return [self safe_initWithObjects:objects forKeys:keys count:rightCount];
}

- (void)safe_setObject:(id)object forKey:(id<NSCopying>)key{
    if ((!object) || (!key)) {
      return;
    }
    return [self safe_setObject:object forKey:key];
}

- (void)safe_removeObjectForKey:(id)key{
    if (!key) {
        return;
    }
    return [self safe_removeObjectForKey:key];
}


@end
