//
//  IEAYdbAssets.h
//  mobile
//
//  Created by kevin on 15/11/20.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IEAYdbAssets <NSObject>

@optional

/*
 * 益定宝
 */
-(void)ydb:(NSString*)type success:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure;

/*
 * 我的益定宝列表
 */
-(void)myYdbList:(NSString*)applyStatus success:(void(^)(NSString*list))success failure:(void(^)(NSError *error))failure;

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
        failure:(void(^)(NSError *error))failure;

/**
 * 获取益定宝信息（新）
 */
-(void)getDqByFlag:(NSString*)flag success:(void(^)(NSString*detail))success failure:(void(^)(NSError*error))failure;

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
       failure:(void(^)(NSError *error))failure;

-(void)myDqApplyList:(NSString*)finish page:(int)page pageSize:(int)pageSize success:(void(^)(NSString*detail))success failure:(void(^)(NSError*error))failure;

-(void)dqApplyRecord:(void(^)(NSString*detail))success failure:(void(^)(NSError*error))failure;

@end
