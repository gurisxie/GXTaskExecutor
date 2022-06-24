//
//  LastRunHandler.m
//  GXTaskExecutorDemo
//
//  Created by GurisXie on 2022/6/10.
//

#import "LastRunHandler.h"

@implementation LastRunHandler

-(BOOL)needHandle:(id)data
{
    return YES;
}

-(void)dataCall:(id)data taskObserver:(GXTaskObserver *)nextTaskObserver chainContext:(GXChainContext *)chainContext
{
    NSLog(@"LastRunHandler-%@", data);
    if([data isKindOfClass:NSDictionary.class]){
        NSMutableDictionary* mutiData = [data mutableCopy];
        [mutiData setObject:@"LastRunHandlerValue" forKey:@"LastRunHandlerKey"];
        data = [mutiData copy];
    }
    [chainContext dataCallbackWithObserver:nextTaskObserver data:data];
}

@end
