//
//  RongIMModel.h
//  mobile
//
//  Created by kevin on 15/10/28.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>

typedef void (^connectSuc)();
typedef void (^connectFail)(NSError *error);

@interface EARongIMModel : NSObject<RCIMUserInfoDataSource>

+ (instancetype)sharedInstance;

- (void) connectIfNeed:(connectSuc)success failure:(connectFail)failure;


@end
