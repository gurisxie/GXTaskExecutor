//
//  GXThreadSafeMutableArray.m
//  StudyApp
//
//  Created by GurisXie on 2022/5/18.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import "GXThreadSafeMutableArray.h"


#define GXRD_LOCKED(...)                                                                                                         \
pthread_rwlock_rdlock(&s_pthread_rwlock_t);                                                                                     \
__VA_ARGS__;                                                                                                                   \
pthread_rwlock_unlock(&s_pthread_rwlock_t);

#define GXWR_LOCKED(...)                                                                                                         \
pthread_rwlock_wrlock(&s_pthread_rwlock_t);                                                                                    \
__VA_ARGS__;                                                                                                                   \
pthread_rwlock_unlock(&s_pthread_rwlock_t);



@implementation GXThreadSafeMutableArray

-(instancetype)init {
    pthread_rwlock_init(&s_pthread_rwlock_t,NULL);
    return [self initWithCapacity:0];
}

-(instancetype)initWithArry:(NSArray *)array {
    self = [super init];
    if(self)
    {
        pthread_rwlock_init(&s_pthread_rwlock_t, NULL);
        _mutableArry = [[NSMutableArray alloc] initWithArray: array copyItems:YES];
    }
    return self;
}

-(void)dealloc {
    pthread_rwlock_destroy(&s_pthread_rwlock_t);
}


-(instancetype)initWithCapacity: (NSUInteger) capacity {
    if ((self = [super init])){
        _mutableArry = [[NSMutableArray alloc] initWithCapacity:capacity];
    }
    return self;
    
}

-(BOOL) containsObject: (id)anObject{
    GXWR_LOCKED(BOOL contains = [_mutableArry containsObject:anObject]);
    return contains;
    
}

-(void)addObject: (id)anObject
{
    GXWR_LOCKED([_mutableArry addObject: anObject]);
}

-(void)removeObjectsInRange:(NSRange)range
{
    GXWR_LOCKED(
    NSInteger count = _mutableArry.count;
    if(range.location < count && (range.location + range.length) <= count){
        [_mutableArry removeObjectsInRange:range];
    }
                );
}

-(void)removeObjectAtIndex: (NSUInteger) index
{
    GXWR_LOCKED(
                NSInteger count = _mutableArry.count;
                if (index < count) {
                    [_mutableArry removeObjectAtIndex: index];
                }
            );
}


-(id)removeAndReturnAllObjects
{
    GXWR_LOCKED (NSArray *array = [_mutableArry copy]; [_mutableArry removeAllObjects];);
    
                    return array;
}


-(void)removeObject: (id)anObject {
    if (!anObject) {
        return;
    }
    GXWR_LOCKED(
                if([ _mutableArry containsObject:anObject])
                {
                    [ _mutableArry removeObject:anObject];
                }
                );
}

-(void)removeAllObjects
{
    GXRD_LOCKED(
    [_mutableArry removeAllObjects];
                );
}

-(void)removeLastObject
{
    GXRD_LOCKED(
    [_mutableArry removeLastObject];
                );
}

-(id)objectAtIndex:(NSUInteger)index
{
    GXRD_LOCKED(
    id obj = nil;
    if(index < _mutableArry.count){
        obj = [_mutableArry objectAtIndex:index];
    }
    );
    return obj;
}

-(NSUInteger)count
{
    GXRD_LOCKED(
    NSUInteger count = _mutableArry.count;
    );
    return count;
}

-(void)enumerateObjectsUsingBlock:(void (^)(id, NSUInteger, BOOL *))block
{
    if(block){
        pthread_rwlock_rdlock(&s_pthread_rwlock_t);
        NSArray* arrayCopy = [_mutableArry copy];
        pthread_rwlock_unlock(&s_pthread_rwlock_t);
        
        [arrayCopy enumerateObjectsUsingBlock:block];
    }
}

-(id)lastObject
{
    GXRD_LOCKED(
    id objc = _mutableArry.lastObject;
    );
    return objc;
}


-(id)firstObject
{
    GXRD_LOCKED(
    id objc = _mutableArry.firstObject;
    );
    
    return objc;
}

-(NSArray *)array
{
    NSArray* _array;
    GXRD_LOCKED(
                _array = [_mutableArry copy];
                );
    return _array;
}

@end



