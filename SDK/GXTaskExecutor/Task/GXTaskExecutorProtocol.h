//
//  GXTaskExecutorProtocol.h
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GXTaskExecutor/GXTaskObserver.h>

@class GXTask;
@class GXBaseHandler;
@class GXTaskObserver;

@protocol GXTaskExecutorProtocol <NSObject>

@property (nonatomic, strong, readonly) NSString* identifier;
@property (nonatomic, copy) NSString* taskExecutorDesc;

-(instancetype)initWithIdentifier:(NSString*)identifier;
-(void)setTaskHandlerList:(NSArray<NSString*>*)list withTaskType:(GXTaskType)type;
-(void)executeWithTask:(GXTask*)task taskObserver:(GXTaskObserver*)taskObserver;
-(void)executeWithTask:(GXTask*)task dataCallback:(GXObserverDataFeedBlock)dataBlock finishCallback:(GXObserverFinishBlock)finishBlock;

@end

