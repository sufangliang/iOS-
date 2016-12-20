//
//  EAConfiguration.h
//  mobile
//
//  Created by ChenLei on 15/9/15.
//  Copyright (c) 2015年 edaga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EAConfiguration : NSObject

+ (instancetype)sharedInstance;

- (void)clearAll;

- (NSString *)getPaySignature:(NSString *)paypwd;

- (NSString *)getSignature;

- (NSString *)getMobile;

- (void)setSignature:(NSString *)mobile password:(NSString *)pwd;

- (void)setLoginState:(BOOL)loginState;

- (BOOL)loginState;

@end
