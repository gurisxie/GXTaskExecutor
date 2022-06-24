//
//  GXHandlerChain.m
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import "GXHandlerChain.h"

@interface GXHandlerChain()

@property (nonatomic, strong) NSArray<id<GXHandler>> *handlerList;
@property (nonatomic, assign) NSUInteger nextIndex;

@end

@implementation GXHandlerChain

-(instancetype)initWithChainIdentifier:(NSString *)identifier handlerList:(NSArray<id<GXHandler>> *)handlerList
{
    self = [super init];
    
    if(self){
        _handlerList = handlerList;
        _nextIndex = 0;
    }
    return self;
}

-(BOOL)hasNext
{
    if(self.nextIndex >= self.handlerList.count){
    
        return NO;
    }
    
    return YES;

}

-(id<GXHandler>)next
{
    if(self.nextIndex >= self.handlerList.count){
        return nil;
    }
    
    id<GXHandler> handler = [self.handlerList objectAtIndex:self.nextIndex];
    self.nextIndex++;
    return handler;
}


@end
