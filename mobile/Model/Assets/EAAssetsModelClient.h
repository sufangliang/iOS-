//
//  EAAssetsModelClient.h
//  mobile
//
//  Created by kevin on 15/11/12.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EAAssetsModelClient <NSObject>

@optional

- (BOOL)onRechargeSuccess;

- (void)onWalletApply:(double)applyAmount;

- (void)onYdbApply:(double)applyAmount;

- (void)onWalletRedeem:(double)redeemAmount;

- (void)onWithdraw:(double)withdrawAmount;

@end
