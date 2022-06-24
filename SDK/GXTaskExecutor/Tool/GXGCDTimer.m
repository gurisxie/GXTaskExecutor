//
//  GXGCDTimer.m
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import "GXGCDTimer.h"

@interface GXGCDTimer()

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, nullable, weak) id<GXGCDTimerDelegate> delegate;

@property (nonatomic, assign) BOOL yesOrNo;

@end


@implementation GXGCDTimer

-(instancetype)initWithTimeInterval:(NSTimeInterval)ti delegate:(id<GXGCDTimerDelegate>)delegate userInfo:(nullable id)ui repeats:(BOOL)yesOrNo
{
    self = [super init];
    
    self.delegate = delegate;
    self.yesOrNo = yesOrNo;
    self.userInfo = ui;
    
    if(!self.delegate){
        return nil;
    }
    
    return self;
}

-(void)invalidate
{
    @synchronized (self) {
        if(self.timer){
            dispatch_source_cancel(_timer);
            _timer = nil;
        }
    }
}


+(GXGCDTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti delegate:(id<GXGCDTimerDelegate>)delegate userInfo:(id)ui repeats:(BOOL)yesOrNo
{
    @autoreleasepool {
        GXGCDTimer *t = [[self alloc] initWithTimeInterval:ti delegate:delegate userInfo:ui repeats:yesOrNo];
        if(t == nil){
            return nil;
        }
        
        __weak typeof(t) weakSelf = t;
        __weak typeof(delegate) weakDelegate = delegate;
        
        // 配置时间间隔，最小间隔0.1秒
        ti = ti > 0.1? ti : 0.1;
        uint64_t interval = ti * NSEC_PER_SEC;
        
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        if(weakSelf.yesOrNo == NO){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval)), queue, ^{
                [weakDelegate timer:weakSelf];
            });
        }else{
            dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            // 配置开始时间
            dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, interval);
            // 校准100毫秒
            dispatch_source_set_timer(timer, start, interval, 0.1 * NSEC_PER_SEC);
            
            dispatch_source_set_event_handler(timer, ^{
                if(!yesOrNo){
                    [weakSelf invalidate];
                }
                [weakDelegate timer:weakSelf];
            });
            
            dispatch_resume(timer);
            
            @synchronized (weakSelf) {
                weakSelf.timer = timer;
            }
        }
        
        return t;
    }

}




@end
