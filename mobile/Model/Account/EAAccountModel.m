//
//  EAAccountModel.m
//  mobile
//
//  Created by kevin on 15/11/10.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "EAAccountModel.h"
#import "NSErrorEx.h"
#import "NSObjectEx.h"
#import "EAUrlProvider.h"
#import "EAConfiguration.h"
#import "EACheckUtil.h"
#import "NSStringEx.h"
#import "EAUser.h"
#import "ModelManager.h"
#import "EAAccountModelClient.h"
#import "GTMBase64.h"

@implementation EAAccountModel

- (instancetype)init {
    self = [super init];
    if(self != nil)
    {
        self.loginState = [[EAConfiguration sharedInstance]loginState]? EALoginStateLogined:EALoginStateNotLogined;
    }
    return self;
}

#pragma mark common

- (void)interceptErrorCode:(int)errorCode {
    if(errorCode == EAERROR_MOBILE_OR_PASSWORD || errorCode == EAERROR_LOGIN_NAME_OR_PASSWORD || errorCode == EAERROR_NO_USER) {
        // 账号错误，退出登录，让用户重新登录
        [self logout:^{} failure:^(NSError *error) {}];
    }
}

#pragma mark IEALogin implementation

-(void)login:(NSString*)mobile pwd:(NSString*)pwd success:(void(^)())success failure:(void(^)(NSError* error))failure {
//    DDLogInfo(@"login mobile = %@, pwd=%@", mobile, pwd);
    
    // 参数判断
    if ([mobile length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"请输入手机号"];
        failure(error);
        return;
    }
    
    if ([pwd length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"请输入密码"];
        failure(error);
        return;
    }
    
    [self httpPostReq:[EAUrlProvider loginUrl:mobile password:pwd]
           parameters:nil
              success:^(id responseObject) {
                  NSDictionary *responseDic = (NSDictionary *)responseObject;
                  int errorCode = [responseDic[@"error_code"] epInt];
                  if (errorCode != 0) {
                      self.loginState = EALoginStateNotLogined;
                      [[EAConfiguration sharedInstance] clearAll];
                      
                      NSString *errorDescription = [EABaseModel errorCodeToDescribtion:errorCode];
                      if(errorDescription) {
                          NSError *error = [NSError epOtherErrorWithDescription:errorDescription];
                          failure(error);
                          return;
                      }
                      
                      failure(nil);
                      return;
                  } else {
                      //保存 手机号密码 和登录状态
                      [[EAConfiguration sharedInstance] setSignature:mobile password:pwd];
                      [[EAConfiguration sharedInstance] setLoginState:YES];
                      
                      self.loginState = EALoginStateLogined;
                      
                      NotifyModelClient(EAAccountModelClient, @selector(onLogin), onLogin);

                      success();
                  }
              }
              failure:^(NSError *error) {
                  failure([self commonNetworkFailuerError]);
              }
     ];
}

-(void)logout:(void(^)())success failure:(void(^)(NSError* error))failure {
    DDLogInfo(@"logout");
    
    self.loginState = EALoginStateNotLogined;
    [[EAConfiguration sharedInstance] clearAll];

    NotifyModelClient(EAAccountModelClient, @selector(onLogout), onLogout);
    success();
}

/**
 * 注册
 */
-(void)register:(NSString*)mobile pwd:(NSString*)pwd code:(NSString*)code success:(void(^)())success failure:(void(^)(NSError* error))failure{
    DDLogInfo(@"register mobile = %@, password=%@, code = %@",mobile, pwd, code);
    
    NSError *error = [self checkLoginMobile:mobile andPassword:pwd];
    if(error) {
        failure(error);
        return;
    }
    
    if ([code length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"请输入手机验证码"];
        failure(error);
        return;
    }
    
    [self httpPostReq:[EAUrlProvider registerUrl:mobile password:pwd mobileCode:code]
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
                  
                  //保存 手机号密码 和登录状态
                  [[EAConfiguration sharedInstance] setSignature:mobile password:pwd];
                  [[EAConfiguration sharedInstance] setLoginState:YES];
                  self.loginState = EALoginStateLogined;
                  
                  success();

                  NotifyModelClient(EAAccountModelClient, @selector(onLogin), onLogin);

              } failure:^(NSError *error) {
                  failure([self commonNetworkFailuerError]);
              }
     ];
}

/**
 * 获取修改密码短信验证码
 */
