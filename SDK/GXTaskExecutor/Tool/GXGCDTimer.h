//
//  GXGCDTimer.h
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GXGCDTimer;

@protocol GXGCDTimerDelegate <NSObject>

-(void)timer:(GXGCDTimer*)timer;

@end

@interface GXGCDTimer : NSObject

@property (nonatomic, strong) id userInfo;

-(void)invalidate;

+(GXGCDTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)ti delegate:(id<GXGCDTimerDelegate>)delegate userInfo:(id)ui repeats:(BOOL)yesOrNo;

@end
