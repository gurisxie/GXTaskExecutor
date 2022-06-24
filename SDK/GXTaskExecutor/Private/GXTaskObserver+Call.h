//
//  GXTaskObserver+Call.h
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import "GXTaskObserver.h"

@interface GXTaskObserver(Call)

-(GXObserverDataFeedBlock)dataFeedBlock;
-(GXObserverFinishBlock)finishBlock;

@end
