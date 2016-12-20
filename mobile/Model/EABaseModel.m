//
//  EABaseModel.m
//  mobile
//
//  Created by kevin on 15/11/10.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "EABaseModel.h"
#import <AFNetworking/AFNetworking.h>
#import "NSErrorEx.h"
#import "EAConfiguration.h"
#import "EAUrlProvider.h"
#import "NSObjectEx.h"
#import "EARegulatoryAccount.h"
#import "EAUser.h"
#import "NSStringEx.h"
#import "EACheckUtil.h"
#import "EARongIMModel.h"
#import "AppDelegate.h"

@implementation EABaseModel
@synthesize htmlBasePath = _htmlBasePath;
@synthesize localBaseUrl = _localBaseUrl;

+ (NSString*)errorCodeToDescribtion:(EAErrorCode)errorCode {
    NSString *description = nil;
    switch (errorCode) {
        case EAERROR_SUCCESS:    // 成功
        break;
        case EAERROR_PARAMETER:// 参数错误
        description = @"参数错误";
        break;
        case EAERROR_SIGN:   // 错误的签名
        break;
        case EAERROR_OVER_SPEED:     // 操作速度过快
        description = @"操作速度过快";
        break;
        case EAERROR_IP_LIMIT:     // IP受限
        description = @"IP受限";
        break;
        case EAERROR_RANDOM:     // 错误的随机值验证码
        description = @"手机验证码错误";
        break;
        case EAERROR_USER_EXCEPTION:    // 用户异常，比如像锁定
        description = @"用户已被锁定";
        break;
        case EAERROR_NO_MOBILE:    // 手机号不存在
        description = @"手机号不存在";
        break;
        case EAERROR_LOGIN_NAME_OR_PASSWORD:     // 用户名或密码错误
        break;
        case EAERROR_MOBILE_OR_PASSWORD:    // 手机号或密码错误
        description = @"手机号或密码错误";
        break;
        case EAERROR_DUMPLICATE_LOGIN_NAME:   // 重复的用户名
        break;
        case EAERROR_DUMPLICATE_MOBILE:    // 重复的手机号
        description = @"手机号已存在";
        break;
        case EAERROR_NO_USER:    // 没有这个人
        description = @"该用户不存在";
        break;
        case EAERROR_NO_ACCOUNT:    // 没有资金监管账号
        description = @"未开通资金监管账户";
        break;
        case EAERROR_NO_BANK_CARD:    // 没有银行卡号
        description = @"请先填写银行卡号";
        break;
        case EAERROR_DUMPLICATE_BANK_CARD:    // 重复的银行卡号
        break;
        case EAERROR_PAY_PASSWORD:    // 错误的支付密码
        description = @"交易密码错误，连续输入错误账号将被锁定";
        break;
        case EAERROR_NO_PAY_PASSWORD:    // 未设置交易密码
        description = @"先设置交易密码";
        break;
        case EAERROR_ALREADY_IDENTITY:    // 已进行实名认证
        break;
        case EAERROR_NO_REAL_NAME:    // 未实名认证
        description = @"请先完成实名认证";
        break;
        case EAERROR_NO_ENOUGH_BALANCE:    // 余额不足
        description = @"余额不足";
        break;
        case EAERROR_NUMERIC:    // 金额填写有误
        description = @"金额输入有误";
        break;
        case EAERROR_BANK_CARD:    // 银行卡错误
        description = @"暂不支持该银行卡号";
        break;
        case EAERROR_LESS_THAN_1:    // 小于最低提现金额1
        description = @"提现金额不能小于1元";
        break;
        case EAERROR_LESS_THAN_MAX_REDEEM:    // 大于可赎回金额
        description = @"大于可赎回金额";
        break;
        case EAERROR_VERIFY_REAL_NAME:    // 实名认证失败
        description = @"身份证校验失败";
        break;
        case EAERROR_TOO_MIN:    // 小于最低转入金额
        break;
        case EAERROR_TOO_MAX:    // 大于最大转入金额
        break;
        case EAERROR_MORE_AMOUNT:    // 小于最低转入金额
        break;
        case EAERROR_ZSB_AMOUNT:    // 申购金额不符合规则
        break;
        case ERROR_NOT_NEWBIE:
            description = @"亲，您已不是新手不能投资新手标哦~";
            break;
        case TIMEOUT_REGISTER:   // 注册超时
        description = @"注册超时";
        break;
        case TIMEOUT_LOGIN:   // 登录超时
        description = @"";
        break;
        case TIMEOUT_SMS:   // 默认的短信超时
        description = @"验证码超时";
        break;
        case TIMEOUT_RANDOM:
        description = @"手机验证码错误";
        break;
        case EAERROR_COMMON:   // 通用型错误
        break;
        case EAERROR_SERVER:   // 服务器错误, 对用户而言这是不应该出现的，比如数据库连不上
        break;
        
        default:
        break;
    }
    return description;
}

