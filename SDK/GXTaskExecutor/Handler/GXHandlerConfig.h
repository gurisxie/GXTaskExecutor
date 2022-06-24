//
//  GXHandlerConfig.h
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_OPTIONS(NSUInteger, GXHandlerRule) {
    GXHandlerRuleNormal = 0,
    GXHandlerRuleValidAtFirstTime,
};

@interface GXHandlerConfig : NSObject

@property (nonatomic, copy) NSString* handlerName;
@property (nonatomic, assign) NSInteger handlerIndex; // 默认从-1 标示适用于所有handler
@property (nonatomic, assign) GXHandlerRule rule;

@end
