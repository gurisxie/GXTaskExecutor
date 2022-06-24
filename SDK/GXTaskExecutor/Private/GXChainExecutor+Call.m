//
//  GXChainExecutor+Call.m
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import "GXChainExecutor+Call.h"
#import "GXChainExecutor+Private.h"
#import "GXHandlerChainIdentifierConvert.h"

@implementation GXChainExecutor(Call)

-(void)invokeWithTask:(GXTask *)task taskObserver:(GXTaskObserver *)taskObserver fromContextId:(int64_t)contextId
{
    if(task == nil){
        [self callObserverFinish:taskObserver isSuccess:NO error:[self.errorGenerator errorWithDomain:@"" code:0 description:@""] ];
        
        return;
    }
    
    NSString* identifierText = [GXHandlerChainIdentifierConvert identifierForTaskType:task.taskType];
    if(identifierText.length == 0){
        [self callObserverFinish:taskObserver isSuccess:NO error:[self.errorGenerator errorWithDomain:@"" code:0 description:@""] ];
        return;
    }
    
    NSError* error;
    GXHandlerChain *handlerChain = [self.chainGenerator handlerChainWithChainIdentifier:identifierText isFirstTime:(self.rootChainContext == nil) error:&error];
    if(handlerChain){
        GXChainContext *chainContext = [self chainContextWithTask:task taskObserver:taskObserver handlerChain:handlerChain];
        
        if(self.rootChainContext == nil){
            self.rootChainContext = chainContext;
        }else{
            GXChainContext * resultChainContext = [self.rootChainContext contextWithId:contextId];
            if(resultChainContext){
                [resultChainContext addSubContext:chainContext];
            }else{
                [self.rootChainContext addSubContext:chainContext];
            }
        }
        
        [chainContext executeNextWithTaskObserver:chainContext.headTaskObserver];
    }else{
        [self callObserverFinish:taskObserver isSuccess:NO error:error];
        
    }
}


@end
