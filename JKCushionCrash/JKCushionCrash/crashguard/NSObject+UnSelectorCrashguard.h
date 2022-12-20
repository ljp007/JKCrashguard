//
//  NSObject+UnSelectorCrashguard.h
//  JKCushionCrash
//
//  Created by 林 on 2022/12/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKUnrecognizedSelectorSolveObject : NSObject

@property(nonatomic,weak) NSObject * objc;

@end

@interface NSObject (UnSelectorCrashguard)

+ (void)enableGrashguard;

@end

NS_ASSUME_NONNULL_END
