//
//  EAUrlProvider.m
//  mobile
//
//  Created by ChenLei on 15/9/15.
//  Copyright (c) 2015年 edaga. All rights reserved.
//

#import "EAUrlProvider.h"
#import "EAConfiguration.h"
#import "NSStringEx.h"

//#define HOST @"http://www.178bank.net:84" // 测试环境
//#define HOST   @"http://www.178bank.net:82" // 线上环境
#define HOST   @"http://192.168.1.251:81" // 本机环境

@implementation EAUrlProvider

#pragma mark - Common Mothed

+ (int64_t)getTimestamp
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    int64_t date = (int64_t)time;
    return date;
}

+ (NSString *)privateUrl:(NSString *)cmd
{
    NSString *url = [NSString stringWithFormat:@"%@/%@?%@", HOST, cmd, [[EAConfiguration sharedInstance] getSignature]];
    NSString *check = [url md5];
    url = [url stringByAppendingFormat:@"&check=%@", check];
    return url;
}

#pragma mark - Interface

/// 益钱包详情
+ (NSString *)walletUrl
{
    return [NSString stringWithFormat:@"%@/getwallet", HOST];
}

/// 益定宝一个月
+ (NSString *)ydbOneUrl
{
    return [NSString stringWithFormat:@"%@/getydbone", HOST];
}

/// 益定宝三个月
+ (NSString *)ydbThreeUrl
{
    return [NSString stringWithFormat:@"%@/getydbthree", HOST];
}

/// 益钱包统计
+ (NSString *)walletStatisticsUrl
{
    return [NSString stringWithFormat:@"%@/getwalletstatistics", HOST];
}

/// 我的益钱包详情
+ (NSString*)createMyWalletDetail {
    return [NSString stringWithFormat:@"%@/getmywalletdetail?%@", HOST, [[EAConfiguration sharedInstance] getSignature]];
}

/// 益钱包投资记录
+ (NSString*)createWalletApplyListUrl {
    return [NSString stringWithFormat:@"%@/getwalletapplylist", HOST];
}

/// 益钱包投资排行榜
+ (NSString*)createWalletApplyBoardUrl {
     return [NSString stringWithFormat:@"%@/getwalletapplyboard", HOST];
}

/// 我的益钱包投资记录
+ (NSString*)createMyWalletApplyListUrl {
    return [NSString stringWithFormat:@"%@/getmywalletapplylist?%@&page=1&pagesize=20", HOST, [[EAConfiguration sharedInstance] getSignature]];
}

/// 我的资金流水
+ (NSString *)myTradeLogUrl:(NSString *)tradeType page:(int)page pageCount:(int)pageCount
{
    return [NSString stringWithFormat:@"%@/getmytradelog?%@&tradetype=%@&page=%d&pagesize=%d", HOST, [[EAConfiguration sharedInstance] getSignature], tradeType, page, pageCount];
}

/// 获取我的账户
+ (NSString *)myAccountUrl
{
    return [NSString stringWithFormat:@"%@/getmyaccount?%@", HOST, [[EAConfiguration sharedInstance] getSignature]];
}

/// 获取我的银行账户
+ (NSString *)myBankAccountUrl
{
    return [NSString stringWithFormat:@"%@/getmybankaccount?%@", HOST, [[EAConfiguration sharedInstance] getSignature]];
}

/// 获取用户信息
+ (NSString *)userUrl
{
    // TEST
    return [NSString stringWithFormat:@"%@/getuser?%@", HOST, [[EAConfiguration sharedInstance] getSignature]];
//    return @"http://www.178bank.net/getuser?mobile=13427536210&signature=8992c33374131c96e50810c8dff79ac3";
}

/// 修改登录密码
+ (NSString *)changeLoginPasswordUrl:(NSString *)mobile newPwd:(NSString *)newPassword random:(NSString *)random
{
    NSString *md5pwd = [newPassword md5];
    return [NSString stringWithFormat:@"%@/changeloginpassword?mobile=%@&random=%@&password=%@", HOST, mobile, random, md5pwd];
}

/// 修改交易密码
+ (NSString *)changePayPasswordUrl:(NSString *)idCard newPwd:(NSString *)newPassword random:(NSString *)random
{
    NSString *md5IdCard = [idCard md5];
    NSString *md5pwd = [newPassword md5];
    return [NSString stringWithFormat:@"%@/changepaypassword?%@&idcard=%@&random=%@&password=%@", HOST, [[EAConfiguration sharedInstance] getSignature], md5IdCard, random, md5pwd];
}

/// 获取我的抽奖加息劵
+ (NSString *)myCjJxjResultUrl
{
    return [NSString stringWithFormat:@"%@/getmycjjxjresult?%@", HOST, [[EAConfiguration sharedInstance] getSignature]];
}

