//
//  EAAccountModelClient.h
//  mobile
//
//  Created by kevin on 15/11/10.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EAAccountModelClient <NSObject>

@optional

-(void)onLogin;

-(void)onLogout;

- (void)onVerify;

@end
