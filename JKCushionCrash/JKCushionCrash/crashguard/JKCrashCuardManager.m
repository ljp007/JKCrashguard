//
//  JKCrashCuardManager.m
//  JKCushionCrash
//
//  Created by 林 on 2022/12/12.
//

#import "JKCrashCuardManager.h"
#import "NSArray+Crashguard.h"
#import "NSMutableArray+Crashguard.h"
#import "NSDictionary+Crashguard.h"
#import "NSMutableSet+Crashguard.h"
#import "NSMutableAttributedString+Crashguard.h"
#import "NSMutableString+Crashguard.h"
#import "NSString+Crashguard.h"
#import "UIView+Crashgurad.h"
#import "NSObject+KVOCrashguard.h"
#import "UIView+AddSelfViewCrashguard.h"
#import "JKWildPointerManger.h"

@implementation JKCrashCuardManager

+ (instancetype)shareIntance{
    static id instance = nil;
     static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)enableCrashGuardWithType:(JKCrashGuardType)type{
    
    if(type | JKCrashGuardTypeNone){
        //return;
    }
    
    if(type | JKCrashGuardTypeAll){
        [NSArray enableCrashGuard];
        [NSMutableArray enableArrayMCrashguard];
        [NSDictionary enableCrashguard];
        [NSMutableSet enableCrashguard];
        [NSMutableAttributedString enableCrashguard];
        [NSMutableString enableCrashguard];
        [NSString enableCrashguard];
        [UIView enableCrashguard];
        [NSObject enableKVOCrashguard];
        [UIView enableAddSelfCrashguard];
        //[[JKWildPointerManger shareIntance] enableBadAcessCrashguard];
        [NSTimer enableKVOCrashguard];
    }
    
    if(type | JKCrashGuardTypeContainer){
        [NSArray enableCrashGuard];
        [NSMutableArray enableCrashGuard];
        [NSMutableSet enableCrashguard];
        [NSDictionary enableCrashguard];
    }
    
    if(type | JKCrashGuardTypeUIView){
        [UIView enableCrashguard];
    }
    
    if(type | JKCrashGuardTypeNSString){
        [NSString enableCrashguard];
        [NSMutableString enableCrashguard];
    }
    
    if(type | JKCrashGuardTypeNSAttributedString){
        [NSMutableAttributedString enableCrashguard];
    }
    
    if(type | JKCrashGuardTypeUnrecognizedSelector){
        [NSObject enableKVOCrashguard];
    }
    
    if(type | JKCrashGuardTypeKVODelloc){
        [NSObject enableKVOCrashguard];
    }
    
    if(type | JKCrashGuardTypeAddSelfSubView){
        [UIView enableAddSelfCrashguard];
    }
    
    if(type | JKCrashGuardTypeBadacess){
        //[[JKWildPointerManger shareIntance] enableBadAcessCrashguard];
    }
    
    if(type | JKCrashGuardTypeNSTimer){
        [NSTimer enableKVOCrashguard];
    }
}

@end
