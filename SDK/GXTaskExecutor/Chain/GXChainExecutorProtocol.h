//
//  GXChainExecutorProtocol.h
//  StudyApp
//
//  Created by GurisXie on 2022/5/16.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GXTaskExecutor/GXTask.h>
#import <GXTaskExecutor/GXTaskObserver.h>
#import "GXHandlerChainGenerator.h"
#import "GXErrorGenerator.h"
@protocol GXChainExecutorProtocol<NSObject>
@property (nonatomic, readonly) int64_t executorld;
@property (nonatomic, readonly) int64_t timeoutMilliseconds;
@property (nonatomic, readonly) int64_t startTime;
-(instancetype)initWithExecutorId:(int64_t)executorid
                          timeout: (int64_t) timeoutMilliseconds
                   chainGenerator:(GXHandlerChainGenerator*)chainGenerator
                   errorGenerator:(id<GXErrorGenerator>)errorGenerator;
-(void)invokeWithTask: (GXTask*)task taskObserver: (GXTaskObserver*) taskObserver;
-(void)cancel;
-(BOOL) isFinish;
-(BOOL) isCancel;
-(GXTaskObserver*)headTaskObserver;

@end
