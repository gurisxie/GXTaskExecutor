//
//  GXTask.h
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSUInteger GXTaskType;
@class GXTaskExecutorInstance;

@interface GXTask : NSObject

@property (nonatomic, readonly, assign) GXTaskType taskType;
@property (nonatomic, readonly, strong) id data;
@property (nonatomic, strong) NSString* desc;
@property (nonatomic, weak) GXTaskExecutorInstance *executor;

+(instancetype)taskWithType:(GXTaskType)type data:(id)data;
-(instancetype)initWithType:(GXTaskType)type data:(id)data;

@end
