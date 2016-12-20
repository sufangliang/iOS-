//
//  NSErrorEx.m
//  sesamelife
//
//  Created by ChenLei on 15/5/13.
//  Copyright (c) 2015年 eggplant. All rights reserved.
//

#import "NSErrorEx.h"

NSString* const CustomErrorDomain = @"com.eggplant.error";

@implementation NSError (custom)

+ (NSError *)epCommonError
{
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : NSLocalizedString(@"Operation failed,PLease retry later", nil) };
    NSError *error = [[NSError alloc] initWithDomain:CustomErrorDomain
                                                code:CodeCommonError
                                            userInfo:userInfo];
    return error;
}

+ (NSError *)epParameterError
{
    // TODO: 翻译
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"参数错误" };
    NSError *error = [[NSError alloc] initWithDomain:CustomErrorDomain
                                                code:CodeParameterError
                                            userInfo:userInfo];
    return error;
}

+ (NSError *)epUnloginError
{
    // TODO: 翻译
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"你没有登录" };
    NSError *error = [[NSError alloc] initWithDomain:CustomErrorDomain
                                                code:CodeUnloginError
                                            userInfo:userInfo];
    return error;
}

+ (NSError *)epOtherErrorWithDescription:(NSString *)description
{
    NSDictionary *userInfo = nil;
    if ([description length] > 0) {
        userInfo = @{ NSLocalizedDescriptionKey : description };
    } else {
        userInfo = @{ NSLocalizedDescriptionKey : NSLocalizedString(@"Operation failed,PLease retry later", nil) };
    }
    
    NSError *error = [[NSError alloc] initWithDomain:CustomErrorDomain
                                                code:CodeOtherError
                                            userInfo:userInfo];
    return error;
}

@end
