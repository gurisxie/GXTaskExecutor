//
//  GXBaseHandler.m
//  StudyApp
//
//  Created by GurisXie on 2022/5/16.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import "GXBaseHandler.h"

#import "GXChainContext.h"

@implementation GXBaseHandler
@synthesize identifier = _identifier;
@synthesize pauseFinishCall = _pauseFinishcall;

- (instancetype)initWithIdentifier: (NSString *)identifier
{
    self = [super init];
    _identifier = identifier;
    return self;
}

- (BOOL )needHandle: (id)data{
    return YES;
}


-(void)dataCall: (id)data taskObserver: (GXTaskObserver*) nextTaskObserver chainContext: (GXChainContext*)chainContext{
    [chainContext dataCallbackWithObserver: nextTaskObserver data: data];
}

-(void)finishCall: (BOOL )isSuccess error: (NSError*)error taskObserver: (GXTaskObserver*)nextTaskObserver chainContext: (GXChainContext*)chainContext{
    [chainContext finishCallbackWithObserver:nextTaskObserver isSuccess:isSuccess error: error];
}

@end
