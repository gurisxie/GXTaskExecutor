//
//  GXChainExecutor+Private.h
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import "GXChainExecutor.h"
#import "GXChainContext.h"
#import "GXTaskObserver+Call.h"
#import "GXAutoincreaseIdGenerator.h"

@interface GXChainExecutor()
{
    BOOL _isCancel;
}

@property (nonatomic, strong) GXChainContext *rootChainContext;
@property (nonatomic, weak) GXHandlerChainGenerator *chainGenerator;
@property (nonatomic, strong) id<GXErrorGenerator> errorGenerator;
@property (nonatomic, strong) GXAutoincreaseIdGenerator* contextIdGenerator;

-(GXChainContext*)chainContextWithTask:(GXTask*)task taskObserver:(GXTaskObserver*)taskObserver handlerChain:(GXHandlerChain*)handlerChain;

-(void)callObserverFinish:(GXTaskObserver*)taskObserver isSuccess:(BOOL)isSuccess error:(NSError*)error;


@end