- (NSString *)htmlBasePath
{
    if (!_htmlBasePath) {
        NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
        _htmlBasePath = [NSString stringWithFormat:@"%@/Html/assets/ios_assets", mainBundlePath];
    }
    
    return _htmlBasePath;
}

- (NSURL *)localBaseUrl
{
    if (!_localBaseUrl) {
        _localBaseUrl = [NSURL fileURLWithPath:self.htmlBasePath isDirectory:YES];
    }
    
    return _localBaseUrl;
}

+ (NSString*)pageCodeToPageName:(EAPageName)pageNameCode {
    NSString* pageName = nil;
    switch (pageNameCode) {
        case EAPageCommon:
            pageName = @"EAPageCommon";
            break;
        case EAPageLogin:
            pageName = @"EAPageLogin";
            break;
        case EAPageSetLoginPassword:
            pageName = @"EAPageSetLoginPassword";
            break;
        case EAPageSetPayPassword:
            pageName = @"EAPageSetPayPassword";
            break;
        case EAPageMe:
            pageName = @"EAPageMe";
            break;
        case EAPageAssets:
            pageName = @"EAPageAssets";
            break;
        case EAPageFinance:
            pageName = @"EAPageFinance";
            break;
        case EAPageWallet:
            pageName = @"EAPageWallet";
            break;
        case EAPageWalletApply:
            pageName = @"EAPageWalletApply";
            break;
        case EAPageMyWallet:
            pageName = @"EAPageMyWallet";
            break;
        case EAPageYdb:
            pageName = @"EAPageYdb";
            break;
        case EAPageMyYdb:
            pageName = @"EAPageMyYdb";
            break;
        case EAPageYdbApply:
            pageName = @"EAPageYdbApply";
            break;
        case EAPageMoneyStatistics:
            pageName = @"EAPageMoneyStatistics";
            break;
        case EAPageRecharge:
            pageName = @"EAPageRecharge";
            break;
        case EAPageTradeLog:
            pageName = @"EAPageTradeLog";
            break;
        case EAPageWithdraw:
            pageName = @"EAPageWithdraw";
            break;
        case EAPageVerify:
            pageName = @"EAPageVerify";
            break;
        case EAPageSetPassword:
            pageName = @"EAPageSetPassword";
            break;
        case EAPageRegister:
            pageName = @"EAPageRegister";
            break;
        case EAPageRedeem:
            pageName = @"EAPageRedeem";
            break;
        case EAPageNews:
            pageName = @"EAPageNews";
            break;
            
        default:
            break;
    }
    return pageName;
}

