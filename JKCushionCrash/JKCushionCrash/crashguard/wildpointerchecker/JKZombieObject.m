//
//  WPCZombieObject.m
//  WildPointerCheckerDemo
//
//  modify by Jacken on 2022/8/26.
//  Copyright © 2016年 hdurtt. All rights reserved.
//

#import "JKZombieObject.h"
#import <objc/runtime.h>

@implementation JKZombieObject


- (BOOL)respondsToSelector:(SEL)aSelector{
    return [self.originClass instancesRespondToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [self.originClass instanceMethodSignatureForSelector:sel];
}

- (void)forwardInvocation: (NSInvocation *)invocation
{
    [self _throwMessageSentExceptionWithSelector: invocation.selector];
}

#define MIZombieThrowMesssageSentException() [self _throwMessageSentExceptionWithSelector: _cmd]

- (Class)class{
    MIZombieThrowMesssageSentException();
    return nil;
}
- (BOOL)isEqual:(id)object{
    MIZombieThrowMesssageSentException();
    return NO;
}
- (NSUInteger)hash{
    MIZombieThrowMesssageSentException();
    return 0;
}
- (id)self{
    MIZombieThrowMesssageSentException();
    return nil;
}
- (BOOL)isKindOfClass:(Class)aClass{
    MIZombieThrowMesssageSentException();
    return NO;
}
- (BOOL)isMemberOfClass:(Class)aClass{
    MIZombieThrowMesssageSentException();
    return NO;
}
- (BOOL)conformsToProtocol:(Protocol *)aProtocol{
    MIZombieThrowMesssageSentException();
    return NO;
}
- (BOOL)isProxy{
    MIZombieThrowMesssageSentException();
    return NO;
}

- (NSString *)description{
    MIZombieThrowMesssageSentException();
    return nil;
}

#pragma mark - MRC
- (instancetype)retain{
    MIZombieThrowMesssageSentException();
    return  nil;
}
- (oneway void)release{
    MIZombieThrowMesssageSentException();
}
- (void)dealloc
{
    MIZombieThrowMesssageSentException();
    [super dealloc];
}
- (NSUInteger)retainCount{
    MIZombieThrowMesssageSentException();
    return 0;
}
- (struct _NSZone *)zone{
    MIZombieThrowMesssageSentException();
    return  nil;
}

#pragma mark - private
- (void)_throwMessageSentExceptionWithSelector:(SEL)selector{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"(-[%@ %@]) was sent to a zombie object at address: %p", NSStringFromClass(self.originClass),NSStringFromSelector(selector), self] userInfo:nil];
}

@end
