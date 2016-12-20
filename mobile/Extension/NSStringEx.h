//
//  NSStringEx.h
//  sesamelife
//
//  Created by ChenLei on 15/5/13.
//  Copyright (c) 2015年 eggplant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (eggplant)

/// md5运算
- (NSString *)md5;

/// base64编码
- (NSString *)base64String;

/// base64解码
- (NSString *)base64DecodeString;

/// url Encode
- (NSString *)URLEncodedString;

/// 生成带星号的手机号
+ (NSString *)formatStarMobile:(NSString *)raw;

/// 是否都是整形
- (BOOL)isPureInt;

/**
 *  计算text渲染后的size
 *
 *  @param font 文字的font
 *  @param size constrained size
 *
 *  @return 渲染后的size
 */
- (CGSize)epSizeForFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (BOOL)containsStringEx:(NSString *)str;

- (BOOL)isPureNumandCharacters;

@end
