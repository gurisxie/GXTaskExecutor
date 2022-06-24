//
//  GXTaskObserver+Call.m
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import "GXTaskObserver+Call.h"
#import "GXTaskObserver+Protected.h"

@implementation GXTaskObserver(Call)

-(GXObserverDataFeedBlock)dataFeedBlock
{
    return self.innerDataFeedBlock;
}

-(GXObserverFinishBlock)finishBlock
{
    return self.innerFinishBlock;
}

@end