-(void)requestChangeLoginPasswordRandomSms:(NSString*)mobile pwd:(NSString*)pwd success:(void(^)())success failure:(void(^)(NSError* error))failure {
    
    DDLogInfo(@"mobile = %@, pwd = %@", mobile, pwd);
    //登录状态
    BOOL state = [[EAConfiguration sharedInstance] loginState];
    if (state) {
        mobile = [[EAConfiguration sharedInstance] getMobile];
    }
    
    NSError *error = [self checkLoginMobile:mobile andPassword:pwd];
    if(error) {
        failure(error);
        return;
    }
    
    [self httpGetReq:[EAUrlProvider randomSmsUrl:mobile reason:@"changepassword"]
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

/**
 * 修改登录密码
 */
-(void)changeLoginPassword:(NSString*)mobile pwd:(NSString*)pwd code:(NSString*)code success:(void(^)())success failure:(void(^)(NSError* error))failure {
    
    DDLogInfo(@"mobile = %@, pwd = %@, code = %@", mobile, pwd, code);
    
    //登录状态
    BOOL state = [[EAConfiguration sharedInstance] loginState];
    if (state) {
        mobile = [[EAConfiguration sharedInstance] getMobile];
    }
    NSString *finalMobile = mobile;
    
    NSError *error = [self checkLoginMobile:mobile andPassword:pwd];
    if(error) {
        failure(error);
        return;
    }
    
    if ([code length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"请输入手机验证码"];
        failure(error);
        return;
    }
    
    [self httpPostReq:[EAUrlProvider changeLoginPasswordUrl:mobile newPwd:pwd random:code]
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
                  
                  if (state) {
                      //保存 手机号密码 和登录状态
                      [[EAConfiguration sharedInstance] setSignature:finalMobile password:pwd];
                      [[EAConfiguration sharedInstance] setLoginState:YES];
                  }
                  
                  success();
              } failure:^(NSError *error) {
                  failure([self commonNetworkFailuerError]);
              }
     ];
}


- (void)refreshLoginState:(void(^)(NSString*jsCallback))success failure:(void (^)(NSError *error))failure {
    DDLogInfo(@"");
    
    if(self.loginState == EALoginStateLogined) {
        success(@"onRefreshLoginState('true')");
        return;
    } else if (self.loginState == EALoginStateNotLogined) {
        success(@"onRefreshLoginState('false')");
        return;
    } else {
        [self httpPostReq:[EAUrlProvider loginUrl]
               parameters:nil
                  success:^(id responseObject) {
                      NSDictionary *responseDic = (NSDictionary *)responseObject;
                      NSString *jsStr = nil;
                      int errorCode = [responseDic[@"error_code"] epInt];
                      if (errorCode == 0) {
                          [[EAConfiguration sharedInstance] setLoginState:YES];
                          self.loginState = EALoginStateLogined;
                          jsStr = @"onRefreshLoginState('true')";
                      } else {
                          [[EAConfiguration sharedInstance] setLoginState:NO];
                          self.loginState = EALoginStateNotLogined;
                          jsStr = @"onRefreshLoginState('false')";
                      }
                      
                      success(jsStr);
                  }
                  failure:^(NSError *error) {
                      failure([self commonNetworkFailuerError]);
                  }
         ];
    }
}

- (BOOL)isLogin {
    return self.loginState == EALoginStateLogined ? YES : NO;
}

- (void)getLoginMobile:(void(^)(NSString*jsCallback))success failure:(void (^)(NSError *error))failure {
    DDLogInfo(@"");
    
    NSString *mobile = [NSString formatStarMobile:[[EAConfiguration sharedInstance] getMobile]];
    
    NSString *jsStr = [NSString stringWithFormat:@"getCurrentMobile('%@')", mobile];
    success(jsStr);
}

#pragma mark IEAAcount implementation

/**
 * 实名验证
 */
-(void)verify:(NSString*)name idCard:(NSString*)idCard bankCard:(NSString*)bankCard success:(void(^)())success failure:(void(^)(NSError* error))failure {
    
    DDLogInfo(@"name = %@, idCard = %@, bankCard = %@", name, idCard, bankCard);

    if ([name length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"请输入姓名"];
        failure(error);
        return;
    }
    
    
    if (![EACheckUtil isRealName:name]) {
        NSError *error = [NSError epOtherErrorWithDescription:@"请输入正确的姓名"];
        failure(error);
        return;
    }
    
    if (name.length < 2 || name.length > 5) {
        NSError *error = [NSError epOtherErrorWithDescription:@"请输入正确的姓名"];
        failure(error);
        return;
    }
    
    NSError *error = [self checkIdCard:idCard];
    if(error) {
        failure(error);
        return;
    }
    
    if ([bankCard length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"请输入银行卡号"];
        failure(error);
        return;
    }
    
    NSString *isBankCard = [EACheckUtil checkBankNum:bankCard];
    if (![isBankCard isEqualToString:@"true"]) {
        NSError *error = [NSError epOtherErrorWithDescription:@"该银行卡号无效"];
        failure(error);
        return;
    }

    [self httpPostReq:[EAUrlProvider verifyUrl:[[name base64String] URLEncodedString] idCard:idCard bankCard:bankCard]
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
                  
                  NotifyModelClient(EAAccountModelClient, @selector(onVerify), onVerify);
              }
              failure:^(NSError *error) {
                  failure([self commonNetworkFailuerError]);
              }
     ];
}



