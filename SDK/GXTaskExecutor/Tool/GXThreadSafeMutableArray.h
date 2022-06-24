//
//  GXThreadSafeMutableArray.h
//  StudyApp
//
//  Created by GurisXie on 2022/5/18.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <pthread.h>

@interface GXThreadSafeMutableArray<__covariant ObjectType> : NSObject
{
    pthread_rwlock_t s_pthread_rwlock_t;
    NSMutableArray *_mutableArry;
}

@property (nonatomic, readonly) ObjectType firstObject;
@property (nonatomic, readonly) ObjectType lastObject;
@property (nonatomic, readonly) NSMutableArray<ObjectType> *mutableArry;

-(instancetype)initWithArry: (NSArray *)array;
-(BOOL) containsObject: (id)anObject;
-(void)addObject: (ObjectType ) anObject;
-(void)removeObjectsInRange: (NSRange ) range ;
-(void)removeObjectAtIndex: (NSUInteger) index ;
-(void)removeAllObjects;
-(void)removeLastObject;

-(void)removeObject: (ObjectType) anobject;
-(id)removeAndReturnAllObjects;
-(ObjectType)objectAtIndex: (NSUInteger) index ;
-(NSUInteger) count;

-(void)enumerateObjectsUsingBlock: (void (^) (ObjectType value, NSUInteger index, BOOL *stop)) block;
-(NSArray<ObjectType>*) array;

@end
