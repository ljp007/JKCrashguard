//
//  NSString+Crashguard.m
//  JKCushionCrash
//
//  Created by 林 on 2022/12/15.
//

#import "NSString+Crashguard.h"
#import "NSObject+Swizzling.h"
#import "NSString+Crashguard.h"
#import <objc/runtime.h>

@implementation NSString (Crashguard)

+ (void)enableCrashguard{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSCFConstantString") swizzleMethod:@selector(substringFromIndex:) swizzledSelector:@selector(safe_NSCFConstantString_substringFromIndex:)];
            [objc_getClass("__NSCFConstantString") swizzleMethod:@selector(substringToIndex:) swizzledSelector:@selector(safe_NSCFConstantString_substringToIndex:)];
            [objc_getClass("__NSCFConstantString") swizzleMethod:@selector(substringWithRange:) swizzledSelector:@selector(safe_NSCFConstantString_substringWithRange:)];
            [objc_getClass("__NSCFConstantString") swizzleMethod:@selector(rangeOfString:options:range:locale:) swizzledSelector:@selector(safe_NSCFConstantString_rangeOfString:options:range:locale:)];
            [objc_getClass("__NSCFConstantString") swizzleMethod:@selector(hasSuffix:) swizzledSelector:@selector(safe_hasSuffix:)];
            [objc_getClass("__NSCFConstantString") swizzleMethod:@selector(hasPrefix:) swizzledSelector:@selector(safe_hasPrefix:)];

            [objc_getClass("NSTaggedPointerString") swizzleMethod:@selector(substringFromIndex:) swizzledSelector:@selector(safe_NSTaggedPointerString_substringFromIndex:)];
            [objc_getClass("NSTaggedPointerString") swizzleMethod:@selector(substringToIndex:) swizzledSelector:@selector(safe_NSTaggedPointerString_substringToIndex:)];
            [objc_getClass("NSTaggedPointerString") swizzleMethod:@selector(substringWithRange:) swizzledSelector:@selector(safe_NSTaggedPointerString_substringWithRange:)];
            [objc_getClass("NSTaggedPointerString") swizzleMethod:@selector(rangeOfString:options:range:locale:) swizzledSelector:@selector(safe_NSTaggedPointerString_rangeOfString:options:range:locale:)];
            
            
            [objc_getClass("NSPlaceholderString") swizzleMethod:@selector(initWithString:) swizzledSelector:@selector(safe_initWithString:)];
        }
    });
}

- (NSString*)safe_NSCFConstantString_substringFromIndex:(NSInteger)from{
    // 保证有数据返回
    NSUInteger fromIndex = MIN(self.length, from);
    return [self safe_NSCFConstantString_substringFromIndex:fromIndex];
    
}
- (NSString*)safe_NSCFConstantString_substringToIndex:(NSUInteger)to {
    // 保证有数据返回
    NSUInteger toIndex = MIN(self.length, to);
    return [self safe_NSCFConstantString_substringToIndex:toIndex];
}

- (NSString *)safe_NSCFConstantString_substringWithRange:(NSRange)range{
    if (range.location > self.length) {
        return nil;
    }
    if (range.length > self.length) {
        return nil;
    }
    if ((range.location + range.length) > self.length) {
        return nil;
    }
    return [self safe_NSCFConstantString_substringWithRange:range];
    
}

- (NSRange)safe_NSCFConstantString_rangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToSearch locale:(nullable NSLocale *)locale{
    if (!searchString) {
        return NSMakeRange(0, 0);
    }
    if ((rangeOfReceiverToSearch.location + rangeOfReceiverToSearch.length) > self.length) {
        return NSMakeRange(0, 0);
    }
    return [self safe_NSCFConstantString_rangeOfString:searchString options:mask range:rangeOfReceiverToSearch locale:locale];
}


- (NSString*)safe_NSTaggedPointerString_substringFromIndex:(NSInteger)from{
    // 保证有数据返回
    NSUInteger fromIndex = MIN(self.length, from);
    return [self safe_NSTaggedPointerString_substringFromIndex:fromIndex];
    
}
- (NSString*)safe_NSTaggedPointerString_substringToIndex:(NSUInteger)to {
    // 保证有数据返回
    NSUInteger toIndex = MIN(self.length, to);
    return [self safe_NSTaggedPointerString_substringToIndex:toIndex];
}

- (NSString *)safe_NSTaggedPointerString_substringWithRange:(NSRange)range{
    if (range.location > self.length) {
        return nil;
    }
    if (range.length > self.length) {
        return nil;
    }
    if ((range.location + range.length) > self.length) {
        return nil;
    }
    return [self safe_NSTaggedPointerString_substringWithRange:range];
    
}

- (NSRange)safe_NSTaggedPointerString_rangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToSearch locale:(nullable NSLocale *)locale{
    if (!searchString) {
        return NSMakeRange(0, 0);
    }
    if ((rangeOfReceiverToSearch.location + rangeOfReceiverToSearch.length) > self.length) {
        return NSMakeRange(0, 0);
    }
    return [self safe_NSTaggedPointerString_rangeOfString:searchString options:mask range:rangeOfReceiverToSearch locale:locale];
}

- (instancetype)safe_initWithString:(NSString *)aString{
    if (aString == nil) {
        return nil;
    }
    return [self safe_initWithString:aString];
}

- (BOOL)safe_hasPrefix:(NSString *)str{
    if (str == nil) {
        return NO;
    }
    return [self safe_hasPrefix:str];
}
- (BOOL)safe_hasSuffix:(NSString *)str{
    if (str == nil) {
        return NO;
    }
    return [self safe_hasSuffix:str];
    
}



@end