+ (EAPageName)toPageName:(NSString*)url {
    EAPageName pageName = EAPageCommon;
    
    if([url containsStringEx:@"login.html"]) {
        pageName = EAPageLogin;
    } else if ([url containsStringEx:@"redeem.html"]) {
        pageName = EAPageRedeem;
    } else if ([url containsStringEx:@"verify.html"]) {
        pageName = EAPageVerify;
    } else if ([url containsStringEx:@"setting_pay_pwd.html"]) {
        pageName = EAPageSetPayPassword;
    } else if ([url containsStringEx:@"register.html"]) {
        pageName = EAPageRegister;
    } else if ([url containsStringEx:@"recharge.html"]) {
        pageName = EAPageRecharge;
    } else if ([url containsStringEx:@"apply.html"]) {
        pageName = EAPageWalletApply;
    } else if ([url containsStringEx:@"apply_ydb.html"]) {
        pageName = EAPageYdbApply;
    } else if ([url containsStringEx:@"my_wallet.html"]) {
        pageName = EAPageMyWallet;
    } else if ([url containsStringEx:@"setting_pwd.html"]) {
        pageName = EAPageSetPassword;
    } else if ([url containsStringEx:@"setting_login_pwd.html"]) {
        pageName = EAPageSetLoginPassword;
    } else if ([url containsStringEx:@"my_ydb.html"]) {
        pageName = EAPageTradeLog;
    } else if ([url containsStringEx:@"tradelog.html"]) {
        pageName = EAPageMyYdb;
    } else if ([url containsStringEx:@"news.html"]) {
        pageName = EAPageNews;
    } else if ([url containsStringEx:@"about_wallet.html"]) {
        pageName = EAPageWallet;
    } else if ([url containsStringEx:@"about_ydb.html"]) {
        pageName = EAPageYdb;
    } else if ([url containsStringEx:@"my_money_statistics.html"]) {
        pageName = EAPageMoneyStatistics;
    }
    return pageName;
}

+ (BOOL)shouldEnablePullRefresh:(NSString*)url {
    if(!url) {
        return NO;
    } else if([url hasSuffix:@"about_ydj.html"]){
        return NO;
    } else if([url hasSuffix:@"aboutus.html"]){
        return NO;
    } else if([url hasSuffix:@"mode.html"]){
        return NO;
    } else if([url hasSuffix:@"aqbz.html"]){
        return NO;
    } else if([url hasSuffix:@"contactus.html"]){
        return NO;
    } else if([url hasSuffix:@"index.html"]){
        return NO;
    } else if([url containsStringEx:@"app_security.html"]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)shouldEnablePullLoadMore:(NSString*)url {
    if(!url) {
        return NO;
    } else if([url hasSuffix:@"my_ydb.html"]){
        return YES;
    } else if([url hasSuffix:@"tradelog.html"]){
        return YES;
    }
    
    return NO;
}

/** 网络请求GET方法 */
- (void)httpGetReq:(NSString *)urlStr parameters:(id)parameters success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    if ([urlStr length] == 0)
        failure([NSError epParameterError]);
    
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    httpManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;   ///不使用缓存
    
    @try {
        [httpManager GET:urlStr
              parameters:parameters
                 success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                     success(responseObject);
                 }
                 failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                     DDLogError(@"http Get Request failure error,%@", error);
                     failure(error);
                 }];
    }
    @catch (NSException *exception) {
        DDLogError(@"http Get Request NSException error,%@", exception);
        
        failure([NSError epCommonError]);
    }
}
/** 网络请求POST方法 */
- (void)httpPostReq:(NSString *)urlStr parameters:(id)parameters success:(void(^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    if ([urlStr length] == 0)
        failure([NSError epParameterError]);
    
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    
    @try {
        [httpManager POST:urlStr
               parameters:parameters
                  success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                      success(responseObject);
                  }
                  failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                      DDLogError(@"http Get Request failure error,%@", error);
                      failure(error);
                  }];
    }
    @catch (NSException *exception) {
        DDLogError(@"http Get Request NSException error,%@", exception);
        
        failure([NSError epCommonError]);
    }
}

/** 服务器连接错误 */
- (NSError *)commonNetworkFailuerError {
    return [NSError epOtherErrorWithDescription:@"无法连接到服务器，请检查您的网络后重试"];
}

- (void)getHost:(void(^)(NSString*jsCallback))success failure:(void (^)(NSError *error))failure {
    DDLogInfo(@"");
    
    NSString* host = [EAUrlProvider createHost];
    NSString *jsStr = [NSString stringWithFormat:@"getHost('%@')", host];
    success(jsStr);
}

