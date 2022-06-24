//
//  GXChainQueueUtil.m
//  StudyApp
//
//  Created by GurisXie on 2022/5/16.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import "GXChainQueueUtil.h"

@interface GXChainQueueUtil()
@property(nonatomic, strong) dispatch_queue_t dispatchQueue;
@end

@implementation GXChainQueueUtil
+ (instancetype)sharedInstance{
    static GXChainQueueUtil *queueUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queueUtil = [GXChainQueueUtil new];
    });
    return queueUtil;
}

- (instancetype)init{
    self = [super init];
    _dispatchQueue = dispatch_queue_create("gurisxie.dispatchQueue", DISPATCH_QUEUE_SERIAL);
    return self;
}

+(dispatch_queue_t)chainDispatchQueue{
    return [GXChainQueueUtil sharedInstance].dispatchQueue;
}

@end
