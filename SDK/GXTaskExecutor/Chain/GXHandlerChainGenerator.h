//
//  GXHandlerChainGenerator.h
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GXTaskExecutor/GXHandlerConfig.h>
#import <GXTaskExecutor/GXHandlerGenerator.h>
#import <GXTaskExecutor/GXHandlerChain.h>
#import <GXTaskExecutor/GXErrorGenerator.h>
@interface GXHandlerChainGenerator:NSObject
@property (nonatomic, strong, readonly) NSString *identifier;
-(instancetype)initWithIdentifier: (NSString *)identifier;
-(void)setHandlerClassList:(NSArray<NSString*>*)handlerClassList
          andHandlerConfig:(NSDictionary<NSString*,GXHandlerConfig*>*)handlerConfigDict
        forChainIdentifier:(NSString*)identifier;
-(GXHandlerChain*)handlerChainWithChainIdentifier:(NSString*)chainIdentifier isFirstTime:(BOOL)isFirstTime error:(NSError**)error;
@end
