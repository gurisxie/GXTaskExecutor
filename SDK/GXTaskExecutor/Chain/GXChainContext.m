//
//  GXChainContext.m
//  StudyApp
//
//  Created by GurisXie on 2022/5/16.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import "GXChainContext.h"



#import "GXChainContext.h"
#import "GXThreadSafeMutableArray.h"
#import "GXTaskobserver+Call.h"
#import "GXChainExecutor+Call.h"
#import "GXHandlerChain.h"
#import "GXChainExecutorProtocol.h"
@interface GXChainContext()
{
    GXThreadSafeMutableArray<GXChainContext*>*_innerSubContextList;
    __weak GXChainContext *_superContext;
}

@property (nonatomic, strong, readwrite) GXTask *task ;
@property (nonatomic, weak) id<GXChainExecutorProtocol> chainExecutor;
@property (nonatomic, strong) NSOperationQueue *proccessQueue;
- (void)setSuperContext: (GXChainContext*) context;
@end

@implementation GXChainContext
@dynamic subContexts;
@dynamic superContext;

- (instancetype)initWithExecutor:(id<GXChainExecutorProtocol>)chainExecutor
                       contextId: (int64_t) contextId
                            task: (GXTask*) task
                    taskObserver: (GXTaskObserver*) taskObserver
                    handlerChain:(GXHandlerChain*)handlerChain
{
    self = [super init];
    if (self) {
        chainExecutor = chainExecutor;
        _contextId = contextId;
        _task = task;
        _headTaskObserver = taskObserver;
        _handlerChain = handlerChain;
        _innerSubContextList = [[GXThreadSafeMutableArray alloc] init];
        _proccessQueue = [[NSOperationQueue alloc] init];
        [_proccessQueue setName: [NSString stringWithFormat: @"NSExecutorQueue %lld", contextId]];
        [_proccessQueue setMaxConcurrentOperationCount:1];
    }
    return self;
}

-(void)dealloc
{
    _proccessQueue = nil;
    [_innerSubContextList removeAllObjects];
    _innerSubContextList = nil;
}

-(void)addSubContext: (GXChainContext*) context
{
    if (context == nil) {
        return;
    }
    [context setSuperContext:self];
    [_innerSubContextList addObject:context];
}

- (GXChainContext*) contextWithId: (int64_t)contextId
{
    __block GXChainContext *context = nil;
    NSArray *list = [_innerSubContextList array];
    [list enumerateObjectsUsingBlock: ^ (GXChainContext *value, NSUInteger index, BOOL *stop) {
        context = value;
    }];

    return context;
}


- (NSArray <GXChainContext *> *) subContexts{
    if ([_innerSubContextList count]>0) {
        return [_innerSubContextList array];
    }else{
        return nil;
    }
    
}

- (void)setSuperContext: (GXChainContext*)context{
    _superContext = context;
    _proccessQueue = context.proccessQueue;
}



-(GXChainContext *) superContext{
    return _superContext;
}

-(void)executeNextWithTaskObserver:(GXTaskObserver*)taskObserver{
    __weak id<GXHandler> taskHandler = [self.handlerChain next];
    __weak typeof (self) weakSelf = self;
    if (taskHandler){
        GXTaskObserver *newTaskObserver = [GXTaskObserver taskObserverWithDataFeedBlock:^( id dataObject) {
            if( [taskHandler needHandle: dataObject] ){
                //                    NSString *log = [NSString
                //                    stringWithFormat:@"(taskChain]|executorId:%0_%@|task:%©|tasktype:%©|ondatabegin:%",taskHandler.type,@(weakSelf.excutorId),weakSelf.task.desc,
                //                    @(weakSelf.task. taskType) , NSStringFromClass ([taskHandler class])];
                //                GXLogInfo (log) ;
                [taskHandler dataCall:dataObject taskObserver: taskObserver chainContext:weakSelf];
            }else{
                [weakSelf dataCallbackWithObserver: taskObserver data: dataObject];
            }
        } andFinishBlock: ^ (BOOL isSuccess, NSError *error) {
            if( !taskHandler.pauseFinishCall){
                [taskHandler finishCall: isSuccess error: error taskObserver: taskObserver chainContext:weakSelf];
            }
        }];
        [weakSelf executeNextWithTaskObserver:newTaskObserver];
    }else{
        if (taskObserver){
            taskObserver.dataFeedBlock(weakSelf.task.data);
            taskObserver.finishBlock (YES, nil);
        }
    }
}

-(void)invokeWithTask: (GXTask*)task taskObserver: (GXTaskObserver*) taskobserver
{
    if ([self.chainExecutor isKindOfClass: [GXChainExecutor class]]){
        [(GXChainExecutor*)self.chainExecutor invokeWithTask:task taskObserver: taskobserver fromContextId:self.contextId];
    }else{
        [self finishCallbackWithObserver:taskobserver isSuccess:YES error:nil];
    }
}

-(void)dataCallbackWithObserver: (GXTaskObserver*)taskObserver data: (id)dataObiect
{
    if (taskObserver.dataFeedBlock){
        taskObserver.dataFeedBlock(dataObiect);
    }
}



- (void)finishCallbackWithObserver: (GXTaskObserver*)taskObserver isSuccess: (BOOL)isSuccess error: (NSError*) error
{
    
    if (taskObserver.finishBlock) {
        taskObserver.finishBlock(isSuccess,error);
    }
}


- (void)cancel
{
    NSArray *subContextList = [_innerSubContextList array];
    [subContextList enumerateObjectsUsingBlock: ^ (GXChainContext *value, NSUInteger index, BOOL *stop) {
        [value cancel];
    }];
    [_proccessQueue cancelAllOperations];
    _proccessQueue = nil;
}


-(void)executeOperation:(NSOperation*)operation
{
    if(_proccessQueue == nil){
        return;
    }
    
    [_proccessQueue addOperation:operation];
}

@end

