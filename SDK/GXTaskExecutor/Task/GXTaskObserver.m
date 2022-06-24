//
//  GXTaskObserver.m
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import "GXTaskObserver.h"

#import "GXTaskObserver+Protected.h"

@implementation GXTaskObserver

+(instancetype)taskObserverWithDataFeedBlock:(GXObserverDataFeedBlock)dataFeedBlock andFinishBlock:(GXObserverFinishBlock)finishBlock
{
    if(dataFeedBlock == nil || finishBlock == nil){
        return nil;
    }
    
    GXTaskObserver *observer = [[GXTaskObserver alloc] initWithDataFeedBlock:dataFeedBlock andFinishBlock:finishBlock];
    return observer;
}

-(instancetype)initWithDataFeedBlock:(GXObserverDataFeedBlock)dataFeedBlock andFinishBlock:(GXObserverFinishBlock)finishBlock
{
    self = [super init];
    if(self){
        _innerDataFeedBlock = [dataFeedBlock copy];
        _innerFinishBlock = [finishBlock copy];
    }
    return self;
}






@end
