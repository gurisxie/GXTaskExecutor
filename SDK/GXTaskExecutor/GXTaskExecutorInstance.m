//
//  GXTaskExecutorInstance.m
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import "GXTaskExecutorInstance.h"
#import "GXHandlerChainGenerator.h"
#import "GXAutoincreaseIdGenerator.h"
#import "GXChainExecutor.h"
#import "GXTaskObserver+Call.h"
#import <GXTaskExecutor/GXTask.h>
#import <pthread.h>

static long long ktaskExecutorQueueAutoID=0;

@interface GXTaskExecutorInstance()
@property (nonatomic, strong) GXHandlerChainGenerator *handlerChainGenerator;
@property (nonatomic, strong) NSMutableDictionary<NSNumber*, GXChainExecutor*> *chainExecutorDict;
@property (nonatomic, strong) GXAutoincreaseIdGenerator *chainExecutorIdGenerator;
@property (nonatomic, assign) int64_t excutingTaskId;
@end

@implementation GXTaskExecutorInstance{
    pthread_rwlock_t _dataRWLock;
    dispatch_queue_t _queue;
    dispatch_queue_t _callbackQueue;
}

@synthesize identifier = _identifier;
@synthesize taskExecutorDesc = _taskExecutorDesc;

-(instancetype)initWithIdentifier: (NSString *)identifier
{
    self = [super init];
    if( ktaskExecutorQueueAutoID >=LONG_LONG_MAX ){
        ktaskExecutorQueueAutoID = 0;
    }
    NSString *queueIdentifier = [NSString stringWithFormat:@"chain%@_%@",identifier, @(ktaskExecutorQueueAutoID++)];
    _queue = dispatch_queue_create ([queueIdentifier UTF8String], DISPATCH_QUEUE_SERIAL);
    _identifier = identifier;
    _handlerChainGenerator = [[GXHandlerChainGenerator alloc] initWithIdentifier: _identifier];
    
    
    _chainExecutorDict = [NSMutableDictionary dictionary];
    _chainExecutorIdGenerator = [[GXAutoincreaseIdGenerator alloc] init];
    
    pthread_rwlock_init(&_dataRWLock, NULL) ;
    _callbackQueue = dispatch_queue_create([[NSString stringWithFormat:@"taskCallback%@", queueIdentifier] UTF8String], DISPATCH_QUEUE_SERIAL);
    return self;
}


-(void)dealloc{
    pthread_rwlock_destroy(&_dataRWLock);
}

-(void)setTaskHandlerList:(NSArray<NSString*>*)list withTaskType:(GXTaskType)type{
    if( !list ){
        return;
    }
    [self.handlerChainGenerator setHandlerClassList:list andHandlerConfig:nil forChainIdentifier: @(type).stringValue];
}


-(void)executeWithTask: (GXTask*)task taskObserver: (GXTaskObserver*) taskObserver{
    [self executeWithTask: task dataCallback:nil
           finishCallback:nil];
}

-(void)clearChainExecutorWithChainExecutorId: (int64_t)chainExecutorId{
    pthread_rwlock_wrlock(&_dataRWLock);
    [self.chainExecutorDict removeObjectForKey:@(chainExecutorId)];
    pthread_rwlock_unlock(&_dataRWLock);
}


-(void)executeWithTask: (GXTask*)task dataCallback: (GXObserverDataFeedBlock)dataBlock finishCallback: (GXObserverFinishBlock)finishBlock{
    __weak typeof(self) weakSelf = self;
    dispatch_async (_queue, ^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if( !strongSelf ) {
            return;
        }
        
        long long beginTime = CFAbsoluteTimeGetCurrent() *1000;
        __block long long chainCostTime = 0;
        int64_t executorId = [strongSelf.chainExecutorIdGenerator generateld];
        GXTaskObserver* callbackObserver = [GXTaskObserver taskObserverWithDataFeedBlock: ^(id dataObject) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if(!strongSelf){
                return;
                
            }
            
            
            if (dataBlock && strongSelf)
            {
                dispatch_async(strongSelf->_callbackQueue,
                               ^{
                                   if (dataBlock){
                                       dataBlock(dataObject);
                                   }
                               });
            }
        } andFinishBlock: ^ (BOOL isSuccess, NSError *error){
            __strong typeof (weakSelf) strongSelf = weakSelf;
            if(!strongSelf){
                return;
            }
            pthread_rwlock_rdlock(&(strongSelf->_dataRWLock));
            id executor = [strongSelf.chainExecutorDict objectForKey:@(executorId)];
            pthread_rwlock_unlock(&(strongSelf->_dataRWLock));
            if(!executor){
                return;
            }
            [strongSelf clearChainExecutorWithChainExecutorId: executorId];
            if (finishBlock && strongSelf){
                dispatch_async(strongSelf->_callbackQueue,^{
                    if(finishBlock){
                        finishBlock(isSuccess,error);
                    }
                });
            }
        }];
        
        
        GXChainExecutor *chainExecutor = [[GXChainExecutor alloc] initWithExecutorId:executorId timeout:6000 chainGenerator:strongSelf.handlerChainGenerator errorGenerator:nil];
        pthread_rwlock_wrlock(&(strongSelf->_dataRWLock));
        [strongSelf.chainExecutorDict setObject:chainExecutor forKey:@(executorId)];
        pthread_rwlock_unlock(&(strongSelf->_dataRWLock));
        //执行task
        __weak typeof(chainExecutor) weakChainExecutor = chainExecutor;
        @autoreleasepool{
            dispatch_block_t executBlock =
            dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
                [weakChainExecutor invokeWithTask: task taskObserver:callbackObserver];
            });
            dispatch_queue_t executorQueue = dispatch_queue_create ([[NSString stringWithFormat:@"taskexecutorId:%@", @(executorId)] UTF8String],
                                                                    DISPATCH_QUEUE_SERIAL);
            dispatch_async (executorQueue, executBlock);
            NSTimeInterval chainTimeout = [strongSelf taskChainTimeout];
            
            long result = dispatch_block_wait(executBlock, dispatch_time (DISPATCH_TIME_NOW, (int64_t) (chainTimeout * NSEC_PER_SEC))) ;
            long long endTime = CFAbsoluteTimeGetCurrent()*1000;
            chainCostTime = endTime - beginTime;
            if ( result == 0) {
                
            } else {
                
                
                GXObserverFinishBlock finishBlock = [chainExecutor headTaskObserver].finishBlock;
                [strongSelf clearChainExecutorWithChainExecutorId:executorId];
                if(finishBlock){
                    NSError *error = [NSError errorWithDomain: @"chain.Executor" code:-1 userInfo: @{NSLocalizedDescriptionKey: @"taskexecute time out" }];
                    dispatch_async(strongSelf->_callbackQueue, ^{
                        if (finishBlock){
                            finishBlock(NO, error);
                        }
                        
                    });
                }
            }
        }
    });
}


- (NSTimeInterval)taskChainTimeout{
    return 60;
}

- (BOOL) needMonitor{
    return NO;
}



@end
