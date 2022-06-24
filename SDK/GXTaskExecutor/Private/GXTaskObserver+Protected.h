//
//  GXTaskObserver+Protected.h
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import <GXTaskExecutor/GXTaskObserver.h>

@interface GXTaskObserver()

@property (nonatomic, copy) GXObserverDataFeedBlock innerDataFeedBlock;
@property (nonatomic, copy) GXObserverFinishBlock innerFinishBlock;

@end