/**
 * 修改交易密码短信验证码
 */
-(void)requestChangePayPasswordRandomSms:(NSString*)idCard pwd:(NSString*)pwd havePayPwd:(BOOL)havePayPwd success:(void(^)())success failure:(void(^)(NSError* error))failure {
    DDLogInfo(@"idCard = %@, password = %@, havePayPwd = %@", idCard, pwd, havePayPwd ? @"YES" : @"NO");

    NSString *mobile = [[EAConfiguration sharedInstance] getMobile];
    if ([mobile length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"请先登录"];
        failure(error);
        return;
    }
    
    //如果设置过交易密码  就需要身份证验证
    if(havePayPwd) {
        NSError *error = [self checkIdCard:idCard];
        if(error) {
            failure(error);
            return;
        }
    }
    
    if ([pwd length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"请输入新密码"];
        failure(error);
        return;
    }
    if (![EACheckUtil isRightPwd:pwd]) {
        NSError *error = [NSError epOtherErrorWithDescription:@"密码长度为6-20位密码必须为字母加数字"];
        failure(error);
        return;
    }
    
    [self httpGetReq:[EAUrlProvider randomSmsUrl:mobile reason:@"changepaypassword"]
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

/**
 * 修改交易密码
 */
-(void)changePayPassword:(NSString*)idCard pwd:(NSString*)pwd code:(NSString*)code havePayPwd:(BOOL)havePayPwd success:(void(^)())success failure:(void(^)(NSError* error))failure {
    
    DDLogInfo(@"idCard = %@, pwd = %@, code = %@, havePayPwd = %@", idCard, pwd, code, havePayPwd ? @"YES" : @"NO");

    
    NSString *mobile = [[EAConfiguration sharedInstance]getMobile];
    if([mobile length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"请先登录"];
        failure(error);
        return;
    }
    
    if(havePayPwd) {
        NSError *error = [self checkIdCard:idCard];
        if(error) {
            failure(error);
            return;
        }
    }
    
    if ([pwd length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"请输入新密码"];
        failure(error);
        return;
    }
    
    if (![EACheckUtil isRightPwd:pwd]) {
        NSError *error = [NSError epOtherErrorWithDescription:@"密码长度为6-20位密码必须为字母加数字"];
        failure(error);
        return;
        
    }
    
    if ([code length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"请输入手机验证码"];
        failure(error);
        return;
    }
    
    [self httpPostReq:[EAUrlProvider changePayPasswordUrl:idCard newPwd:pwd random:code]
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
              } failure:^(NSError *error) {
                  failure([self commonNetworkFailuerError]);
              }
     ];
}

- (NSError*)checkIdCard:(NSString*)idCard {
    if([idCard length] == 0) {
        return [NSError epOtherErrorWithDescription:@"请输入身份证号"];
    }
    
    if(![EACheckUtil validateIDCardNumber:idCard]) {
        return [NSError epOtherErrorWithDescription:@"请输入正确的身份证号"];
    }
    return nil;
}

/**
 * 获取用户信息
 */
-(void)requestUser:(void(^)(NSString*detail))success failure:(void(^)(NSError* error))failure {
    
    DDLogInfo(@"");
    
    [self httpGetReq:[EAUrlProvider userUrl]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     [self interceptErrorCode:errorCode];
                     
                     NSString *errorDescription = [EABaseModel errorCodeToDescribtion:errorCode];
                     if(errorDescription) {
                         NSError *error = [NSError epOtherErrorWithDescription:errorDescription];
                         failure(error);
                         return;
                     }
                     failure(nil);
                     return;
                 }
                 NSString *str = [responseDic[@"detail"] epString];
                 success(str);
             }
             failure:^(NSError *error) {
                 failure([self commonNetworkFailuerError]);
             }
     ];
}

/*
 * 获取实名验证状态
 */
