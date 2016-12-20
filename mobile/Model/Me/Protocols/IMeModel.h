//
//  IMeModel.h
//  mobile
//
//  Created by kevin on 15/11/10.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMeModel<NSObject>

@optional

/**
 * 在线客服
 */
-(void)onlineService:(void(^)())success failure:(void(^)(NSError *error))failure;

- (void)getInviteCode:(void(^)(NSString*jsCallback))success failure:(void (^)(NSError *error))failure;

- (void)custom:(void(^)())success failure:(void (^)(NSError *error))failure;

@end
