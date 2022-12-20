//
//  JKCrashCuardManager.h
//  JKCushionCrash
//
//  Created by 林 on 2022/12/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger,JKCrashGuardType){
    JKCrashGuardTypeNone = 0,
    JKCrashGuardTypeAll  = 0xffffff,
    JKCrashGuardTypeBadacess = 1 << 1, // 野指针
    JKCrashGuardTypeUnrecognizedSelector = 1 << 2, //无法识别的函数
    JKCrashGuardTypeAddSelfSubView = 1 << 3,//添加自己为子视图
    JKCrashGuardTypeUIView = 1 << 4, //子线程刷新UI
    JKCrashGuardTypeContainer = 1 << 5, //容器异常，如数组越界等,
    JKCrashGuardTypeNSString  = 1 << 6, //字符串异常
    JKCrashGuardTypeNSAttributedString = 1 << 7,
    JKCrashGuardTypeKVODelloc = 1 << 8, //KVO 异常
    JKCrashGuardTypeNSTimer = 1 << 9
};


@interface JKCrashCuardManager : NSObject

+ (instancetype)shareIntance;

- (void)enableCrashGuardWithType:(JKCrashGuardType)type;


@end

NS_ASSUME_NONNULL_END