/// 判断login
+ (NSString *)loginUrl
{
    return [NSString stringWithFormat:@"%@/login?%@&client=3", HOST, [[EAConfiguration sharedInstance] getSignature]];
}

/// 登录
+ (NSString *)loginUrl:(NSString *)mobile password:(NSString *)pwd
{
    NSString *md5pwd = [pwd md5];
    NSString *signature = [[NSString stringWithFormat:@"%@ %@", mobile, md5pwd] md5];
    return [NSString stringWithFormat:@"%@/login?mobile=%@&signature=%@&client=3", HOST, mobile, signature];
}

/// 注册
+ (NSString *)registerUrl:(NSString *)mobile password:(NSString *)pwd mobileCode:(NSString *)mobileCode
{
    NSString *md5pwd = [pwd md5];
    return [NSString stringWithFormat:@"%@/register?mobile=%@&password=%@&random=%@&client=3", HOST, mobile, md5pwd, mobileCode];
}

/// 发送短信验证码
+ (NSString *)randomSmsUrl:(NSString *)mobile reason:(NSString *)reason
{
    return [NSString stringWithFormat:@"%@/getrandomsms?mobile=%@&reason=%@", HOST, mobile, reason];
}

/// 益钱包申购url
+ (NSString *)applyUrl:(NSString *)payPwd amount:(NSString*)amount cjResultId:(NSString *)cjResultId
{
    NSString *md5pwd = [payPwd md5];
    return [NSString stringWithFormat:@"%@/walletapply?%@&amount=%@&cjResultId=%@&client=3", HOST, [[EAConfiguration sharedInstance] getPaySignature:md5pwd], amount, cjResultId];
}

/// 益定宝申购url
+ (NSString *)ydbApplyUrl:(NSString *)payPwd amount:(NSString *)amount aid:(long)aid
{
    NSString * md5pwd = [payPwd md5];
    return [NSString stringWithFormat:@"%@/ydbapply?%@&amount=%@&aid=%ld&client=3", HOST,[[EAConfiguration sharedInstance] getPaySignature:md5pwd], amount, aid];
}

/// 提现url
+ (NSString *)withdrawUrl:(NSString *)payPwd amount:(NSString *)amount
{
    NSString *md5pwd = [payPwd md5];
    return [NSString stringWithFormat:@"%@/withdraw?%@&amount=%@", HOST, [[EAConfiguration sharedInstance] getPaySignature:md5pwd], amount];
}

/// 充值url
+ (NSString *)createRechargeUrl:(NSString*)moneyOrder
                     haveIdCard:(NSString*)haveIdCard
                   haveBankCard:(NSString*)haveBankCard
                           name:(NSString*)name
                         idCard:(NSString*)idCard
                       bankCard:(NSString*)bankCard;
{
    return [NSString stringWithFormat:@"%@/recharge?%@&money_order=%@&have_id_card=%@&have_bank_card=%@&name=%@&idCard=%@&bankCard=%@&client=3&callbackparam=1",
            HOST, [[EAConfiguration sharedInstance] getSignature], moneyOrder,haveIdCard, haveBankCard, name, idCard, bankCard];
}

/// 实名认证+银行卡绑定url
+ (NSString *)verifyUrl:(NSString *)name idCard:(NSString *)idCard bankCard:(NSString *)bankCard
{
    return [NSString stringWithFormat:@"%@/verify?%@&name=%@&idCard=%@&bankCard=%@", HOST, [[EAConfiguration sharedInstance] getSignature], name, idCard, bankCard];
}

/// 查询银行列表url
+ (NSString *)bankListUrl
{
    return [NSString stringWithFormat:@"%@/getbanklist", HOST];
}


/// 我的最大可赎回金额
+ (NSString *)myWalletMaxRedeem
{
    return [NSString stringWithFormat:@"%@/getmywalletmaxredeem?%@", HOST, [[EAConfiguration sharedInstance] getSignature]];
}

/// 我的赎回金额
+ (NSString *)walletRedeem:(NSString *)payPwd amount:(NSString *)amount
{
    NSString *md5pwd = [payPwd md5];
    return [NSString stringWithFormat:@"%@/redeemwallet?%@&amount=%@", HOST, [[EAConfiguration sharedInstance] getPaySignature:md5pwd], amount];
}

/// 获取IM token
+ (NSString *)imTokenUrl:(NSString *)mobile
{
    return [NSString stringWithFormat:@"%@/getimtoken/%@", HOST, mobile];
}

/// get news
+ (NSString *)newsUrl
{
    return [NSString stringWithFormat:@"%@/getnews", HOST];
}

