//
//  IEAAccount.h
//  mobile
//
//  Created by kevin on 15/11/10.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IEAAccount <NSObject>

@optional

/**
 * 注册
 */
-(void)register:(NSString*)mobile pwd:(NSString*)pwd code:(NSString*)code success:(void(^)())success failure:(void(^)(NSError* error))failure;

/**
 * 实名验证
 */
-(void)verify:(NSString*)name idCard:(NSString*)idCard bankCard:(NSString*)bankCard success:(void(^)())success failure:(void(^)(NSError* error))failure;

/**
 * 修改交易密码短信验证码
 */
-(void)requestChangePayPasswordRandomSms:(NSString*)idCard pwd:(NSString*)pwd havePayPwd:(BOOL)havePayPwd success:(void(^)())success failure:(void(^)(NSError* error))failure;

/**
 * 修改交易密码
 */
-(void)changePayPassword:(NSString*)idCard pwd:(NSString*)pwd code:(NSString*)code havePayPwd:(BOOL)havePayPwd success:(void(^)())success failure:(void(^)(NSError* error))failure;

/**
 * 获取用户信息
 */
-(void)requestUser:(void(^)(NSString*detail))success failure:(void(^)(NSError* error))failure;

/*
 * 获取实名验证状态
 */
-(void)userVerifyState:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure;

/*
 * 通过名字查找银行限额
 */
-(void)bankLimit:(NSString*)bankFullName success:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure;

/*
 * 银行列表
 */
-(void)bankList:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure;

/*
 *
 */
-(void)bankCardBinLimit:(NSString*)bankCard success:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure;

/*
 * 获取我的银行账号
 */
-(void)myBankAccount:(void(^)(NSString*detail))success failure:(void(^)(NSError *error))failure;

/**
 * 是不是新用户
 **/
-(void)memberIsNewbie:(void(^)(NSString*jsCallback))success failure:(void(^)(NSError *error))failure;

@end
