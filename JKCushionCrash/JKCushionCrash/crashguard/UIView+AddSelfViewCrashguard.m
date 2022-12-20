//
//  UIView+AddSelfViewCrashguard.m
//  JKCushionCrash
//
//  Created by 林 on 2022/12/17.
//

#import "UIView+AddSelfViewCrashguard.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation UIView (AddSelfViewCrashguard)

+ (void)enableAddSelfCrashguard{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("UIView") swizzleMethod:@selector(addSubview:) swizzledSelector:@selector(safe_addSubview:)];
    });
    
}

- (void)safe_addSubview:(UIView *)view{
    if(self == view){
        return;
    }
    [self safe_addSubview:view];
}

@end