-(void)userVerifyState:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure{
    
    DDLogInfo(@"");
    
    [self httpGetReq:[EAUrlProvider createGetUserVerify]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     failure(nil);
                     return;
                 }
                 NSString *str = [responseDic[@"detail"] epString];
                 success(str);
             }
             failure:^(NSError *error) {
                 failure([self commonNetworkFailuerError]);
             }
     ];
}

/*
 * 通过名字查找银行限额
 */
-(void)bankLimit:(NSString*)bankFullName success:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure{
    
    DDLogInfo(@"bankFullName = %@", bankFullName);
    
    if([bankFullName length] == 0) {
        failure(nil);
        return;
    }
    
    [self httpGetReq:[EAUrlProvider createQueryBankLimitUrl:[GTMBase64 encodeBase64String:bankFullName]]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     if(errorCode == EAERROR_PARAMETER) {
                         NSError *error = [NSError epOtherErrorWithDescription:@"参数错误"];
                         failure(error);
                         return;
                     }
                     
                     if(errorCode == EAERROR_BANK_CARD){
                         NSError *error = [NSError epOtherErrorWithDescription:@"暂不支持该银行卡号"];
                         failure(error);
                         return;
                     }
                     
                     NSError *error = [NSError epOtherErrorWithDescription:@"获取失败"];
                     failure(error);
                     return;
                 }
                 
                 NSString *str = [responseDic[@"detail"] epString];
                 success(str);
             }
             failure:^(NSError *error) {
                 failure([self commonNetworkFailuerError]);
             }
     ];
}

/*
 * 银行列表
 */
-(void)bankList:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure{
    
    DDLogInfo(@"");
    
    [self httpGetReq:[EAUrlProvider bankListUrl]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     NSError *error = [NSError epOtherErrorWithDescription:@"获取失败"];
                     failure(error);
                     return;
                 }
                 
                 NSString *str = [responseDic[@"list"] epString];
                 success(str);
             }
             failure:^(NSError *error) {
                 failure([self commonNetworkFailuerError]);
             }
     ];
}

/*
 *
 */
-(void)bankCardBinLimit:(NSString*)bankCard success:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure {
    
    DDLogInfo(@"bankCard = %@", bankCard);
    
    if([bankCard length] == 0) {
        failure(nil);
        return;
    }
    
    NSString *isBankCard = [EACheckUtil checkBankNum:bankCard];
    if (![isBankCard isEqualToString:@"true"]) {
        failure(nil);
        return;
    }
    
    [self httpGetReq:[EAUrlProvider createQueryBankCardBinLimitUrl:bankCard]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     if(errorCode == EAERROR_PARAMETER) {
                         NSError *error = [NSError epOtherErrorWithDescription:@"参数错误"];
                         failure(error);
                         return;
                     }
                     
                     if(errorCode == EAERROR_BANK_CARD){
                         NSError *error = [NSError epOtherErrorWithDescription:@"暂不支持该银行卡号"];
                         failure(error);
                         return;
                     }
                     
                     NSError *error = [NSError epOtherErrorWithDescription:@"获取失败"];
                     failure(error);
                     return;
                 }
                 
                 NSString *str = [responseDic[@"detail"] epString];
                 success(str);
             }
             failure:^(NSError *error) {
                 failure([self commonNetworkFailuerError]);
             }
     ];
}

/*
 * 获取我的银行账号
 */
-(void)myBankAccount:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure{
    
    DDLogInfo(@"");
    
    [self httpGetReq:[EAUrlProvider myBankAccountUrl]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     failure(nil);
                     return;
                 }
                 
                 NSString *str = [responseDic[@"detail"] epString];
                 success(str);
             }
             failure:^(NSError *error) {
                 failure([self commonNetworkFailuerError]);
             }
     ];
}

/**
 * 是不是新用户
 **/
-(void)memberIsNewbie:(void(^)(NSString*jsCallback))success failure:(void(^)(NSError *error))failure {
    //如果用户未登录 则为新手
    if(![self isLogin]) {
        NSString *str = [NSString stringWithFormat:@"getMemberIsNewbie('true')"];
        success(str);
        return;
    }
  
    [self httpGetReq:[EAUrlProvider createMemberIsNewbieUrl]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     failure(nil);
                     return;
                 }
                 

                 NSString*str = [responseDic[@"detail"] epString];
                 NSString *jsStr = [NSString stringWithFormat:@"getMemberIsNewbie('%@')", str];
                 success(jsStr);
             }
             failure:^(NSError *error) {
                 failure([self commonNetworkFailuerError]);
             }
     ];
}

@end
