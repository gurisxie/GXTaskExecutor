//
//  GXChainExecutor+Call.h
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import "GXChainExecutor.h"
#import <GXTaskExecutor/GXTask.h>
#import <GXTaskExecutor/GXTaskObserver.h>

@interface GXChainExecutor(Call)

-(void)invokeWithTask:(GXTask *)task taskObserver:(GXTaskObserver *)taskObserver fromContextId:(int64_t)contextId;

@end
