//
//  GXTask.m
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import "GXTask.h"

@implementation GXTask

+(instancetype)taskWithType:(GXTaskType)taskType data:(id)data
{
    GXTask *task = [[GXTask alloc] initWithType:taskType data:data];
    
    return task;
}

-(instancetype)initWithType:(GXTaskType)taskType data:(id)data
{
    self = [super init];
    if(self){
        _taskType = taskType;
        _data = data;
    }
    return self;
}


@end
