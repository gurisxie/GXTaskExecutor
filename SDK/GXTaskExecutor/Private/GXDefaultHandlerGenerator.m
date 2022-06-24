//
//  GXDefaultHandlerGenerator.m
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import "GXDefaultHandlerGenerator.h"

@implementation GXDefaultHandlerGenerator

@synthesize identifier = _identifier;
-(instancetype)initWithIdentifier:(NSString *)identifier
{
    self = [super init];
    _identifier = identifier;
    return self;
}

-(BOOL)isSupportHandler:(Class)handlerClass
{
    if(handlerClass == nil){
        return NO;
    }
    
    return [handlerClass conformsToProtocol:@protocol(GXHandler)];
}

-(id<GXHandler>)handlerForHandlerClass:(Class)handlerClass
{
    if(handlerClass == nil)
    {
        return nil;
    }
    
    if(![handlerClass conformsToProtocol:@protocol(GXHandler)]){
        return nil;
    }
    
    NSObject<GXHandler> * taskHandler = (NSObject<GXHandler>*)[[handlerClass alloc] initWithIdentifier:_identifier];
    
    return taskHandler;
}


@end