- (void)gotoLocalWebPage:(NSString *)url checkLogin:(NSString *)check goto:(void(^)(NSString*))gotoPage failure:(void (^)(NSError *error))failure{
    
    DDLogInfo(@"url = %@, check= %@", url, check);
    
    if ([url length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"暂未开放，敬请期待"];
        failure(error);
        return;
    }
    
    if ([check isEqualToString:@"true"]) {
        if (![[EAConfiguration sharedInstance] loginState]) {
            gotoPage(@"login.html");
            return;
        }
    }
    
    //如果是赎回
    if([@"redeem.html" isEqualToString:url]) {
        [self httpGetReq:[EAUrlProvider myWalletMaxRedeem]
              parameters:nil
                 success:^(id responseObject) {
                     NSDictionary *responseDic = (NSDictionary *)responseObject;
                     int errorCode = [responseDic[@"error_code"] epInt];
                     if (errorCode != 0) {
                         NSError *error = [NSError epOtherErrorWithDescription:@"获取可赎回金额失败"];
                         failure(error);
                         return;
                     }
                     
                     double amount = [responseDic[@"amount"] epDouble];
                     if(amount <= 0) {
                         NSError *error = [NSError epOtherErrorWithDescription:@"您的益钱包无可赎回金额"];
                         failure(error);
                         return;
                     } else {
                         gotoPage(url);
                     }
                 }
                 failure:^(NSError *error) {
                     failure([self commonNetworkFailuerError]);
                     return;
                 }
         ];
    }
    
    //如果是提现
    else if([@"withdraw.html" isEqualToString:url]) {
        [self httpGetReq:[EAUrlProvider myAccountUrl]
              parameters:nil
                 success:^(id responseObject) {
                     NSDictionary *responseDic = (NSDictionary *)responseObject;
                     int errorCode = [responseDic[@"error_code"] epInt];
                     if (errorCode != 0) {
                         NSError *error = [NSError epOtherErrorWithDescription:@"获取可提现金额失败"];
                         failure(error);
                         return;
                     }
                     
                     NSString *detail = [responseDic[@"detail"] epString];
                     EARegulatoryAccount *account = [[EARegulatoryAccount alloc]init];
                     [account parseJsonString:detail];
                     if(account.useBalance <= 0 ) {
                         NSError *error = [NSError epOtherErrorWithDescription:@"您暂无可提现金额"];
                         failure(error);
                         return;
                     } else {
                         
                         [self httpGetReq:[EAUrlProvider userUrl] parameters:nil success:^(id responseObject) {
                             NSDictionary *responseDic = (NSDictionary *)responseObject;
                             int errorCode = [responseDic[@"error_code"] epInt];
                             if (errorCode != 0) {
                                 NSError *error = [NSError epOtherErrorWithDescription:@"获取用户信息失败"];
                                 failure(error);
                                 return;
                             }
                             
                             NSString *str = [responseDic[@"detail"] epString];
                             EAUser *user = [[EAUser alloc] init];
                             [user parseJsonString:str];
                             user.name = [user.name base64DecodeString];
                             
                             //如果未完成实名认证   跳转到  实名认证页面
                             if(user.idCardStatus != 0 && user.idCardStatus != 1) {
                                 [AppDelegate showTipsOnGlobalWindow:@"提现请先完成实名认证"];
                                 
                                 gotoPage(@"verify.html");
                                 return;
                             } else {
                                 //查询用户是否设置交易密码
                                 [self httpGetReq:[EAUrlProvider myAccountUrl] parameters:nil success:^(id responseObject) {
                                     NSDictionary *responseDic = (NSDictionary *)responseObject;
                                     int errorCode = [responseDic[@"error_code"] epInt];
                                     if (errorCode != 0) {
                                         NSError *error = [NSError epOtherErrorWithDescription:@"获取用户信息失败"];
                                         failure(error);
                                         return;
                                     }
                                     
                                     NSString *detail = [responseDic[@"detail"] epString];
                                     EARegulatoryAccount *account = [[EARegulatoryAccount alloc]init];
                                     [account parseJsonString:detail];
                                     if(!account.havePayPwd) {
                                         [AppDelegate showTipsOnGlobalWindow:@"请先设置交易密码"];
                                         gotoPage(@"setting_pay_pwd.html");
                                         return;
                                     } else {
                                         gotoPage(url);
                                     }
                                 } failure:^(NSError *error) {
                                     failure(error);
                                 }];
                             }
                             
                         } failure:^(NSError *error) {
                             failure(error);
                         }];
                     }
                 }
                 failure:^(NSError *error) {
                     failure([self commonNetworkFailuerError]);
                 }
         ];
    }
    
    //如果是设置或者修改交易密码
    else if([@"setting_pay_pwd.html" isEqualToString:url]) {
        [self httpGetReq:[EAUrlProvider myAccountUrl] parameters:nil success:^(id responseObject) {
            NSDictionary *responseDic = (NSDictionary *)responseObject;
            int errorCode = [responseDic[@"error_code"] epInt];
            if (errorCode != 0) {
                NSError *error = [NSError epOtherErrorWithDescription:@"获取用户信息失败"];
                failure(error);
                return;
            }
            
            NSString *detail = [responseDic[@"detail"] epString];
            EARegulatoryAccount *account = [[EARegulatoryAccount alloc]init];
            [account parseJsonString:detail];
            
            if(account.havePayPwd) {
                [self httpGetReq:[EAUrlProvider userUrl] parameters:nil success:^(id responseObject) {
                    NSDictionary *responseDic = (NSDictionary *)responseObject;
                    int errorCode = [responseDic[@"error_code"] epInt];
                    if (errorCode != 0) {
                        NSError *error = [NSError epOtherErrorWithDescription:@"获取用户信息失败"];
                        failure(error);
                        return;
                    }
                    
                    NSString *str = [responseDic[@"detail"] epString];
                    EAUser *user = [[EAUser alloc] init];
                    [user parseJsonString:str];
                    
                    //如果未完成实名认证   跳转到  实名认证页面
                    if(user.idCardStatus != 0 && user.idCardStatus != 1) {
                        [AppDelegate showTipsOnGlobalWindow:@"修改交易密码请先完成实名认证"];
                        gotoPage(@"verify.html");
                        return;
                    } else {
                        gotoPage(url);
                    }
                    
                } failure:^(NSError *error) {
                    failure(error);
                }];
                
            } else {
                gotoPage(url);
            }
            
        } failure:^(NSError *error) {
            failure(error);
        }];
    }    
    else {
        gotoPage(url);
    }
}

