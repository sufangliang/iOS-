//
//  MainTabViewController.m
//  mobile
//
//  Created by kevin on 15/11/9.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "EAMainTabViewController.h"
#import "UIImage+NSUIImageEx.h"
#import "EABaseWebViewController.h"

@interface EAMainTabViewController ()

@end

@implementation EAMainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建底部三个tab
    [self createMainTab];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  创建底部的三个tab
 */
- (void)createMainTab{
    // 理财板块
    EABaseWebViewController *moneyVC = [[EABaseWebViewController alloc] initWithHtml:@"index.html" pageName:EAPageFinance enablePullRefresh:NO];
    UINavigationController *firNaviVC = [[UINavigationController alloc] initWithRootViewController:moneyVC];
    UIImage *tabImage = [UIImage imageNamed:@"tabBar_money"];
    UIImage *tabImageSel = [UIImage imageNamed:@"tabBar_money_s"];
    tabImage = [tabImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabImageSel = [tabImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    firNaviVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"理财"
                                                         image:tabImage
                                                 selectedImage:tabImageSel];
    [self addNaviBarCommonProperty:firNaviVC]; 

    // 资产模块
    EABaseWebViewController *assetsVC = [[EABaseWebViewController alloc] initWithHtml:@"assets.html" pageName: EAPageAssets enablePullRefresh:YES];
    UINavigationController *secNaviVC = [[UINavigationController alloc] initWithRootViewController:assetsVC];
    tabImage = [UIImage imageNamed:@"tabBar_assets"];
    tabImageSel = [UIImage imageNamed:@"tabBar_assets_s"];
    tabImage = [tabImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabImageSel = [tabImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    secNaviVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"资产"
                                                         image:tabImage
                                                 selectedImage:tabImageSel];
    [self addNaviBarCommonProperty:secNaviVC];
    
    // 我 模块
    EABaseWebViewController *profileVC = [[EABaseWebViewController alloc] initWithHtml:@"me.html" pageName:EAPageMe enablePullRefresh:YES];
    UINavigationController *thrNaviVC = [[UINavigationController alloc] initWithRootViewController:profileVC];
    tabImage = [UIImage imageNamed:@"tabBar_me"];
    tabImageSel = [UIImage imageNamed:@"tabBar_me_s"];
    tabImage = [tabImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabImageSel = [tabImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    thrNaviVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我"
                                                         image:tabImage
                                                 selectedImage:tabImageSel];
    [self addNaviBarCommonProperty:thrNaviVC];
    
    self.tabBar.translucent = NO;
    self.tabBar.tintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
    self.viewControllers = @[ firNaviVC, secNaviVC, thrNaviVC ];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:239.0/255.0 green:107.0/255.0 blue:47.0/255.0 alpha:1] }
                                             forState:UIControlStateSelected];
}

- (void)addNaviBarCommonProperty:(UINavigationController *)naviVC
{
    
    naviVC.navigationBar.tintColor = [UIColor whiteColor];
    naviVC.navigationBar.translucent = NO;
    
    [naviVC.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:252.0/255.0 green:117.0/255.0 blue:0.0/255.0 alpha:1] size:CGSizeMake(1, 1)]
                               forBarMetrics:UIBarMetricsDefault];
    [naviVC.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(320, 3)]];
    
    // titile
    NSDictionary* titleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                     [UIFont boldSystemFontOfSize:18], NSFontAttributeName,
                                     nil];
    [naviVC.navigationBar setTitleTextAttributes:titleAttributes];
}

@end
