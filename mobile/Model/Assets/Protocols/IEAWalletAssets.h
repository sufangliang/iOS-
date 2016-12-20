//
//  IEAWalletAssets.h
//  mobile
//
//  Created by kevin on 15/11/20.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IEAWalletAssets<NSObject>

@optional

/*
 * 益钱包
 */
-(void)wallet:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure;

/*
 * 获取我的益钱包
 */
-(void)myWalletDetail:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure;

/*
 * 关于益钱包
 */
-(void)aboutWallet:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure;

/*
 * 益钱包详情
 */
-(void)walletDetail:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure;

/**
 * 益钱包最大赎回金额
 */
-(void)myWalletMaxRedeem:(void(^)(NSString*detail))success
                 failure:(void(^)(NSError *error))failure;

/*
 * 益钱包赎回
 */
-(void)walletRedeem:(NSString*)amount
             pawPwd:(NSString*)payPwd
    maxRedeemAmount:(NSString*)maxRedeemAmount
            success:(void(^)())success
            failure:(void(^)(NSError *error))failure;

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
           failure:(void(^)(NSError *error))failure;

/**
 * 获取益钱包转入记录
 */
-(void)requestWalletApplyList:(void(^)())success
                      failure:(void(^)(NSError *error))failure;

/**
 * 获取益钱包排行榜(前10)
 */
-(void)requestWalletApplyBoard:(void(^)())success
                       failure:(void(^)(NSError *error))failure;

@end
