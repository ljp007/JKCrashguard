//
//  JKWildPointerManger.h
//  JKCushionCrash
//
//  Created by 林 on 2022/12/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKWildPointerManger : NSObject

+ (instancetype)shareIntance;

- (void)enableBadAcessCrashguard;

- (void)stopCheckWildPoint;

@end

NS_ASSUME_NONNULL_END
