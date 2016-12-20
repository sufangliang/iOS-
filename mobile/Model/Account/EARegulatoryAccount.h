//
//  EARegulatoryAccount.h
//  mobile
//
//  Created by kevin on 15/10/20.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EARegulatoryAccount : NSObject

@property(nonatomic) int aId;
@property(nonatomic) double accountsBalance;   // 账户余额
@property(nonatomic) double applyFrozenAmount;    // 申购冻结金额
@property(nonatomic) double useBalance;    // 可用余额
@property(nonatomic) double withdrawFrozenAmount;   // 提现冻结金额
@property(nonatomic) double havePayPwd;     // 支付密码
@property(nonatomic) double learnFrozenAmount;   // 体验金冻结金额
@property(nonatomic) double learnBalance;   // 体验金可用余额


- (void)parseJsonString:(NSString *)jsonStr;

- (NSString *)jsonString;

@end