-(void)gotoWebPage:(NSString*)url goto:(void(^)(NSString*))gotoPage failure:(void (^)(NSError *error))failure{
    
    DDLogInfo(@"url = %@",url);

    if ([url length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"参数错误"];
        failure(error);
    }
    
    gotoPage(url);
}

-(void)randomSms:(NSString*)mobile pwd:(NSString*)pwd success:(void(^)())success failure:(void (^)(NSError *error))failure{
    
    DDLogInfo(@"mobile = %@, password=%@", mobile, pwd);
    
    NSError *error = [self checkLoginMobile:mobile andPassword:pwd];
    if(error) {
        failure(error);
        return;
    }
    
    [self httpGetReq:[EAUrlProvider randomSmsUrl:mobile reason:@"register"]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     NSString *errorDescription = [EABaseModel errorCodeToDescribtion:errorCode];
                     if(errorDescription) {
                         NSError *error = [NSError epOtherErrorWithDescription:errorDescription];
                         failure(error);
                         return;
                     }
                     
                     failure(nil);
                     return;
                 }
                 
                 success();
             }
             failure:^(NSError *error) {
                 failure([self commonNetworkFailuerError]);
             }
     ];
}

- (NSError*)checkLoginMobile:(NSString*)mobile andPassword:(NSString*)password {
    if ([mobile length] == 0) {
        return [NSError epOtherErrorWithDescription:@"请输入手机号"];
    }
    
    if (![EACheckUtil isMobile:mobile]) {
        return [NSError epOtherErrorWithDescription:@"请输入正确格式的11位手机号码"];;
    }
    
    if ([password length] == 0) {
        return [NSError epOtherErrorWithDescription:@"请输入密码"];;
    }
    
    if (![EACheckUtil isRightPwd:password]) {
        return [NSError epOtherErrorWithDescription:@"密码长度为6-20位密码必须为字母加数字"];;
    }
    return nil;
}

- (void)loadNews:(void(^)(NSString*jsCallback))success failure:(void (^)(NSError *error))failure {
    DDLogInfo(@"");
    
    [self httpGetReq:[EAUrlProvider newsUrl]
          parameters:nil
             success:^(id responseObject) {
                 NSString *jsStr = [NSString stringWithFormat:@"loadNews('%@')", responseObject];
                 success(jsStr);
             }
             failure:^(NSError *error) {
                 failure([self commonNetworkFailuerError]);
             }];
}

@end
