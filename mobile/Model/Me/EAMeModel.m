//
//  EAMeModel.m
//  mobile
//
//  Created by kevin on 15/11/10.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "EAMeModel.h"
#import "EARongIMModel.h"
#import "EAUrlProvider.h"
#import "NSObjectEx.h"
#import "NSErrorEx.h"

@implementation EAMeModel

/**
 * 在线客服
 */
-(void)onlineService:(void(^)())success failure:(void(^)(NSError *error))failure{
    DDLogInfo(@"onlineService");
    
    [[EARongIMModel sharedInstance] connectIfNeed:^(void){
        success();
    } failure:^(NSError *error){
       DDLogError(@"onlineService error %@", error);
       failure(error);
    }];
}

- (void)custom:(void(^)())success failure:(void (^)(NSError *error))failure {
    DDLogInfo(@"");
    
    [[EARongIMModel sharedInstance] connectIfNeed:^(void){
        success();
    } failure:^(NSError *error){
        failure(error);
    }];
}

- (void)getInviteCode:(void(^)(NSString*jsCallback))success failure:(void (^)(NSError *error))failure {
    DDLogInfo(@"");
    
    [self httpGetReq:[EAUrlProvider createInviteCodeUrl]
          parameters:nil
             success:^(id responseObject) {
                 NSDictionary *responseDic = (NSDictionary *)responseObject;
                 int errorCode = [responseDic[@"error_code"] epInt];
                 if (errorCode != 0) {
                     failure([NSError epOtherErrorWithDescription:@"获取二维码失败"]);
                     return;
                 }
                 NSString *str = [responseDic[@"detail"] epString];
                 NSString *jsStr = [NSString stringWithFormat:@"getInviteCode('%@')", str];
                 success(jsStr);
             }
             failure:^(NSError *error) {
                 failure([self commonNetworkFailuerError]);
             }
     ];
}

@end
