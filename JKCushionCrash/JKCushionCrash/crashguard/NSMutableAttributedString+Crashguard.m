//
//  NSMutableAttributedString+Crashguard.m
//  JKCushionCrash
//
//  Created by 林 on 2022/12/13.
//

#import "NSMutableAttributedString+Crashguard.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSMutableAttributedString (Crashguard)


+ (void)enableCrashguard{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("NSConcreteMutableAttributedString") swizzleMethod:@selector(replaceCharactersInRange:withString:) swizzledSelector:@selector(alert_replaceCharactersInRange:withString:)];
            [objc_getClass("NSConcreteMutableAttributedString") swizzleMethod:@selector(initWithString:) swizzledSelector:@selector(alert_replaceInitWithString:)];

        }
    });
}

- (void)alert_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    if ((range.location + range.length) > self.length) {
        return;
    }
    if (!aString) {
        return;
    }
    return [self alert_replaceCharactersInRange:range withString:aString];
}

-(instancetype)alert_replaceInitWithString:(NSString *)aString{
    if (!aString) {
        return nil;
    }
    return [self alert_replaceInitWithString:aString];
}


@end
