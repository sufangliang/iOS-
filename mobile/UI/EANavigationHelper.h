//
//  EANavigationHelper.h
//  mobile
//
//  Created by kevin on 15/11/26.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EANavigationHelper : NSObject

+ (void)navigationToUrl:(UIViewController*)viewController url:(NSString*)url;

+ (void)navigationToTradeLogPage:(UIViewController*)currentController highlightTab:(NSString*)tab;

+ (void)navigationToMyYdbPage:(UIViewController*)currentController withApplyAmount:(NSString*)amount;

+ (void)navigationToAssets:(UIViewController*)currentController;

+ (void)navigationToMyWallet:(UIViewController*)currentController withApplyAmount:(NSString*)amount;

@end
