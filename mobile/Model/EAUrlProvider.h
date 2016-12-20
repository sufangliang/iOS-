//
//  EAUrlProvider.h
//  mobile
//
//  Created by ChenLei on 15/9/15.
//  Copyright (c) 2015年 edaga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EAUrlProvider : NSObject

+ (long long)getTimestamp;

/// 益钱包详情
+ (NSString *)walletUrl;

/// 益定宝一个月
+ (NSString *)ydbOneUrl;

/// 益定宝三个月
+ (NSString *)ydbThreeUrl;

/// 益钱包统计
+ (NSString *)walletStatisticsUrl;

/// 我的益钱包投资记录
+ (NSString*)createMyWalletApplyListUrl;

/// 我的益钱包详情
+ (NSString*)createMyWalletDetail;

/// 益钱包投资记录
+ (NSString*)createWalletApplyListUrl;

/// 益钱包投资排行榜
+ (NSString*)createWalletApplyBoardUrl;

/// 我的资金流水
+ (NSString *)myTradeLogUrl:(NSString *)tradeType page:(int)page pageCount:(int)pageCount;

/// 获取我的账户
+ (NSString *)myAccountUrl;

/// 获取我的银行账户
+ (NSString *)myBankAccountUrl;

/// 获取用户信息
+ (NSString *)userUrl;

/// 修改登录密码
+ (NSString *)changeLoginPasswordUrl:(NSString *)mobile newPwd:(NSString *)newPassword random:(NSString *)random;

/// 修改交易密码
+ (NSString *)changePayPasswordUrl:(NSString *)idCard newPwd:(NSString *)newPassword random:(NSString *)random;

/// 获取我的抽奖加息劵
+ (NSString *)myCjJxjResultUrl;

/// 判断login
+ (NSString *)loginUrl;

/// 登录
+ (NSString *)loginUrl:(NSString *)mobile password:(NSString *)pwd;

/// 注册
+ (NSString *)registerUrl:(NSString *)mobile
                 password:(NSString *)pwd
               mobileCode:(NSString *)mobileCode;

/// 发送短信验证码
+ (NSString *)randomSmsUrl:(NSString *)mobile reason:(NSString *)reason;

/// 益钱包申购url
+ (NSString *)applyUrl:(NSString *)payPwd amount:(NSString*)amount cjResultId:(NSString *)cjResultId;

/// 益定宝申购url
+ (NSString *)ydbApplyUrl:(NSString *)payPwd amount:(NSString *)amount aid:(long)aid;

/// 提现url
+ (NSString *)withdrawUrl:(NSString *)payPwd amount:(NSString *)amount;

/// 充值url
+ (NSString *)createRechargeUrl:(NSString*)moneyOrder
                     haveIdCard:(NSString*)haveIdCard
                   haveBankCard:(NSString*)haveBankCard
                           name:(NSString*)name
                         idCard:(NSString*)idCard
                       bankCard:(NSString*)bankCard;

/// 实名认证+银行卡绑定url
+ (NSString *)verifyUrl:(NSString *)name idCard:(NSString *)idCard bankCard:(NSString *)bankCard;

/// 查询银行列表url
+ (NSString *)bankListUrl;

/// 我的最大可赎回金额
+ (NSString *)myWalletMaxRedeem;

/// 我的赎回金额
+ (NSString *)walletRedeem:(NSString *)payPwd amount:(NSString *)amount;

/// 获取IM token
+ (NSString *)imTokenUrl:(NSString *)mobile;

/// get news
+ (NSString *)newsUrl;

/// 获取我的资金统计
+ (NSString*)createMyMoneyStatisticsUrl;

/// 获取我的 益定宝 列表
+ (NSString*)createMyYdbListUrl:(NSString*)applyStatus;

/// 获取Host
+ (NSString*)createHost;

/// 获取InviteCode
+ (NSString*)createInviteCodeUrl;

/// 获取用户认证信息
+ (NSString*)createGetUserVerify;

/// 查询银行卡bin查询 & 查询限额
+ (NSString*)createQueryBankCardBinLimitUrl:(NSString*) bankCard;

/// 查询银行限额
+(NSString*)createQueryBankLimitUrl:(NSString*) bankFullName;

+(NSString*)createRongIMToken:(NSString*) mobile;

/// 检查版本号
+(NSString*)createCheckVersion;

/// 益钱包详情
+(NSString*)createWalletDetailUrl;

/// 校验支付密码 如果未设置交易密码则直接设置
+(NSString*)createCheckPayPwdUrl:(NSString*) payPwd;

// 获取定期链接
+(NSString*)createDqUrl:(NSString*)flag;

//收益计算器
+(NSString*)createIncomeCounterListUrl:(NSString*)counterWay tzAmount:(NSString*)tzAmount yearRate:(NSString*)yearRate tzNo:(NSString*)tzNo;

//预计收益
+(NSString*)createExpectedIncomeUrl:(NSString*)tzAmount yearRate:(NSString*)yearRate days:(NSString*)days;

//我的合同
+(NSString*)createMyProtocolUrl:(NSString*)applyId;

//我的定期列表
+(NSString*)createMyDqApplyListUrl:(NSString*)finish page:(int)page pageSize:(int)pageSize;

//定期申购url
+(NSString*)createDqApplyUrl:(NSString*)payPwd amount:(NSString*)amount flag:(NSString*)flag;

//定期投资记录
+(NSString*)createDqApplyRecordUrl;

//判断用户是否为新手
+(NSString*)createMemberIsNewbieUrl;

@end
