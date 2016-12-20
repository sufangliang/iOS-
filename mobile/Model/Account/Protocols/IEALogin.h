//
//  IEALogin.h
//  mobile
//
//  Created by kevin on 15/11/20.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IEALogin<NSObject>

@optional

- (void)login:(NSString*)mobile pwd:(NSString*)pwd success:(void(^)())success failure:(void(^)(NSError* error))failure;

- (void)logout:(void(^)())success failure:(void(^)(NSError* error))failure;

- (void)changeLoginPassword:(NSString*)mobile pwd:(NSString*)pwd code:(NSString*)code success:(void(^)())success failure:(void(^)(NSError* error))failure;

- (void)requestChangeLoginPasswordRandomSms:(NSString*)mobile pwd:(NSString*)pwd success:(void(^)())success failure:(void(^)(NSError* error))failure;

- (void)refreshLoginState:(void(^)(NSString*jsCallback))success failure:(void (^)(NSError *error))failure;

- (BOOL)isLogin;

- (void)getLoginMobile:(void(^)(NSString*jsCallback))success failure:(void (^)(NSError *error))failure;

@end
