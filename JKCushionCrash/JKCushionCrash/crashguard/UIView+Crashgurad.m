//
//  UIView+Crashgurad.m
//  JKCushionCrash
//
//  Created by 林 on 2022/12/15.
//

#import "UIView+Crashgurad.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation UIView (Crashgurad)

+ (void)enableCrashguard {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("UIView") swizzleMethod:@selector(setNeedsLayout) swizzledSelector:@selector(safe_setNeedsLayout)];
            [objc_getClass("UIView") swizzleMethod:@selector(setNeedsDisplay) swizzledSelector:@selector(safe_setNeedsDisplay)];
            [objc_getClass("UIView") swizzleMethod:@selector(setFrame:) swizzledSelector:@selector(safe_setFrame:)];
            [objc_getClass("UIView") swizzleMethod:@selector(initWithFrame:) swizzledSelector:@selector(safe_initWithFrame:)];
            
        }
    });
}

-(void)safe_setNeedsLayout{
    if ([NSThread isMainThread]) {
        return [self safe_setNeedsLayout];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            return [self safe_setNeedsLayout];
        });
    }
}

-(void)safe_setNeedsDisplay{
    if ([NSThread isMainThread]) {
        return [self safe_setNeedsDisplay];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            return [self safe_setNeedsDisplay];
        });
    }
}

-(BOOL)isFrameInvalid:(CGRect)frame
{
    if (frame.origin.x == INFINITY||frame.origin.x == -INFINITY||isnan(frame.origin.x)  ||
        frame.origin.y == INFINITY||frame.origin.y == -INFINITY||isnan(frame.origin.y) ||
        frame.size.width == INFINITY||frame.size.width <0 || isnan(frame.size.width) ||
        frame.size.height == INFINITY||frame.size.height <0 || isnan(frame.size.height)) {
        return YES;
    }

    return NO;
}
-(void)safe_setFrame:(CGRect)frame{
    
    if ([self isFrameInvalid:frame]) {
        return [self safe_setFrame:CGRectZero];
    }
    return [self safe_setFrame:frame];
}

-(instancetype)safe_initWithFrame:(CGRect)frame
{
    if ([self isFrameInvalid:frame]) {
        return [self safe_initWithFrame:CGRectZero];
    }
    return  [self safe_initWithFrame:frame];
}


@end
