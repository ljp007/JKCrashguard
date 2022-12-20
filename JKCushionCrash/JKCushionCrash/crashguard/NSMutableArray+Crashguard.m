//
//  NSMutableArray+Crashguard.m
//  JKCushionCrash
//
//  Created by 林 on 2022/12/12.
//

#import "NSMutableArray+Crashguard.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Crashguard)

+ (void)enableArrayMCrashguard{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(safe_objectAtIndex:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(insertObject:atIndex:) swizzledSelector:@selector(safe_insertObject:atIndex:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(setObject:atIndexedSubscript:) swizzledSelector:@selector(safe_setObject:atIndexedSubscript:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(replaceObjectAtIndex:withObject:) swizzledSelector:@selector(safe_replaceObjectAtIndex:withObject:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(removeObjectAtIndex:) swizzledSelector:@selector(safe_removeObjectAtIndex:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(removeObjectsInRange:) swizzledSelector:@selector(safe_removeObjectsInRange:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(removeObject:inRange:) swizzledSelector:@selector(safe_removeObject:inRange:)];
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(safe_objectAtIndexedSubscript:)];
            
            [objc_getClass("__NSArrayM") swizzleMethod:@selector(subarrayWithRange:) swizzledSelector:@selector(safe_subarrayWithRange:)];
        }
    });
}

- (id)safe_objectAtIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        return nil;
    }
    return [self safe_objectAtIndex:index];
}

- (void)safe_insertObject:(id)object atIndex:(NSInteger)index{
    if (index > self.count || index < 0) {
        return ;
    }
    if (!object) {
        return;
    }
    return [self safe_insertObject:object atIndex:index];
}

- (void)safe_setObject:(id)object atIndexedSubscript:(NSInteger)index{
    if (index > self.count || index < 0) {
        return ;
    }
    if (!object) {
        return;
    }
    return [self safe_setObject:object atIndexedSubscript:index];
}

- (void)safe_replaceObjectAtIndex:(NSInteger)index withObject:(id)anObject{
    if (index >= self.count || index < 0) {
        return ;
    }
    if (!anObject) {
        return;
    }
    return [self safe_replaceObjectAtIndex:index withObject:anObject];
}


- (void)safe_removeObjectAtIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        return ;
    }
    return [self safe_removeObjectAtIndex:index];
}

- (void)safe_removeObjectsInRange:(NSRange)range {
    if (range.location > self.count) {
        return;
    }
    if (range.length > self.count) {
        return;
    }
    if ((range.location + range.length) > self.count) {
        return;
    }
    return [self safe_removeObjectsInRange:range];
}

- (void)safe_removeObject:(id)anObject inRange:(NSRange)range{
    if (range.location > self.count) {
        return;
    }
    if (range.length > self.count) {
        return;
    }
    if ((range.location + range.length) > self.count) {
        return;
    }
    if (!anObject){
        return;
    }
    return [self safe_removeObject:anObject inRange:range];
}

- (id)safe_objectAtIndexedSubscript:(NSInteger)index{
    if (index >= self.count || index < 0) {
        return nil;
    }
    return [self safe_objectAtIndexedSubscript:index];
}

    
- (NSArray<id> *)safe_subarrayWithRange:(NSRange)range {
    NSRange newRange = range;
    if (newRange.location >= self.count ) {
        newRange.location = 0;
    }
    if (newRange.location + newRange.length > self.count) {
        newRange.length = self.count - newRange.location;
    }
    return [self safe_subarrayWithRange:newRange];
}


@end
