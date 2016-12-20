//
//  RongIMModel.m
//  mobile
//
//  Created by kevin on 15/10/28.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "EARongIMModel.h"
#import <AFNetworking/AFNetworking.h>
#import "EAUrlProvider.h"
#import "NSErrorEx.h"
#import "OpenUDID.h"
#import "NSObjectEx.h"
#import "EAConfiguration.h"
#import "EAStringUtil.h"

@interface EARongIMModel ()
{
    BOOL _hasConnected;
}

@end

@implementation EARongIMModel

+ (instancetype)sharedInstance
{
    static EARongIMModel *instance = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        instance = [[EARongIMModel alloc] init];
    });
    
    return instance;
}

- (void) connectIfNeed:(connectSuc)success failure:(connectFail)failure
{
    if(_hasConnected)
    {
        success();
    } else {
        // 获取token
        [self getToken:^(NSString* token){
            // 链接
            [self connect:token success:^(NSString* userId){
                _hasConnected = YES;
                success();
            } failure:^(NSError *error) {
                failure(error);
            }];
        } failure:^(NSError * error){
            failure(error);
        }];
    }
}

- (void)getToken:(void(^)(NSString* token))success failure:(void(^)(NSError* error))failure
{
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    httpManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    
    NSString *userIdentity = [[EAConfiguration sharedInstance]getMobile];
    if([EAStringUtil isBlank:userIdentity]) {
        userIdentity = [OpenUDID value];
    }
    
    @try {
        [httpManager GET:[EAUrlProvider createRongIMToken:userIdentity]
              parameters:nil
                 success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                     
                     NSDictionary *responseDic = (NSDictionary *)responseObject;
                     int code = [responseDic[@"code"] epInt];
                     if (code != 200) {
                         NSError *error = [NSError epOtherErrorWithDescription:@"获取失败"];
                         failure(error);
                         return;
                     }
                     
                     NSString *token = [responseDic[@"token"] epString];
               //      NSString *userId = [responseDic[@"userId"] epString];
                     
                     success(token);
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

- (void)connect:(NSString*)token success:(void(^)(NSString* token))success failure:(void (^)(NSError *error))failure;
{
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        
        success(userId);
    } error:^(RCConnectErrorCode status) {
        DDLogError(@"login error status: %ld.", (long)status);
        failure([NSError epOtherErrorWithDescription:[NSString stringWithFormat:@"RCConnectErrorCode code %ld", (long)status]]);
    } tokenIncorrect:^{
        DDLogError(@"token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致");
        failure([NSError epOtherErrorWithDescription:@"token 无效 ，请确保生成token 使用的appkey 和初始化时的appkey 一致"]);
    }];
}

/**
 *此方法中要提供给融云用户的信息，建议缓存到本地，然后改方法每次从您的缓存返回
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    RCUserInfo *user = [[RCUserInfo alloc]init];
    user.userId = userId;
    if([@"KEFU1439102885169" isEqualToString:userId]) {
        // 客服user
        user.name = @"客服";
    } else {
        // 用户user
        user.name = [[EAConfiguration sharedInstance]getMobile];
    }

    user.portraitUri = nil;
    
    return completion(user);
}

@end
