//
//  GXErrorGenerator.h
//  StudyApp
//
//  Created by GurisXie on 2022/5/17.
//  Copyright © 2022年 GurisXie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXErrorGenerator <NSObject>

-(NSString*) errorMessageWithDescription:(NSString*)errorDescription;

-(NSError*) errorWithDomain:(NSString*)domain code:(NSInteger)code description:(NSString*)errorDescription;

@end
