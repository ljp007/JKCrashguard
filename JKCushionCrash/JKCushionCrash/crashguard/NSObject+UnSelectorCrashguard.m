//
//  NSObject+UnSelectorCrashguard.m
//  JKCushionCrash
//
//  Created by 林 on 2022/12/13.
//

#import "NSObject+UnSelectorCrashguard.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"

@interface JKUnrecognizedSelectorSolveObject()

@end

@implementation JKUnrecognizedSelectorSolveObject


+ (BOOL)resolveInstanceMethod:(SEL)sel{
    class_addMethod([self class], sel, (IMP)addMethod, "v@:@");
    return YES;
}

id addMethod(id self,SEL _cmd){
    NSLog(@"JKUnrecognizedSelectorSolveObject: unrecognized selector: %@", NSStringFromSelector(_cmd)); //消息转发机制
    return 0;
}


@end

@implementation NSObject (UnSelectorCrashguard)

+ (void)enableGrashguard{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("NSObject") swizzleMethod:@selector(forwardingTargetForSelector:) swizzledSelector:@selector(replace_forwardingTargetForSelector:)];
    });
}

- (id)replace_forwardingTargetForSelector:(SEL)selector {
    
    //if(whitelist) 这这里可以添加白名单过滤
    
    if (class_respondsToSelector([self class], @selector(forwardInvocation:))) {
        IMP impOfNSObject = class_getMethodImplementation([NSObject class], @selector(forwardInvocation:));
        IMP imp = class_getMethodImplementation([self class], @selector(forwardInvocation:));
        if (imp != impOfNSObject) {
            //NSLog(@"class has implemented invocation");
            return nil;
        }
    }
    
    JKUnrecognizedSelectorSolveObject * solveObject = [[JKUnrecognizedSelectorSolveObject alloc] init];
    solveObject.objc = self;
    return solveObject;
}

@end
