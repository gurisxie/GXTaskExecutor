//
//  FirstRunHandler.m
//  GXTaskExecutorDemo
//
//  Created by GurisXie on 2022/6/10.
//

#import "FirstRunHandler.h"

@implementation FirstRunHandler

-(BOOL)needHandle:(id)data
{
    return YES;
}

-(void)dataCall:(id)data taskObserver:(GXTaskObserver *)nextTaskObserver chainContext:(GXChainContext *)chainContext
{
    NSLog(@"FirstRunHandler-%@", data);
    if([data isKindOfClass:NSDictionary.class]){
        NSMutableDictionary* mutiData = [data mutableCopy];
        [mutiData setObject:@"FirstRunHandlerValue" forKey:@"FirstRunHandlerKey"];
        data = [mutiData copy];
    }
    [chainContext dataCallbackWithObserver:nextTaskObserver data:data];
}

@end
