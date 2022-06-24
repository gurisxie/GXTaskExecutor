//
//  GXHandlerChain.h
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GXHandler.h"

@interface GXHandlerChain : NSObject

-(instancetype)initWithChainIdentifier:(NSString*)identifier handlerList:(NSArray<id<GXHandler>>*)handlerList;

-(BOOL)hasNext;

-(id<GXHandler>)next;


@end