/// 获取我的资金统计
+ (NSString*)createMyMoneyStatisticsUrl
{
    return [NSString stringWithFormat:@"%@/getmymoneystatistics?%@", HOST, [[EAConfiguration sharedInstance] getSignature]];
}

/// 获取我的 益定宝 列表
+ (NSString*)createMyYdbListUrl:(NSString*)applyStatus
{
    return [NSString stringWithFormat:@"%@/getmyydblist?%@&apply_status=%@", HOST, [[EAConfiguration sharedInstance] getSignature], applyStatus];
}

/// 获取Host
+ (NSString*)createHost
{
    return HOST;
}

/// 获取InviteCode
+ (NSString*)createInviteCodeUrl
{
    return [NSString stringWithFormat:@"%@/getinvitecode?%@", HOST, [[EAConfiguration sharedInstance] getSignature]];
}

/// 获取用户认证信息
+ (NSString*)createGetUserVerify
{
    return [NSString stringWithFormat:@"%@/getuserverify?%@", HOST, [[EAConfiguration sharedInstance] getSignature]];
}

/// 查询银行卡bin查询 & 查询限额
+ (NSString*)createQueryBankCardBinLimitUrl:(NSString*) bankCard
{
    return [NSString stringWithFormat:@"%@/querybankcardbinlimit?bankCard=%@", HOST, bankCard];
}

/// 查询银行限额
+(NSString*)createQueryBankLimitUrl:(NSString*) bankFullName
{
    return [NSString stringWithFormat:@"%@/querybanklimit?bankFullName=%@", HOST, bankFullName];
}

+(NSString*)createRongIMToken:(NSString*) mobile
{
    return [NSString stringWithFormat:@"%@/getimtoken/%@", HOST, mobile];
}

/// 检查版本号
+(NSString*)createCheckVersion
{
#pragma mark -todo
    return @"";
}

/// 益钱包详情
+(NSString*)createWalletDetailUrl
{
    return [NSString stringWithFormat:@"%@/getwalletdetail", HOST];
}

/// 校验支付密码 如果未设置交易密码则直接设置
+(NSString*)createCheckPayPwdUrl:(NSString*) payPwd
{
     NSString *md5pwd = [payPwd md5];
    return [NSString stringWithFormat:@"%@/checkpaypwdsingle?%@&payPwd=%@", HOST, [[EAConfiguration sharedInstance] getPaySignature:md5pwd], md5pwd];
}

+(NSString*)createDqUrl:(NSString*)flag {
    return [NSString stringWithFormat:@"%@/getdqbyflag?flag=%@", HOST, flag];
}

+(NSString*)createIncomeCounterListUrl:(NSString*)counterWay tzAmount:(NSString*)tzAmount yearRate:(NSString*)yearRate tzNo:(NSString*)tzNo {
    return [NSString stringWithFormat:@"%@/getincomecounterlist?counterWay=%@&tzAmount=%@&yearRate=%@&tzNo=%@", HOST, counterWay, tzAmount, yearRate, tzNo];
}

+(NSString*)createExpectedIncomeUrl:(NSString*)tzAmount yearRate:(NSString*)yearRate days:(NSString*)days {
    return [NSString stringWithFormat:@"%@/getexpectedincome?tzAmount=%@&yearRate=%@&days=%@", HOST, tzAmount, yearRate, days];
}

//我的合同
+(NSString*)createMyProtocolUrl:(NSString*)applyId {
    return [NSString stringWithFormat:@"%@/protocol?%@&id=%@", HOST, [[EAConfiguration sharedInstance] getSignature], applyId];
}

//我的定期列表
+(NSString*)createMyDqApplyListUrl:(NSString*)finish page:(int)page pageSize:(int)pageSize {
    return [NSString stringWithFormat:@"%@/getmydqapplylist?%@&finish=%@&page=%d&pagesize=%d", HOST, [[EAConfiguration sharedInstance] getSignature], finish, page, pageSize];
}

+(NSString*)createDqApplyUrl:(NSString*)payPwd amount:(NSString*)amount flag:(NSString*)flag {
    NSString *md5Pwd = [payPwd md5];
    return [NSString stringWithFormat:@"%@/dqapply?%@&amount=%@&payPwd=%@&flag=%@&client=3", HOST, [[EAConfiguration sharedInstance] getPaySignature:md5Pwd], amount, md5Pwd, flag];
}

//定期投资记录
+(NSString*)createDqApplyRecordUrl {
     return [NSString stringWithFormat:@"%@/getdqapplyrecord", HOST];
}

//判断用户是否为新手
+(NSString*)createMemberIsNewbieUrl {
    return [NSString stringWithFormat:@"%@/getmemberisnewbie?%@", HOST, [[EAConfiguration sharedInstance] getSignature]];
}

@end
