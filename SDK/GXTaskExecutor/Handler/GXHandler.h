//
//  GXHandler.h
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GXTaskExecutor/GXTask.h>
#import <GXTaskExecutor/GXTaskObserver.h>
#import "GXChainContext.h"

@protocol GXHandler <NSObject>

@property (nonatomic, strong, readonly) NSString* identifier;
@property (nonatomic, assign) BOOL pauseFinishCall; // 是否需要手动调用finishCall，默认自动调用

-(instancetype)initWithIdentifier:(NSString*)identifier;
// 判断是否要消费被订阅者传递的数据
-(BOOL)needHandle:(id)data;
// 被订阅者传递数据的处理
-(void)dataCall:(id)data taskObserver:(GXTaskObserver*)nextTaskObserver chainContext:(GXChainContext*)chainContext;
// 被订阅者完成时调用
-(void)finishCall:(BOOL)isSuccess error:(NSError*)error taskObserver:(GXTaskObserver*)nextTaskObserver chainContext:(GXChainContext*)chainContext;

@end
