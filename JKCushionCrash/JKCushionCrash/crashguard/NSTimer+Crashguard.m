//
//  NSTimer+Crashguard.m
//  JKCushionCrash
//
//  Created by 林 on 2022/12/20.
//

#import "NSTimer+Crashguard.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>
#import "YYWeakProxy.h"

@implementation NSTimer (Crashguard)

+ (void)enableCrashguard{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        [objc_getClass("NSTimer") swizzleClassMethod:@selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:) swizzledSelector:@selector(safe_scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:)];
        
        //// 创建一个定时器，但是么有添加到运行循环，我们需要在创建定时器后手动的调用 NSRunLoop 对象的 addTimer:forMode: 方法。
        [objc_getClass("NSTimer") swizzleClassMethod:@selector(timerWithTimeInterval:target:selector:userInfo:repeats:) swizzledSelector:@selector(safe_timerWithTimeInterval:target:selector:userInfo:repeats:)];
    });
}

+ (NSTimer *)safe_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats {
//    NSLog(@"CrashProtector - warring: wo_scheduledTimerWithTimeInterval");
    return [self safe_scheduledTimerWithTimeInterval:timeInterval target:[YYWeakProxy proxyWithTarget:target] selector:selector userInfo:userInfo repeats:repeats];
}

+ (NSTimer *)safe_timerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo {
    
    NSLog(@"CrashProtector - warring: wo_timerWithTimeInterval");
    return [self safe_timerWithTimeInterval:timeInterval target:[YYWeakProxy proxyWithTarget:target] selector:aSelector userInfo:userInfo repeats:yesOrNo];
}


@end
