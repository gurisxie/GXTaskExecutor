//
//  GXHandlerGenerator.h
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GXHandler.h"

@protocol GXHandlerGenerator <NSObject>

@property (nonatomic,strong, readonly) NSString* identifier;

-(instancetype)initWithIdentifier:(NSString*)identifier;
-(BOOL)isSupportHandler:(Class)handlerClass;

-(id<GXHandler>)handlerForHandlerClass:(Class)handlerClass;

@end
