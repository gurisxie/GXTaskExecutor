//
//  GXHandlerChainGenerator.m
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import "GXHandlerChainGenerator.h"


#import "GXHandlerChainGenerator.h"
#import "GXHandler.h"
#import "GXDefaultHandlerGenerator.h"
@interface GXHandlerChainGenerator()
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSArray<NSString*>*> *handlerClassNameDict;
@property (nonatomic, strong) NSMutableDictionary<NSString*, NSDictionary<NSString*,GXHandlerConfig*>*> *handlerConfigDict;
@property (nonatomic, strong) NSMutableDictionary<NSString*, Class<GXHandler>> *handlerClassDict;
@property (nonatomic, strong) id<GXHandlerGenerator> handlerGenerator;
@property (nonatomic, strong) id<GXErrorGenerator> errorGenerator;
@end

@implementation GXHandlerChainGenerator
- (instancetype)initWithIdentifier:(NSString*)identifier{
    self = [super init];
    _identifier = identifier;
    self.handlerGenerator = [[GXDefaultHandlerGenerator alloc] initWithIdentifier: _identifier];
    self.handlerClassNameDict = [[NSMutableDictionary alloc] init];
    self. handlerConfigDict = [[NSMutableDictionary alloc] init];
    self.handlerClassDict = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)setHandlerClassList: (NSArray<NSString*>*)handlerClassList andHandlerConfig: (NSDictionary<NSString*, GXHandlerConfig*>*)handlerConfigDict
          forChainIdentifier: (NSString*) identifier
{
    if(handlerClassList.count > 0)
    {
        [self.handlerClassNameDict setObject: handlerClassList forKey: identifier];
        for (NSString *handlerClassName in handlerClassList){
            Class handlerClass = NSClassFromString(handlerClassName);
            if (handlerClass == NULL){
                NSString *errorMsg = [NSString stringWithFormat:@"%@", handlerClassName];
                if (errorMsg) {}
                continue;
            }
            
            [self.handlerClassDict setObject: handlerClass forKey: handlerClassName];
            if(handlerConfigDict.count > 0){
                [self.handlerConfigDict setObject:handlerConfigDict forKey: identifier];
            }
        }
    }
}
-(GXHandlerChain*) handlerChainWithChainIdentifier: (NSString*) chainIdentifier isFirstTime: (BOOL)isFirstTime error: (NSError**)error
{
    NSArray<NSString*> *handlerClassNameList = [self.handlerClassNameDict objectForKey:chainIdentifier];
    NSDictionary<NSString*,GXHandlerConfig*>*singleHandlerConfigDict=[self.handlerConfigDict objectForKey:chainIdentifier];
    if (handlerClassNameList.count == 0) {
        NSError *domError = [self.errorGenerator errorWithDomain:@"" code: 0 description:@""];
        if (domError && error) {
            *error = domError;
        }
        return nil;
    }
    NSString *errorMsg = nil;
    BOOL handlerListValid = YES;
    NSMutableArray<id<GXHandler>> *handlerList = [NSMutableArray array];
    NSUInteger handlerIndex = 0;
    
    
    for (NSString *handlerClassName in handlerClassNameList){
        Class handlerClass = [self.handlerClassDict objectForKey:handlerClassName];
        if (handlerClass == NULL) {
            handlerClass=NSClassFromString(handlerClassName);
            if (handlerClass == NULL){
                handlerListValid = NO;
                errorMsg = [NSString stringWithFormat:@"%@", handlerClassName];
                continue;
            }
        }
        BOOL isSupport = [self.handlerGenerator isSupportHandler:handlerClass];
        if (isSupport==NO) {
            handlerListValid = NO;
            errorMsg = [NSString stringWithFormat:@"%@", handlerClassName];
            break;
        }
        NSObject<GXHandler> *taskHandler = [self.handlerGenerator handlerForHandlerClass:handlerClass];
        if (taskHandler){
            GXHandlerConfig *handlerConfig = [singleHandlerConfigDict objectForKey:handlerClassName];
            if (handlerConfig != nil && handlerConfig.rule == GXHandlerRuleValidAtFirstTime && isFirstTime == NO && (handlerConfig.handlerIndex < 0 ||handlerConfig.handlerIndex == handlerIndex)){
                continue;
            }
            [handlerList addObject: taskHandler];
        }
    }
    
    if (handlerListValid==NO){
        NSError *domerror = [self.errorGenerator errorWithDomain:@"" code:0 description: errorMsg];
        if (domerror && error) {
            *error = domerror;
        }
    }
    
    GXHandlerChain *handlerChain = [[GXHandlerChain alloc] initWithChainIdentifier:chainIdentifier handlerList:handlerList];
    
    return handlerChain;
}

@end
