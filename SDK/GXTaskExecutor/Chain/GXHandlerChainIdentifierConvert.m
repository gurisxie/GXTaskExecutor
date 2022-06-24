//
//  GXHandlerChainIdentifierConvert.m
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import "GXHandlerChainIdentifierConvert.h"

@implementation GXHandlerChainIdentifierConvert

+(NSString*)identifierForTaskType:(GXTaskType)taskType
{
    return [NSString stringWithFormat:@"%lu", (unsigned long)taskType];
}


@end
