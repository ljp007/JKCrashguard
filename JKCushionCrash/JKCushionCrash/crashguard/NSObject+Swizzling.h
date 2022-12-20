//
//  NSObject+Swizzling.h
//  JKCushionCrash
//
//  Created by 林 on 2022/12/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Swizzling)

+ (void)swizzleMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

+ (void)swizzleClassMethod:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;



@end

NS_ASSUME_NONNULL_END
