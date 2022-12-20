//
//  NSMutableString+Crashguard.m
//  JKCushionCrash
//
//  Created by 林 on 2022/12/15.
//

#import "NSMutableString+Crashguard.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSMutableString (Crashguard)

+ (void)enableCrashguard{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSCFString") swizzleMethod:@selector(substringFromIndex:) swizzledSelector:@selector(safe_substringFromIndex:)];
            [objc_getClass("__NSCFString") swizzleMethod:@selector(substringToIndex:) swizzledSelector:@selector(safe_substringToIndex:)];
            [objc_getClass("__NSCFString") swizzleMethod:@selector(substringWithRange:) swizzledSelector:@selector(safe_substringWithRange:)];
            [objc_getClass("__NSCFString") swizzleMethod:@selector(rangeOfString:options:range:locale:) swizzledSelector:@selector(safe_rangeOfString:options:range:locale:)];
            [objc_getClass("__NSCFString") swizzleMethod:@selector(replaceCharactersInRange:withString:) swizzledSelector:@selector(safe_replaceCharactersInRange:withString:)];
            [objc_getClass("__NSCFString") swizzleMethod:@selector(insertString:atIndex:) swizzledSelector:@selector(safe_insertString:atIndex:)];

            [objc_getClass("__NSCFString") swizzleMethod:@selector(objectForKeyedSubscript:) swizzledSelector:@selector(safe_objectForKeyedSubscript:)];
        }
    });
}

- (NSString*)safe_substringFromIndex:(NSInteger)from{
    // 保证有数据返回
    NSUInteger fromIndex = MIN(self.length, from);
    return [self safe_substringFromIndex:fromIndex];
    
}
- (NSString*)safe_substringToIndex:(NSUInteger)to {
    // 保证有数据返回
    NSUInteger toIndex = MIN(self.length, to);
    return [self safe_substringToIndex:toIndex];
}

- (NSString *)safe_substringWithRange:(NSRange)range{
    if (range.location > self.length) {
        return nil;
    }
    if (range.length > self.length) {
        return nil;
    }
    if ((range.location + range.length) > self.length) {
        return nil;
    }
    return [self safe_substringWithRange:range];
}

- (NSRange)safe_rangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToSearch locale:(nullable NSLocale *)locale{
    if (!searchString) {
        return NSMakeRange(0, 0);
    }
    if ((rangeOfReceiverToSearch.location + rangeOfReceiverToSearch.length) > self.length) {
        return NSMakeRange(0, 0);
    }
    return [self safe_rangeOfString:searchString options:mask range:rangeOfReceiverToSearch locale:locale];
}


- (void)safe_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString{
    if (range.location > self.length) {
        return ;
    }
    if (range.length > self.length) {
        return ;
    }
    if ((range.location + range.length) > self.length) {
        return ;
    }
    if (!aString) {
        return;
    }
    return [self safe_replaceCharactersInRange:range withString:aString];
}

- (void)safe_insertString:(NSString *)aString atIndex:(NSInteger)loc{
    if(loc<0||loc>self.length){
        return;
    }
    return [self safe_insertString:aString atIndex:loc];
}

- (id)safe_objectForKeyedSubscript:(NSString *)key {
    return nil;
}


@end
