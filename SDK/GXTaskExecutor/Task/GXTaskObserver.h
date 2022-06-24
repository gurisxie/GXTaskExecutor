//
//  GXTaskObserver.h
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GXTaskExecutor/GXTask.h>

typedef void (^GXObserverDataFeedBlock)(id data);
typedef void (^GXObserverFinishBlock)(BOOL isSuccess, NSError *error);

@interface GXTaskObserver : NSObject

+(instancetype)taskObserverWithDataFeedBlock:(GXObserverDataFeedBlock)dataFeedBlock andFinishBlock:(GXObserverFinishBlock)finishBlock;

@end
