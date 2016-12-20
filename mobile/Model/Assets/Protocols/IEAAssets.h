//
//  IEAAssets.h
//  mobile
//
//  Created by kevin on 15/11/10.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "EABaseModel.h"

@protocol IEAAssets <NSObject>

@optional

/*
 * 获取我的账号资产
 */
-(void)myAccount:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure;

/*
 * 获取我的交易流水
 */
-(void)myTradeLog:(NSString*)type page:(int)page pageCount:(int)pageCount success:(void(^)(NSString* type, NSString*list))success failure:(void(^)(NSError *error))failure;

/*
 * 我的资金统计
 */
-(void)myMoneyStatisics:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure;

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
        failure:(void(^)(NSError *error))failure;

/*
 * 取现
 */
-(void)withdraw:(NSString*)amount
         payPwd:(NSString*)payPwd
     useBalance:(NSString*)useBalance
        success:(void(^)())success
        failure:(void(^)(NSError *error))failure;

/**
 * 计算预期收益
 */
-(void)inComeCounterList:(NSString*)counterWay
                tzAmount:(NSString*)tzAmount
                yearRate:(NSString*)yearRate
                    tzNo:(NSString*)tzNo
                 success:(void(^)(NSString*detail))success
                 failure:(void(^)(NSError *error))failure;

/**
 * 计算预期收益
 */
-(void)expectedIncome:(NSString*)tzAmount yearRate:(NSString*)yearRate tzNo:(NSString*)days success:(void(^)(NSString*detail))success
              failure:(void(^)(NSError *error))failure;

/**
 * 获取我的合同信息
 */
-(void)myProtocol:(NSString*)applyId success:(void(^)(NSString*detail))success
          failure:(void(^)(NSError *error))failure;

@end
