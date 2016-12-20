//
//  EAAssetsModel.m
//  mobile
//
//  Created by kevin on 15/11/10.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "EAAssetsModel.h"
#import "EAUrlProvider.h"
#import "NSObjectEx.h"
#import "NSErrorEx.h"
#import "EACheckUtil.h"
#import "GTMBase64.h"
#import "NSStringEx.h"
#import "EARegulatoryAccount.h"
#import "EAAssetsModelClient.h"
#import "ModelManager.h"
#import "EAStringUtil.h"

@implementation EAAssetsModel


#pragma mark IEAWalletAssets implementation

/*
 * 获取我的益钱包
 */
-(void)myWalletDetail:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure {

    DDLogInfo(@"");
    
    [self httpGetReq:[EAUrlProvider createMyWalletDetail]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     NSError *error = [NSError epOtherErrorWithDescription:@"获取我的益钱包信息失败"];
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
 * 益钱包
 */
-(void)wallet:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure {
    DDLogInfo(@"");
    
    [self httpGetReq:[EAUrlProvider walletUrl]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
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
 * 益钱包详情
 */
-(void)walletDetail:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure {
    DDLogInfo(@"");
    
    [self httpGetReq:[EAUrlProvider createWalletDetailUrl]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     NSError *error = [NSError epOtherErrorWithDescription:@"获取益钱包信息失败"];
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
 * 关于益钱包
 */
-(void)aboutWallet:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure {

    DDLogInfo(@"");
    
    [self httpGetReq:[EAUrlProvider walletStatisticsUrl]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     NSError *error = [NSError epOtherErrorWithDescription:@"获取益钱包信息失败"];
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
 * 益钱包赎回
 */
-(void)walletRedeem:(NSString*)amount
             pawPwd:(NSString*)payPwd
    maxRedeemAmount:(NSString*)maxRedeemAmount
            success:(void(^)())success
            failure:(void(^)(NSError *error))failure {
    
    DDLogInfo(@"mount = %@, payPwd = %@, maxRedeemAmount = %@",
              amount, payPwd, maxRedeemAmount);
    
    if ([amount length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"请输入赎回金额"];
        failure(error);
        return;
    }
    
    if (![EACheckUtil isRightMoney:amount]) {
        NSError *error = [NSError epOtherErrorWithDescription:@"请输入正确的金额(精确到分)"];
        failure(error);
        return;
    }
    
    if ([maxRedeemAmount length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"获取可赎回金额失败"];
        failure(error);
        return;
    }
    
    if ([amount doubleValue] > [maxRedeemAmount doubleValue]) {
        NSError *error = [NSError epOtherErrorWithDescription:@"大于可赎回金额"];
        failure(error);
        return;
    }
    
    if ([payPwd length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"请输入交易密码"];
        failure(error);
        return;
    }
    
    [self httpPostReq:[EAUrlProvider walletRedeem:payPwd amount:amount]
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
                  
                  NotifyModelClient(EAAssetsModelClient, @selector(onWalletRedeem:), onWalletRedeem:[amount doubleValue]);
              }
              failure:^(NSError *error) {
                  failure([self commonNetworkFailuerError]);
              }
     ];
}

/*
 * 益钱包投资
 */
-(void)walletApply:(NSString*)amount
            payPwd:(NSString*)payPwd
        useBalance:(NSString*)useBalance
        havePayPwd:(BOOL)havePayPwd
        cjResultId:(NSString*)cjResultId
            minNum:(NSString*)minNum
    isRefreshEvent:(BOOL)isRefreshEvent
      inadequateJs:(void(^)(NSString*jsCallback))inadequateJs
           success:(void(^)())success
           failure:(void(^)(NSError *error))failure{
    
    DDLogInfo(@"mount = %@, payPwd = %@, userBalance = %@, havePayPwd = %@, cjResultId = %@",
              amount, payPwd, useBalance, havePayPwd?@"YES":@"NO", cjResultId);
    
    
    if ([amount length] == 0) {
        if(!isRefreshEvent) {
            NSError *error = [NSError epOtherErrorWithDescription:@"请输入转入金额"];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
    
    if (![EACheckUtil isRightMoney:amount]) {
        if(!isRefreshEvent) {
            NSError *error = [NSError epOtherErrorWithDescription:@"请输入正确的金额(精确到分)"];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
    
    if ([minNum length] == 0) {
        if(!isRefreshEvent) {
            NSError *error = [NSError epOtherErrorWithDescription:@"获取最低转入金额失败"];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
    
    if ([amount doubleValue] < [minNum doubleValue]) {
        if(!isRefreshEvent) {
            NSString *tips = [NSString stringWithFormat:@"小于最低转入金额，至少转入%@元",minNum];
            NSError *error = [NSError epOtherErrorWithDescription:tips];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
    
    if ([payPwd length] == 0) {
        if(!isRefreshEvent) {
            NSError *error = [NSError epOtherErrorWithDescription:@"请输入交易密码"];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
    
    //如果未设置交易密码
    if(!havePayPwd) {
        if(![EACheckUtil isRightPwd:payPwd]) {
            if(!isRefreshEvent) {
                NSError *error = [NSError epOtherErrorWithDescription:@"密码长度为6-20位密码必须为字母加数字"];
                failure(error);
                return;
            }
            
            failure(nil);
            return;
        }
    }
    
    [self httpPostReq:[EAUrlProvider createCheckPayPwdUrl:payPwd]
           parameters:nil
              success:^(id responseObject) {
                  NSDictionary *responseDic = (NSDictionary *)responseObject;
                  int errorCode = [responseDic[@"error_code"] epInt];
                  if(errorCode != 0) {
                      DDLogWarn(@"walletApply : createCheckPayPwdUrl failed errorCode = %d", errorCode);
                      
                      NSString *errorDescription = [EABaseModel errorCodeToDescribtion:errorCode];
                      if(errorDescription) {
                          NSError *error = [NSError epOtherErrorWithDescription:errorDescription];
                          failure(error);
                          return;
                      }
                      
                      NSError *error = [NSError epOtherErrorWithDescription:@"获取用户信息失败"];
                      failure(error);
                      return;
                  }
                  
                  // 如果校验成功    调用远程接口  查询最新的可用余额
                  [self httpGetReq:[EAUrlProvider myAccountUrl] parameters:nil success:^(id responseObject) {
                      NSDictionary *responseDic = (NSDictionary *)responseObject;
                      int errorCode = [responseDic[@"error_code"] epInt];
                      if(errorCode != 0) {
                          NSError *error = [NSError epOtherErrorWithDescription:@"获取可用金额失败"];
                          failure(error);
                          return;
                      }
                      
                      NSString *detail = [responseDic[@"detail"] epString];
                      EARegulatoryAccount *account = [[EARegulatoryAccount alloc]init];
                      [account parseJsonString:detail];
                      
                      //可用金额小于填写金额  弹出提示框
                      if(account.useBalance < [amount doubleValue]) {
                          NSString *addMoney = [NSString stringWithFormat:@"%.2f", [amount doubleValue] - account.useBalance];
                          NSString *jsUrl = [NSString stringWithFormat:@"showHideBox('%@')", addMoney];
                          inadequateJs(jsUrl);
                          return;
                      }
                      
                      //调用益钱包 转入接口 完成转入
                      [self httpPostReq:[EAUrlProvider applyUrl:payPwd amount:amount cjResultId:cjResultId]
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
                                    
                                    NotifyModelClient(EAAssetsModelClient, @selector(onWalletApply:), onWalletApply:[amount doubleValue]);
                                }
                                failure:^(NSError *error) {
                                    failure([self commonNetworkFailuerError]);
                                }];
                  } failure:^(NSError *error) {
                      failure([self commonNetworkFailuerError]);
                  }
                   ];
              } failure:^(NSError *error) {
                  failure([self commonNetworkFailuerError]);
              }
     ];
}

/**
 * 益钱包最大赎回金额
 */
-(void)myWalletMaxRedeem:(void(^)(NSString*detail))success
                 failure:(void(^)(NSError *error))failure{
    
    DDLogInfo(@"");
    
    [self httpGetReq:[EAUrlProvider myWalletMaxRedeem]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     failure(nil);
                     return;
                 }
                 
                 NSString *amount = [responseDic[@"amount"] epString];
                 success(amount);
             }
             failure:^(NSError *error) {
                 failure([self commonNetworkFailuerError]);
             }
     ];
}

/**
 * 获取益钱包转入失败
 */
-(void)requestWalletApplyList:(void(^)())success
                      failure:(void(^)(NSError *error))failure {
    DDLogInfo(@"");
    [self httpGetReq:[EAUrlProvider createWalletApplyListUrl]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     NSError *error = [NSError epOtherErrorWithDescription:@"获取益钱包投资记录失败"];
                     failure(error);
                     return;
                 }
                 
                 NSString *detail = [responseDic[@"detail"] epString];
                 success(detail);
             }
             failure:^(NSError *error) {
                 failure([self commonNetworkFailuerError]);
             }
     ];
}

/**
 * 获取益钱包排行榜(前10)
 */
-(void)requestWalletApplyBoard:(void(^)())success
                       failure:(void(^)(NSError *error))failure {
    DDLogInfo(@"");
    [self httpGetReq:[EAUrlProvider createWalletApplyBoardUrl]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     NSError *error = [NSError epOtherErrorWithDescription:@"获取益钱包排行榜失败"];
                     failure(error);
                     return;
                 }
                 
                 NSString *detail = [responseDic[@"detail"] epString];
                 success(detail);
             }
             failure:^(NSError *error) {
                 failure([self commonNetworkFailuerError]);
             }
     ];
}

#pragma mark IEAYdbAssets @implementation

/*
 * 益定宝
 */
-(void)ydb:(NSString*)type success:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure{

    DDLogInfo(@"type = %@", type);
    
    NSString *url = @"";
    if ([type isEqualToString:@"1"]) {
        url = [EAUrlProvider ydbOneUrl];
    } else if ([type isEqualToString:@"3"]) {
        url = [EAUrlProvider ydbThreeUrl];
    } else {
        NSError *error = [NSError epOtherErrorWithDescription:@"获取益定宝信息失败"];
        failure(error);
        return;
    }
    
    [self httpGetReq:url
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     NSError *error = [NSError epOtherErrorWithDescription:@"获取益定宝信息失败"];
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
 * 我的益定宝列表
 */
-(void)myYdbList:(NSString*)applyStatus success:(void(^)(NSString*list))success failure:(void(^)(NSError *error))failure{

    DDLogInfo(@"applyStatus = %@", applyStatus);
    
    if([applyStatus length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"参数错误"];
        failure(error);
        return;
    }
    
    [self httpGetReq:[EAUrlProvider createMyYdbListUrl:applyStatus]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                    NSError *error = [NSError epOtherErrorWithDescription:@"获取我的益定宝信息失败"];
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
 * 益定宝投资
 */
-(void)ydbApply:(NSString*)amount
         payPwd:(NSString*)payPwd
     useBalance:(NSString*)useBalance
      hasPayPwd:(BOOL)hasPayPwd
     cjResultId:(NSString*)cjResultId
            aid:(NSString*)aid
   remainAmount:(NSString*)remainAmount
         minNum:(NSString*)minNum
 isRefreshEvent:(BOOL)isRefreshEvent
   inadequateJs:(void(^)(NSString*jsCallback))inadequateJs
        success:(void(^)())success
        failure:(void(^)(NSError *error))failure {
    DDLogInfo(@"amount = %@, payPwd = %@, useBalance = %@, hasPayPwd = %@, cjResultId = %@, aid = %@, remain_amount = %@, minNum = %@, isRefreshEvent = %@",
              amount, payPwd, useBalance, hasPayPwd ? @"YES" : @"NO", cjResultId, aid
              , remainAmount, minNum, isRefreshEvent ? @"YES" : @"NO");
    
    if ([amount length] == 0)
    {
        if(!isRefreshEvent) {
            NSError *error = [NSError epOtherErrorWithDescription:@"请输入投资金额"];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
    
    if (![EACheckUtil isRightMoney:amount]) {
        if(!isRefreshEvent) {
            NSError *error = [NSError epOtherErrorWithDescription:@"请输入正确的金额(精确到分)"];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
    
    if([minNum length] == 0) {
        if(!isRefreshEvent) {
            NSError *error = [NSError epOtherErrorWithDescription:@"获取最低投资金额失败"];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
    
    if ([amount doubleValue] < [minNum intValue]) {
        if(!isRefreshEvent) {
            NSError *error = [NSError epOtherErrorWithDescription:[NSString stringWithFormat:@"小于最低投资金额，至少转入%@元" , minNum]];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
    
    if (([amount doubleValue] - [amount longLongValue] == 0) && ([amount longLongValue] % [minNum intValue] != 0)) {
        if(!isRefreshEvent) {
            NSString *astring = [[NSString alloc] initWithString:[NSString stringWithFormat:@"请以%d的整数倍投资",[minNum intValue]]];
            NSError *error = [NSError epOtherErrorWithDescription:astring];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
    
    if ([aid length] == 0 || ![aid isPureInt]) {
        if(!isRefreshEvent) {
            NSError *error = [NSError epOtherErrorWithDescription:@"获取益定宝信息失败"];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
    
    if ([remainAmount length] == 0) {
        if(!isRefreshEvent) {
            NSError *error = [NSError epOtherErrorWithDescription:@"获取可购金额失败"];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
    
    if ([amount doubleValue] > [remainAmount doubleValue]) {
        if(!isRefreshEvent) {
            NSError *error = [NSError epOtherErrorWithDescription:@"大于可购金额"];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
    if ([payPwd length] == 0) {
        if(!isRefreshEvent) {
            NSError *error = [NSError epOtherErrorWithDescription:@"请输入交易密码"];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
    
    if(!hasPayPwd) {
        if(![EACheckUtil isRightPwd:payPwd]) {
            if(!isRefreshEvent) {
                NSError *error = [NSError epOtherErrorWithDescription:@"密码长度为6-20位密码必须为字母加数字"];
                failure(error);
                return;
            }
            
            failure(nil);
            return;
        }
    }
    
    //校验支付密码    如果未设置交易密码则设置交易密码  如果已有交易密码则校验其正确性
    [self httpPostReq:[EAUrlProvider createCheckPayPwdUrl:payPwd]
           parameters:nil
              success:^(id responseObject) {
                  NSDictionary *responseDic = (NSDictionary *)responseObject;
                  int errorCode = [responseDic[@"error_code"] epInt];
                  if(errorCode != 0) {
                      
                      NSString *errorDescription = [EABaseModel errorCodeToDescribtion:errorCode];
                      if(errorDescription) {
                          NSError *error = [NSError epOtherErrorWithDescription:errorDescription];
                          failure(error);
                          return;
                      }

                      NSError *error = [NSError epOtherErrorWithDescription:@"获取用户信息失败"];
                      failure(error);
                      return;
                  } else {
                      // 如果校验成功    调用远程接口  查询最新的可用余额
                      [self httpGetReq:[EAUrlProvider myAccountUrl] parameters:nil success:^(id responseObject) {
                          NSDictionary *responseDic = (NSDictionary *)responseObject;
                          int errorCode = [responseDic[@"error_code"] epInt];
                          if(errorCode != 0) {
                              NSError *error = [NSError epOtherErrorWithDescription:@"获取可用金额失败"];
                              failure(error);
                              return;
                          }
                          
                          NSString *detail = [responseDic[@"detail"] epString];
                          EARegulatoryAccount *account = [[EARegulatoryAccount alloc]init];
                          [account parseJsonString:detail];
                          
                          //可用金额小于填写金额  弹出提示框
                          if(account.useBalance < [amount doubleValue]) {
                              NSString *addMoney = [NSString stringWithFormat:@"%.2f", [amount doubleValue] - account.useBalance];
                              NSString *jsUrl = [NSString stringWithFormat:@"showHideBox('%@')", addMoney];
                              inadequateJs(jsUrl);
                              return;
                          } else {
                              //调用益钱包 转入接口 完成转入
                              [self httpPostReq:[EAUrlProvider ydbApplyUrl:payPwd amount:amount aid:[aid intValue]]
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
                                            
                                            NotifyModelClient(EAAssetsModelClient, @selector(onYdbApply:), onYdbApply:[amount doubleValue]);
                                        }
                                        failure:^(NSError *error) {
                                            failure([self commonNetworkFailuerError]);
                                        }
                               ];
                          }
                          
                      } failure:^(NSError *error) {
                          failure([self commonNetworkFailuerError]);
                      }];
                  }
              } failure:^(NSError *error) {
                  failure([self commonNetworkFailuerError]);
              }
     ];
}

/**
 * 益定宝投资（新）
 */
-(void)dqApply:(NSString*)amount
        payPwd:(NSString*)payPwd
    useBalance:(NSString*)useBalance
    havePayPwd:(BOOL)havePayPwd
    cjResultId:(NSString*)cjResultId
          flag:(NSString*)flag
        minNum:(NSString*)minNum
        maxNum:(NSString*)maxNum
isRefreshEvent:(BOOL)isRefreshEvent
  inadequateJs:(void(^)(NSString*jsCallback))inadequateJs
       success:(void(^)())success
       failure:(void(^)(NSError *error))failure {
    DDLogInfo(@"amount = %@, payPwd = %@, useBalance = %@, hasPayPwd = %@, cjResultId = %@, minNum = %@, isRefreshEvent = %@",
              amount, payPwd, useBalance, havePayPwd ? @"YES" : @"NO", cjResultId, minNum, isRefreshEvent ? @"YES" : @"NO");
    
    if ([amount length] == 0) {
        if(!isRefreshEvent) {
            NSError *error = [NSError epOtherErrorWithDescription:@"请输入投资金额"];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
    
    if (![EACheckUtil isRightMoney:amount]) {
        if(!isRefreshEvent) {
            NSError *error = [NSError epOtherErrorWithDescription:@"请输入正确的金额(精确到分)"];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
    
    if([minNum length] == 0) {
        if(!isRefreshEvent) {
            NSError *error = [NSError epOtherErrorWithDescription:@"获取最低投资金额失败"];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
    
    if ([amount doubleValue] < [minNum intValue]) {
        if(!isRefreshEvent) {
            NSError *error = [NSError epOtherErrorWithDescription:[NSString stringWithFormat:@"小于最低投资金额，至少投资%@元" , minNum]];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
    
//    if (([amount doubleValue] - [amount longLongValue] == 0) && ([amount longLongValue] % [minNum intValue] != 0)) {
//        if(!isRefreshEvent) {
//            NSString *astring = [[NSString alloc] initWithString:[NSString stringWithFormat:@"请以%d的整数倍投资",[minNum intValue]]];
//            NSError *error = [NSError epOtherErrorWithDescription:astring];
//            failure(error);
//            return;
//        }
//        
//        failure(nil);
//        return;
//    }
    
    if([maxNum length] ==0) {
        if(!isRefreshEvent) {
            NSError *error = [NSError epOtherErrorWithDescription:@"获取最大投资金额失败"];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
    
    if ([amount doubleValue] > [maxNum doubleValue]) {
        if(!isRefreshEvent) {
            NSError *error = [NSError epOtherErrorWithDescription:[NSString stringWithFormat:@"大于最大投资金额，最多可投%@元", maxNum]];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
    
    if([flag length] == 0) {
        if(!isRefreshEvent) {
            NSError *error = [NSError epOtherErrorWithDescription:@"获取益定宝信息失败"];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
   
    
    
    if ([payPwd length] == 0) {
        if(!isRefreshEvent) {
            NSError *error = [NSError epOtherErrorWithDescription:@"请输入交易密码"];
            failure(error);
            return;
        }
        
        failure(nil);
        return;
    }
    
    if(!havePayPwd) {
        if(![EACheckUtil isRightPwd:payPwd]) {
            if(!isRefreshEvent) {
                NSError *error = [NSError epOtherErrorWithDescription:@"密码长度为6-20位密码必须为字母加数字"];
                failure(error);
                return;
            }
            
            failure(nil);
            return;
        }
    }
    
    //校验支付密码    如果未设置交易密码则设置交易密码  如果已有交易密码则校验其正确性
    [self httpPostReq:[EAUrlProvider createCheckPayPwdUrl:payPwd]
           parameters:nil
              success:^(id responseObject) {
                  NSDictionary *responseDic = (NSDictionary *)responseObject;
                  int errorCode = [responseDic[@"error_code"] epInt];
                  if(errorCode != 0) {
                      
                      NSString *errorDescription = [EABaseModel errorCodeToDescribtion:errorCode];
                      if(errorDescription) {
                          NSError *error = [NSError epOtherErrorWithDescription:errorDescription];
                          failure(error);
                          return;
                      }
                      
                      NSError *error = [NSError epOtherErrorWithDescription:@"获取用户信息失败"];
                      failure(error);
                      return;
                  } else {
                      // 如果校验成功    调用远程接口  查询最新的可用余额
                      [self httpGetReq:[EAUrlProvider myAccountUrl] parameters:nil success:^(id responseObject) {
                          NSDictionary *responseDic = (NSDictionary *)responseObject;
                          int errorCode = [responseDic[@"error_code"] epInt];
                          if(errorCode != 0) {
                              NSError *error = [NSError epOtherErrorWithDescription:@"获取可用金额失败"];
                              failure(error);
                              return;
                          }
                          
                          NSString *detail = [responseDic[@"detail"] epString];
                          EARegulatoryAccount *account = [[EARegulatoryAccount alloc]init];
                          [account parseJsonString:detail];
                          
                          //可用金额小于填写金额  弹出提示框
                          if(account.useBalance < [amount doubleValue]) {
                              NSString *addMoney = [NSString stringWithFormat:@"%.2f", [amount doubleValue] - account.useBalance];
                              NSString *jsUrl = [NSString stringWithFormat:@"showHideBox('%@')", addMoney];
                              inadequateJs(jsUrl);
                              return;
                          } else {
                              //调用益钱包 转入接口 完成转入
                              [self httpPostReq:[EAUrlProvider createDqApplyUrl:payPwd amount:amount flag:flag]
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
                                            
                                            NotifyModelClient(EAAssetsModelClient, @selector(onYdbApply:), onYdbApply:[amount doubleValue]);
                                        }
                                        failure:^(NSError *error) {
                                            failure([self commonNetworkFailuerError]);
                                        }
                               ];
                          }
                          
                      } failure:^(NSError *error) {
                          failure([self commonNetworkFailuerError]);
                      }];
                  }
              } failure:^(NSError *error) {
                  failure([self commonNetworkFailuerError]);
              }
     ];

}

-(void)getDqByFlag:(NSString *)flag success:(void(^)(NSString *detail))success failure:(void(^)(NSError *error))failure {
    DDLogInfo(@"");
    
    if ([flag length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"获取益定宝信息失败"];
        failure(error);
        return;
    }
    
    [self httpGetReq:[EAUrlProvider createDqUrl:flag]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     NSError *error = [NSError epOtherErrorWithDescription:@"获取益定宝信息失败"];
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


-(void)myDqApplyList:(NSString*)finish page:(int)page pageSize:(int)pageSize success:(void(^)(NSString*detail))success failure:(void(^)(NSError*error))failure {
    DDLogInfo(@"");
    
    if([finish length] == 0 || ![finish isPureInt]) {
        NSError *error = [NSError epOtherErrorWithDescription:@"参数错误"];
        failure(error);
        return;
    }
    
    [self httpGetReq:[EAUrlProvider createMyDqApplyListUrl:finish page:page pageSize:pageSize]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     NSError *error = [NSError epOtherErrorWithDescription:@"获取我的益定宝信息失败"];
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

-(void)dqApplyRecord:(void(^)(NSString*detail))success failure:(void(^)(NSError*error))failure {
    
    [self httpGetReq:[EAUrlProvider createDqApplyRecordUrl]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     NSError *error = [NSError epOtherErrorWithDescription:@"获取益定宝投资记录失败"];
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

#pragma mark IEAAssets @implementation

/**
 * 充值
 */
-(void)recharge:(NSString*)moneyOrder
     haveIdCard:(BOOL)haveIdCard
   haveBankCard:(BOOL)haveBankCard
           name:(NSString*)name
         idCard:(NSString*)idCard
       bankCard:(NSString*)bankCard
        success:(void(^)(NSString*jsCallback))success
        failure:(void(^)(NSError *error))failure {
    
    DDLogInfo(@"moneyOrder = %@, haveIdCard = %@, haveBankCard = %@, name = %@, idCard = %@， bankCard = %@",
              moneyOrder, haveIdCard ? @"YES":@"NO", haveBankCard ? @"YES":@"NO", name, idCard, bankCard);
    

    //如果未实名认证
    if (!haveIdCard) {
        if([name length] == 0) {
            NSError *error = [NSError epOtherErrorWithDescription:@"请输入姓名"];
            failure(error);
            return;
        }
        
        if(![EACheckUtil isRealName:name]) {
            NSError *error = [NSError epOtherErrorWithDescription:@"请输入正确的姓名"];
            failure(error);
            return;
        }
        
        NSUInteger len = [name length];
        if(len < 2 || len > 5) {
            NSError *error = [NSError epOtherErrorWithDescription:@"请输入正确的姓名"];
            failure(error);
            return;
        }
        
        if([idCard length] == 0) {
            NSError *error = [NSError epOtherErrorWithDescription:@"请输入身份证号"];
            failure(error);
            return;
        }
        
        if(![EACheckUtil validateIDCardNumber:idCard]) {
            NSError *error = [NSError epOtherErrorWithDescription:@"请输入正确的身份证号"];
            failure(error);
            return;
        }
    }
    
    if(!haveBankCard) {
        if([bankCard length] == 0) {
            NSError *error = [NSError epOtherErrorWithDescription:@"请输入银行卡号"];
            failure(error);
            return;
        }
        
        NSString* isBankCard = [EACheckUtil checkBankNum:bankCard];
        if(![@"true" isEqualToString:isBankCard]){
            NSError *error = [NSError epOtherErrorWithDescription:isBankCard];
            failure(error);
            return;
        }
    }
    
    if ([moneyOrder length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"请输入充值金额"];
        failure(error);
        return;
    }
    
    if (![EACheckUtil isRightMoney:moneyOrder]) {
        NSError *error = [NSError epOtherErrorWithDescription:@"请输入正确的金额(精确到分)"];
        failure(error);
        return;
    }
    
    [self httpPostReq:[EAUrlProvider createRechargeUrl:moneyOrder haveIdCard:haveIdCard?@"true":@"false" haveBankCard:haveBankCard?@"true":@"false" name:[[GTMBase64 encodeBase64String:name] URLEncodedString] idCard:idCard bankCard:bankCard]
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
                      
                      NSError *error = [NSError epOtherErrorWithDescription:@"充值失败"];
                      failure(error);
                      return;
                  }
                  
                  NSError *error;
                  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject
                                                                     options:0
                                                                       error:&error];
                  NSString *jsUrl = [NSString stringWithFormat:@"doRecharge(%@)", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
                  success(jsUrl);
              }
              failure:^(NSError *error) {
                  failure([self commonNetworkFailuerError]);
              }
     ];
}

/*
 * 取现
 */
-(void)withdraw:(NSString*)amount
         payPwd:(NSString*)payPwd
     useBalance:(NSString*)useBalance
        success:(void(^)())success
        failure:(void(^)(NSError *error))failure{
    
    DDLogInfo(@"amount = %@, payPwd = %@, useBalance = %@", amount, payPwd, useBalance);

    if ([amount length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"请输入提现金额"];
        failure(error);
        return;
    }
    
    if (![EACheckUtil isRightMoney:amount]) {
        NSError *error = [NSError epOtherErrorWithDescription:@"请输入正确的金额(精确到分)"];
        failure(error);
        return;
    }
    
    if ([amount doubleValue] < 1) {
        NSError *error = [NSError epOtherErrorWithDescription:@"提现金额不能小于1元"];
        failure(error);
        return;
    }
    
    if ([useBalance length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"获取可用金额失败"];
        failure(error);
        return;
    }
    
    if ([amount doubleValue] > [useBalance doubleValue]) {
        NSError *error = [NSError epOtherErrorWithDescription:@"余额不足"];
        failure(error);
        return;
    }
    
    if ([payPwd length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"请输入交易密码"];
        failure(error);
        return;
    }
    
    [self httpPostReq:[EAUrlProvider withdrawUrl:payPwd amount:amount]
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
                  
                  NotifyModelClient(EAAssetsModelClient, @selector(onWithdraw:), onWithdraw:[amount doubleValue]);
              }
              failure:^(NSError *error) {
                  failure([self commonNetworkFailuerError]);
              }
     ];
}

/*
 * 获取我的交易流水
 */
-(void)myTradeLog:(NSString*)type page:(int)page pageCount:(int)pageCount success:(void(^)(NSString* type, NSString*list))success failure:(void(^)(NSError *error))failure {
    
    DDLogInfo(@"type = %@, page = %d, pageCount=%d", type, page, pageCount);
    
    [self httpGetReq:[EAUrlProvider myTradeLogUrl:type page:page pageCount:pageCount]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     NSError *error = [NSError epOtherErrorWithDescription:@"获取流水信息失败"];
                     failure(error);
                     return;
                 }
                 
                 NSString *str = [responseDic[@"list"] epString];
                 
                 if (str) {
                     success(type, str);
                 } else {
                     failure([self commonNetworkFailuerError]);
                 }
             }
             failure:^(NSError *error) {
                 failure([self commonNetworkFailuerError]);
             }
     ];
}

/*
 * 我的资金统计
 */
-(void)myMoneyStatisics:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure{
    
    DDLogInfo(@"");
    
    [self httpGetReq:[EAUrlProvider createMyMoneyStatisticsUrl]
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
 * 获取我的账号
 */
-(void)myAccount:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure {
    DDLogInfo(@"");
    
    [self httpGetReq:[EAUrlProvider myAccountUrl]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     NSError *error = [NSError epOtherErrorWithDescription:@"获取用户信息失败"];
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

/**
 * 计算预期收益
 */
-(void)inComeCounterList:(NSString*)counterWay
                tzAmount:(NSString*)tzAmount
                yearRate:(NSString*)yearRate
                    tzNo:(NSString*)tzNo
                 success:(void(^)(NSString*detail))success
                 failure:(void(^)(NSError *error))failure {
    DDLogInfo(@"");
    
    if([counterWay length] == 0 || [tzAmount length] == 0 || [yearRate length] == 0 || [tzNo length] == 0) {
        NSError *error = [NSError epOtherErrorWithDescription:@"参数错误"];
        failure(error);
        return;
    }
    
    [self httpGetReq:[EAUrlProvider createIncomeCounterListUrl:counterWay tzAmount:tzAmount yearRate:yearRate tzNo:tzNo]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     NSError *error = [NSError epOtherErrorWithDescription:@"计算收益信息失败"];
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

/**
 * 计算预期收益
 */
-(void)expectedIncome:(NSString*)tzAmount yearRate:(NSString*)yearRate tzNo:(NSString*)days success:(void(^)(NSString*detail))success
              failure:(void(^)(NSError *error))failure {
    DDLogInfo(@"");
    
    if([tzAmount length] == 0 || [tzAmount doubleValue] <= 0) {
        failure(nil);
        return;
    }
    
    if([yearRate length] == 0 || [yearRate doubleValue] <= 0) {
        failure(nil);
        return;
    }
    
    if([days length] == 0 || [days isPureInt] <= 0) {
        failure(nil);
        return;
    }

    [self httpGetReq:[EAUrlProvider createExpectedIncomeUrl:tzAmount yearRate:yearRate days:days]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     NSError *error = [NSError epOtherErrorWithDescription:@"计算收益信息失败"];
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

/**
 * 获取我的合同信息
 */
-(void)myProtocol:(NSString*)applyId success:(void(^)(NSString*detail))success
          failure:(void(^)(NSError *error))failure {
    DDLogInfo(@"");
    
    if([EAStringUtil isBlankIncludeNull:applyId] || ![applyId isPureNumandCharacters]) {
        failure(nil);
        return;
    }
    
    [self httpGetReq:[EAUrlProvider createMyProtocolUrl:applyId]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     NSError *error = [NSError epOtherErrorWithDescription:@"获取合同信息失败"];
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


@end
