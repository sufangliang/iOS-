//
//  AppDelegate.h
//  mobile
//
//  Created by ChenLei on 15/9/12.
//  Copyright (c) 2015年 edaga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong) UIViewController *mainViewController;   ///< 主界面UI

- (void)showGuideView;

+ (void) showTipsOnGlobalWindow:(NSString*) tips;

@end

