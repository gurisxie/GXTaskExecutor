//
//  GXHandlerChainIdentifierConvert.h
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GXTaskExecutor/GXTask.h>


@interface GXHandlerChainIdentifierConvert : NSObject

+(NSString*)identifierForTaskType:(GXTaskType)taskType;

@end
