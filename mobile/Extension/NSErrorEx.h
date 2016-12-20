//
//  NSErrorEx.h
//  sesamelife
//
//  Created by ChenLei on 15/5/13.
//  Copyright (c) 2015年 eggplant. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString* const CustomErrorDomain;

typedef NS_ENUM(NSInteger, customErrorCode) {
    CodeCommonError = - 10000,     ///< 通用错误，一般仅仅显示：操作失败，请稍候重试!
    CodeParameterError,            ///< 参数错误
    CodeTimeoutError,              ///< 超时
    CodeUnloginError,              ///< 未登录
    CodeOtherError                 ///< 其它错误
};

@interface NSError (custom)

/**
 *  通用错误
 *
 *  @return 通用错误，显示：操作失败，请稍候重试!
 */
+ (NSError *)epCommonError;

/**
 *  返回一个参数错误
 *
 *  @return 参数错误
 */
+ (NSError *)epParameterError;

/**
 *  返回一个未登录错误
 *
 *  @return 未登录错误
 */
+ (NSError *)epUnloginError;

/**
 *  返回一起其他错误
 *
 *  @param description 错误描述
 *
 *  @return 其他错误
 */
+ (NSError *)epOtherErrorWithDescription:(NSString *)description;

@end
