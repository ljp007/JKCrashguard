//
//  JKWildPointerManger.m
//  JKCushionCrash
//
//  Created by 林 on 2022/12/19.
//

#import "JKWildPointerManger.h"
#import "JKWildPointerChecker.h"
#import <UIKit/UIKit.h>

@implementation JKWildPointerManger

+ (instancetype)shareIntance{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return  instance;
}

- (instancetype)init{
    self = [super init];
    if(self){
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil]; //回到后台释放掉一部分
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
    }
    return self;
}

- (void)enableBadAcessCrashguard{
    startWildPointerCheck();
}

- (void)stopCheckWildPoint{
    stopWildPointerCheck();
}

- (void)applicationDidEnterBackground:(NSNotification *)notifycation{
    
}

- (void)applicationDidReceiveMemoryWarning:(NSNotification *)notifycation{
    
}

@end
