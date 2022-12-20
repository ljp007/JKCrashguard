//
//  NSMutableArray+Crashguard.h
//  JKCushionCrash
//
//  Created by 林 on 2022/12/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (Crashguard)

+ (void)enableArrayMCrashguard;

@end

NS_ASSUME_NONNULL_END
