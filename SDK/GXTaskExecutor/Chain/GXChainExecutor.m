//
//  GXChainExecutor.m
//  StudyApp
//
//  Created by GurisXie on 2022/5/16.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import "GXChainExecutor.h"
#import "GXChainContext.h"
#import "GXHandlerChainIdentifierConvert.h"
#import "GXTaskObserver+Call.h"
#import "GXAutoincreaseIdGenerator.h"
#import "GXGCDTimer.h"
@interface GXChainExecutor () <GXGCDTimerDelegate>
{
    BOOL _isCancel;
}
@property (nonatomic, strong) GXChainContext *rootChainContext;
@property (nonatomic, weak) GXHandlerChainGenerator *chainGenerator;
@property (nonatomic, strong) id<GXErrorGenerator> errorGenerator;
@property (nonatomic, strong) GXAutoincreaseIdGenerator *contextIdGenerator;
@property (nonatomic, strong) GXGCDTimer *timeoutTicker;
@end

@implementation GXChainExecutor
@synthesize rootChainContext = _rootChainContext;
@synthesize timeoutMilliseconds = _timeoutMilliseconds;
@synthesize startTime = _startTime;
@synthesize executorld = _executorld;

- (instancetype)initWithExecutorId: (int64_t)executorId
                            timeout: (int64_t)timeoutMilliseconds
                     chainGenerator:(GXHandlerChainGenerator*)chainGenerator
                     errorGenerator:(id<GXErrorGenerator>)errorGenerator
{
    self = [super init];
    if (self) {
        _executorld = executorId;
        _timeoutMilliseconds = timeoutMilliseconds;
        _chainGenerator = chainGenerator;
        _contextIdGenerator = [[GXAutoincreaseIdGenerator alloc] init];
        
        if (errorGenerator == nil) {
            
        }else
        {
            _errorGenerator = errorGenerator;
        }
    }
    
    return self;
}

- (void)dealloc{
    [self stopTimer];
}


-(void)invokeWithTask: (GXTask*)task taskObserver: (GXTaskObserver*) taskObserver
{
    if (task == nil)
    {
        [self callObserverFinish:taskObserver isSuccess:NO error: [self.errorGenerator errorWithDomain:@"" code:0 description:@""]];
        return;
    }
    NSString *identifierText = [GXHandlerChainIdentifierConvert identifierForTaskType:task.taskType];
    
    if (identifierText.length == 0){
        [self callObserverFinish:taskObserver isSuccess:NO error: [self.errorGenerator errorWithDomain:@"" code:0 description:@""]];
        return;
    }
    
    NSError *error;
    GXHandlerChain *handlerChain = [self.chainGenerator handlerChainWithChainIdentifier: identifierText isFirstTime: (self.rootChainContext == nil) error:&error];
    if (handlerChain){
        GXChainContext *chainContext = [self chainContextWithTask:task taskObserver:taskObserver handlerChain: handlerChain];
        if (self.rootChainContext == nil){
            [self setRootChainContext:chainContext];
        }else{
            [self.rootChainContext addSubContext:chainContext];
        }
        [self startCheckTimer];
        [chainContext executeNextWithTaskObserver:chainContext.headTaskObserver];
    }else{
        
        [self callObserverFinish: taskObserver isSuccess:NO error:error];
        return;
    }
}


- (void)cancel{
    [self.rootChainContext cancel];
    _isCancel = YES;
}


-(BOOL) isFinish{
    if (_isCancel == YES) {
        return YES;
    }
    if (_rootChainContext) {
        return NO;
    }else {
        return YES;
    }
    
}
-(BOOL) isCancel{
    return _isCancel;
}
-(GXTaskObserver *)headTaskObserver{
    return self. rootChainContext.headTaskObserver;
}
-(void)setRootChainContext: (GXChainContext*) chainContext
{
    _rootChainContext = chainContext;
}
-(GXChainContext*) rootChainContext{
    return _rootChainContext;
}

-(void)callObserverFinish: (GXTaskObserver*)taskObserver isSuccess: (BOOL)isSuccess error: (NSError*)error
{
    if (taskObserver.finishBlock){
        taskObserver.finishBlock(isSuccess,
                                 error);
    }
}



-(NSString *) description{
    return [NSString stringWithFormat:@"%lld", self.executorld];
}


-(GXChainContext*)chainContextWithTask:(GXTask*)task taskObserver: (GXTaskObserver*) taskObserver handlerChain: (GXHandlerChain*)handlerChain

{
    __weak typeof(self) weakSelf = self;
    int64_t contextId = [self.contextIdGenerator generateld];
    GXTaskObserver* callbackObserver = [GXTaskObserver taskObserverWithDataFeedBlock: ^ (id dataObject){
        if (taskObserver.dataFeedBlock){
            taskObserver.dataFeedBlock(dataObject);
        }
    } andFinishBlock: ^ (BOOL isSuccess, NSError *error){
        [weakSelf stopTimer];
        [weakSelf callObserverFinish:taskObserver isSuccess : isSuccess error:error];
    }];
    GXChainContext *chainContext = [[GXChainContext alloc] initWithExecutor:self contextId:contextId task: task taskObserver:callbackObserver handlerChain:handlerChain];
    chainContext.excutorId = _executorld;
    return chainContext;
}
-(void)startCheckTimer{
    if(self. timeoutTicker){
        [self.timeoutTicker invalidate];
    }
    
    self. timeoutTicker = [GXGCDTimer scheduledTimerWithTimeInterval:[self taskTimeout] delegate:self userInfo:nil repeats:NO];
}
-(void)stopTimer{
    if(self.timeoutTicker){
        [self.timeoutTicker invalidate];
    }
}
- (void)timer: (GXGCDTimer *) timer{
    [self stopTimer];
    NSError * error = [NSError errorWithDomain:@"chain Executor" code:-1 userInfo:@{
                                                                          NSLocalizedDescriptionKey : @"task chain time out"
                                                                          }];
    [self callObserverFinish:self.headTaskObserver isSuccess:NO error:error];
}

-(NSTimeInterval)taskTimeout{
    
    NSString* timeout = @"120";
    NSTimeInterval taskTimeout = 120 ;
    if( timeout){
        taskTimeout = [timeout longLongValue];
    }
    return taskTimeout;
}

@end
