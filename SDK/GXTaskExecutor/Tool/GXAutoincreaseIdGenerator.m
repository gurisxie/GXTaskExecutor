//
//  GXAutoincreaseIdGenerator.m
//  StudyApp
//
//  Created by GurisXie on 2022/5/16.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import "GXAutoincreaseIdGenerator.h"
#import <pthread.h>

@interface GXAutoincreaseIdGenerator(){
    int64_t _autoIncreaseld;
}
@end

@implementation GXAutoincreaseIdGenerator
-(instancetype)init
{
    self = [super init];
    if (self) {
        _autoIncreaseld = 0;
    }
    return self;
}

-(int64_t )generateld
{
    if(_autoIncreaseld == LONG_LONG_MAX)
    {
        _autoIncreaseld = 0;
    }
    int64_t lockautoIncreaseld = _autoIncreaseld++;
    return lockautoIncreaseld;
}


@end
