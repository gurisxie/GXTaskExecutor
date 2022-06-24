# GXTaskExecutor
## 简介
用于完成任务编排执行。每个任务节点相互独立，通过输入来决定执行任务。

## 调用方式
### [举例] 创建两个执行任务

- FirstRunHandler
```
@interface FirstRunHandler : GXBaseHandler

@end

@implementation FirstRunHandler

-(BOOL)needHandle:(id)data
{
    return YES;
}

-(void)dataCall:(id)data taskObserver:(GXTaskObserver *)nextTaskObserver chainContext:(GXChainContext *)chainContext
{
    NSLog(@"FirstRunHandler-%@", data);
    if([data isKindOfClass:NSDictionary.class]){
        NSMutableDictionary* mutiData = [data mutableCopy];
        [mutiData setObject:@"FirstRunHandlerValue" forKey:@"FirstRunHandlerKey"];
        data = [mutiData copy];
    }
    [chainContext dataCallbackWithObserver:nextTaskObserver data:data];
}

@end
```

- LastRunHandler
```
@interface LastRunHandler : GXBaseHandler

@end

@implementation LastRunHandler

-(BOOL)needHandle:(id)data
{
    return YES;
}

-(void)dataCall:(id)data taskObserver:(GXTaskObserver *)nextTaskObserver chainContext:(GXChainContext *)chainContext
{
    NSLog(@"LastRunHandler-%@", data);
    if([data isKindOfClass:NSDictionary.class]){
        NSMutableDictionary* mutiData = [data mutableCopy];
        [mutiData setObject:@"LastRunHandlerValue" forKey:@"LastRunHandlerKey"];
        data = [mutiData copy];
    }
    [chainContext dataCallbackWithObserver:nextTaskObserver data:data];
}

@end
```
### 调用方式
```
#import <GXTaskExecutor/GXTaskExecutor.h>

@interface ViewController ()
@property (nonatomic, strong) GXTaskExecutorInstance* instance;
@end

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
```
### 后续优化

- 完善节点任务配置化开放能力
