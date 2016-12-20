//
//  EACheckUtil.h
//  mobile
//
//  Created by ChenLei on 15/9/23.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EACheckUtil : NSObject

/**
 * 校验手机
 *
 * @param str
 * @return 验证结果
 */
+ (BOOL)isMobile:(NSString *)str;

/**
 * 校验密码
 *
 * @param str
 * @return
 */
+ (BOOL)isRightPwd:(NSString *)str;

/**
 * 校验金额
 *
 * @param str
 * @return
 */
+ (BOOL)isRightMoney:(NSString *)str;

/**
 * 校验中文名字
 *
 * @param str
 * @return
 */
+ (BOOL)isRealName:(NSString *)str;

/**
 *  检查银行卡
 *
 *  @param bankNo
 *
 *  @return
 */
+ (NSString *)checkBankNum:(NSString *)bankNo;

/**
 *  检查身份证是否合法
 *
 *  @param value id number
 *
 *  @return 是否合法
 */
+ (BOOL)validateIDCardNumber:(NSString *)value;

@end
