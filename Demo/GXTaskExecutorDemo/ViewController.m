//
//  ViewController.m
//  GXTaskExecutorDemo
//
//  Created by GurisXie on 2022/6/10.
//

#import "ViewController.h"

#import <GXTaskExecutor/GXTaskExecutor.h>
#import "FirstRunHandler.h"
#import "LastRunHandler.h"

@interface ViewController ()

@property (nonatomic, strong) GXTaskExecutorInstance* instance;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.instance = [[GXTaskExecutorInstance alloc] initWithIdentifier:@"loginId"];
    [self.instance setTaskHandlerList:@[@"LastRunHandler", @"FirstRunHandler"] withTaskType:0];
    
    GXTask *task = [GXTask taskWithType:0 data:@{@"initKey":@"initValue"}];
    task.executor = self.instance;
    
    [self.instance executeWithTask:task dataCallback:^(id data) {
        NSLog(@"dataCall:%@", data);
    } finishCallback:^(BOOL isSuccess, NSError *error) {
        NSLog(@"finishCallback:%i-%@", isSuccess, error);
    }];
}


@end
