//
//  GXChainContext.h
//  StudyApp
//
//  Created by GurisXie on 2022/5/16.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import <Foundation/Foundation.h>



#import <Foundation/Foundation.h>
#import <GXTaskExecutor/GXTask.h>
#import <GXTaskExecutor/GXTaskObserver.h>

@protocol GXChainExecutorProtocol;
@class GXHandlerChain;
@interface GXChainContext : NSObject
@property (nonatomic, readonly) GXTaskObserver *headTaskObserver;
@property (nonatomic, readonly) GXChainContext *superContext;
@property (nonatomic, readonly) NSArray<GXChainContext*> *subContexts;
@property (nonatomic, readonly) GXHandlerChain *handlerChain;
@property (nonatomic, readonly) GXTask *task;
@property (nonatomic, readonly) int64_t contextId;
@property (nonatomic, assign) int64_t excutorId;
-(instancetype)initWithExecutor:(id<GXChainExecutorProtocol>)chainExecutor
                      contextId: (int64_t)contextId
                           task: (GXTask*) task
                   taskObserver:(GXTaskObserver*)taskObserver
                   handlerChain:(GXHandlerChain*)handlerChain;
-(void)addSubContext: (GXChainContext*) context;
- (GXChainContext*) contextWithId: (int64_t) contextId;
-(void)executeNextWithTaskObserver:(GXTaskObserver*)taskObserver;
- (void)cancel;
-(void)invokeWithTask: (GXTask*)task taskObserver: (GXTaskObserver*)taskObserver;

-(void)dataCallbackWithObserver: (GXTaskObserver*)taskObserver data: (id)data;
- (void)finishCallbackWithObserver: (GXTaskObserver*) taskObserver isSuccess: (BOOL) isSuccess error: (NSError*)error;
@end
