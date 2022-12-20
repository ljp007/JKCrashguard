//
//  NSArray+Crashguard.m
//  JKCushionCrash
//
//  Created by 林 on 2022/12/12.
//

#import "NSArray+Crashguard.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSArray (Crashguard)

+ (void)enableCrashGuard{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        @autoreleasepool {
            [objc_getClass("__NSArray0") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(safe_NSArray0_ObjectAtIndex:)];
            [objc_getClass("NSConstantArray") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(safe_NSConstantArray_objectAtIndex:)];
            [objc_getClass("__NSSingleObjectArrayI") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(safe_NSSingleObjectArrayI_objectAtIndex:)];
            [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndex:) swizzledSelector:@selector(safe_NSArrayI_objectAtIndex:)];
          
            
            
            [objc_getClass("__NSArray0") swizzleMethod:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(safe_NSArray0_objectAtIndexedSubscript:)];
            [objc_getClass("NSConstantArray") swizzleMethod:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(safe_NSConstantArray_objectAtIndexedSubscript:)];
            [objc_getClass("__NSSingleObjectArrayI") swizzleMethod:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(safe_NSSingleObjectArrayI_objectAtIndexedSubscript:)];
            [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndexedSubscript:) swizzledSelector:@selector(safe_NSArrayI_objectAtIndexedSubscript:)];
          
            
            
            [objc_getClass("__NSArray0") swizzleMethod:@selector(subarrayWithRange:) swizzledSelector:@selector(safe_NSArray0_subarrayWithRange:)];
            [objc_getClass("NSConstantArray") swizzleMethod:@selector(subarrayWithRange:) swizzledSelector:@selector(safe_NSConstantArray_subarrayWithRange:)];
            [objc_getClass("__NSSingleObjectArrayI") swizzleMethod:@selector(subarrayWithRange:) swizzledSelector:@selector(safe_NSSingleObjectArrayI_subarrayWithRange:)];
            [objc_getClass("__NSArrayI") swizzleMethod:@selector(subarrayWithRange:) swizzledSelector:@selector(safe_NSArrayI_subarrayWithRange:)];
         
        };
    });
}

- (id)safe_NSArray0_ObjectAtIndex:(NSInteger)index{
    
    return nil;
}

- (id)safe_NSConstantArray_objectAtIndex:(NSInteger)index{
    if(index >= self.count || index < 0){
        return nil;
    }
    return [self safe_NSConstantArray_objectAtIndex:index];
}

- (id)safe_NSSingleObjectArrayI_objectAtIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        
        return nil;
    }
    return [self safe_NSSingleObjectArrayI_objectAtIndex:index];
}

- (id)safe_NSArrayI_objectAtIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        
        return nil;
    }
    return [self safe_NSArrayI_objectAtIndex:index];
}

- (id)safe_NSArrayM_objectAtIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        
        return nil;
    }
    return [self safe_NSArrayM_objectAtIndex:index];
}


-(id)safe_NSArray0_objectAtIndexedSubscript:(NSUInteger)index{
    
    return nil;
}

- (id)safe_NSConstantArray_objectAtIndexedSubscript:(NSUInteger)index{
    if(index >= self.count || index < 0){
        return nil;
    }
    return [self safe_NSConstantArray_objectAtIndexedSubscript:index];
}

-(id)safe_NSSingleObjectArrayI_objectAtIndexedSubscript:(NSInteger)index{
    if (index >= self.count || index < 0) {
    
        return nil;
    }
    return [self safe_NSSingleObjectArrayI_objectAtIndexedSubscript:index];
}

-(id)safe_NSArrayI_objectAtIndexedSubscript:(NSInteger)index{
    if (index >= self.count || index < 0) {
    
        return nil;
    }
    return [self safe_NSArrayI_objectAtIndexedSubscript:index];
}

-(id)safe_NSArrayM_objectAtIndexedSubscript:(NSInteger)index{
    if (index >= self.count || index < 0) {
    
        return nil;
    }
    return [self safe_NSArrayM_objectAtIndexedSubscript:index];
}
    
- (NSArray<id> *)safe_NSArray0_subarrayWithRange:(NSRange)range {
    return nil;
}


- (NSArray<id> *)safe_NSConstantArray_subarrayWithRange:(NSRange)range {
    NSRange newRange = range;
    if (range.location < 0) {
        newRange.location = 0;
        
    }
    if (newRange.location + newRange.length > self.count) {
        newRange.length = self.count - newRange.location;
        
    }
    return [self safe_NSConstantArray_subarrayWithRange:newRange];
}

    
- (NSArray<id> *)safe_NSSingleObjectArrayI_subarrayWithRange:(NSRange)range {
    NSRange newRange = range;
    if (range.location < 0) {
        newRange.location = 0;
        
    }
    if (newRange.location + newRange.length > self.count) {
        newRange.length = self.count - newRange.location;
        
    }
    return [self safe_NSSingleObjectArrayI_subarrayWithRange:newRange];
}

- (NSArray<id> *)safe_NSArrayI_subarrayWithRange:(NSRange)range {
    NSRange newRange = range;
    if (range.location < 0) {
        newRange.location = 0;
        
    }
    if (newRange.location + newRange.length > self.count) {
        newRange.length = self.count - newRange.location;
    }
    return [self safe_NSArrayI_subarrayWithRange:newRange];
}

- (NSArray<id> *)safe_NSArrayM_subarrayWithRange:(NSRange)range {
    NSRange newRange = range;
    if (range.location < 0) {
        newRange.location = 0;
        
    }
    if (newRange.location + newRange.length > self.count) {
        newRange.length = self.count - newRange.location;
    }
    return [self safe_NSArrayM_subarrayWithRange:newRange];
}

@end
