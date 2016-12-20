//
//  EABaseModel.h
//  mobile
//
//  Created by kevin on 15/11/10.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EAPageName) {
    EAPageCommon = 0,
    EAPageLogin = 1, // 登陆页
    EAPageSetLoginPassword = 2,  // 设置登陆密码页
    EAPageSetPayPassword = 3, // 设置交易密码页
    EAPageMe = 4, //我
    EAPageAssets = 5, // 资产
    EAPageFinance = 6, // 理财
    EAPageWallet = 7, // 关于益钱包
    EAPageMyWallet = 8, // 我的益钱包
    EAPageWalletApply = 9,  // 益钱包投资
    EAPageYdb = 10, // 关于益定宝
    EAPageMyYdb = 11, // 我的益定宝
    EAPageYdbApply = 12, // 益定宝投资
    EAPageMoneyStatistics = 13, // 资产统计
    EAPageRecharge = 14, // 充值
    EAPageTradeLog = 15,  // 交易流水
    EAPageWithdraw = 16, // 提现
    EAPageVerify = 17, // 实名验证
    EAPageSetPassword = 18,  // 设置密码
    EAPageRegister = 19, // 注册
    EAPageRedeem = 20, // 赎回
    EAPageNews = 21
};

/// 错误码定义
typedef NS_ENUM(NSInteger, EAErrorCode)
{
    EAERROR_SUCCESS = 0,    // 成功
    EAERROR_PARAMETER = 1,    // 参数错误
    EAERROR_SIGN = 2,   // 错误的签名
    EAERROR_OVER_SPEED = 3,    // 操作速度过快
    EAERROR_IP_LIMIT = 4,    // IP受限
    EAERROR_RANDOM = 5,    // 错误的随机值验证码
    EAERROR_USER_EXCEPTION = 6,   // 用户异常，比如像锁定
    EAERROR_NO_MOBILE = 7,   // 手机号不存在
    
    EAERROR_LOGIN_NAME_OR_PASSWORD = 11,    // 用户名或密码错误
    EAERROR_MOBILE_OR_PASSWORD = 12,    // 手机号或密码错误
    EAERROR_DUMPLICATE_LOGIN_NAME = 13,   // 重复的用户名
    EAERROR_DUMPLICATE_MOBILE = 14,   // 重复的手机号
    EAERROR_NO_USER = 15,   // 没有这个人
    EAERROR_NO_ACCOUNT = 16,   // 没有资金监管账号
    EAERROR_NO_BANK_CARD = 17,   // 没有银行卡号
    EAERROR_DUMPLICATE_BANK_CARD = 18,   // 重复的银行卡号
    EAERROR_PAY_PASSWORD = 19,   // 错误的支付密码
    EAERROR_NO_PAY_PASSWORD = 20,   // 未设置交易密码
    EAERROR_ALREADY_IDENTITY = 21,   // 已进行实名认证
    EAERROR_NO_REAL_NAME = 22,   // 未实名认证
    EAERROR_NO_ENOUGH_BALANCE = 23,   // 余额不足
    EAERROR_NUMERIC = 24,   // 金额填写有误
    EAERROR_BANK_CARD = 25,   // 银行卡错误
    EAERROR_LESS_THAN_1 = 26,   // 小于最低提现金额1
    EAERROR_LESS_THAN_MAX_REDEEM = 27,   // 大于可赎回金额
    EAERROR_VERIFY_REAL_NAME = 28,   // 实名认证失败
    
    EAERROR_TOO_MIN = 30,   // 小于最低转入金额
    EAERROR_TOO_MAX = 31,   // 大于最大转入金额
    EAERROR_MORE_AMOUNT = 32,   // 小于最低转入金额
    EAERROR_ZSB_AMOUNT = 33,   // 申购金额不符合规则
    ERROR_NOT_NEWBIE = 34,   // 不是新手 不能投资新手标

    
    
    TIMEOUT_REGISTER = 120,  // 注册超时
    TIMEOUT_LOGIN = 121,  // 登录超时
    TIMEOUT_SMS = 122,  // 默认的短信超时
    TIMEOUT_RANDOM = 123,
    EAERROR_COMMON = 249,  // 通用型错误
    EAERROR_SERVER = 250,  // 服务器错误, 对用户而言这是不应该出现的，比如数据库连不上
    
    
    TIMEOUT_ONE_DAY = 3600 * 24, // 一天
    TIMEOUT_TOKEN = 3600, // token超时
    TIMEOUT_IP_LIMIT = TIMEOUT_ONE_DAY,  // 同一IP限制多久
};


@interface EABaseModel : NSObject

@property(nonatomic, strong, readonly) NSString *htmlBasePath;
@property(nonatomic, strong, readonly) NSURL *localBaseUrl;

+ (NSString*)errorCodeToDescribtion:(EAErrorCode)errorCode;

+ (NSString*)pageCodeToPageName:(EAPageName)pageName;

+ (EAPageName)toPageName:(NSString*)url;

+ (BOOL)shouldEnablePullRefresh:(NSString*)url;

+ (BOOL)shouldEnablePullLoadMore:(NSString*)url;

- (void)httpGetReq:(NSString *)urlStr parameters:(id)parameters success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure;

- (void)httpPostReq:(NSString *)urlStr parameters:(id)parameters success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure;

- (void)getHost:(void(^)(NSString*jsCallback))success failure:(void (^)(NSError *error))failure;

- (NSError *)commonNetworkFailuerError;

- (void)gotoLocalWebPage:(NSString *)url checkLogin:(NSString *)check goto:(void(^)(NSString*page))gotoPage failure:(void (^)(NSError *error))failure;

- (void)gotoWebPage:(NSString*)url goto:(void(^)(NSString*))gotoPage failure:(void (^)(NSError *error))failure;

- (void)randomSms:(NSString*)mobile pwd:(NSString*)pwd success:(void(^)())success failure:(void (^)(NSError *error))failure;

- (NSError*)checkLoginMobile:(NSString*)mobile andPassword:(NSString*)password;

- (void)loadNews:(void(^)(NSString*jsCallback))success failure:(void (^)(NSError *error))failure;

@end
