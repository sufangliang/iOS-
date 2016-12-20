//
//  EANavigationHelper.m
//  mobile
//
//  Created by kevin on 15/11/26.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "EANavigationHelper.h"
#import "EABaseWebViewController.h"
#import "EAMainTabViewController.h"
#import "EAViewControllerHelper.h"
#import "EABaseModel.h"

@implementation EANavigationHelper

+ (void)navigationToUrl:(UIViewController*)viewController url:(NSString*)url {
    if(viewController == nil || url == nil) {
        return;
    }
    
    EAPageName pageName = [EABaseModel toPageName:url];
    
    DDLogInfo(@"url = %@, pageName = %@", url, [EABaseModel pageCodeToPageName:pageName]);
    
    EABaseWebViewController *toViewController = [[EABaseWebViewController alloc]initWithHtml:url pageName:pageName  enablePullRefresh:[EABaseModel shouldEnablePullRefresh:url] enablePullRefreshFooter:[EABaseModel shouldEnablePullLoadMore:url]];
    toViewController.hidesBottomBarWhenPushed=YES;
    [viewController.navigationController pushViewController:toViewController animated:YES];
}

+ (void)navigationToTradeLogPage:(UIViewController*)currentController highlightTab:(NSString*)tab {
    if(currentController == nil) {
        return;
    }
    
    NSArray *viewControllers = currentController.navigationController.viewControllers;
    UIViewController *tradeLogViewController = [EAViewControllerHelper findViewController:EAPageTradeLog inViewControllers:viewControllers];
    
    if(tradeLogViewController) {
        [currentController.navigationController popToViewController:tradeLogViewController animated:YES];
        if(tab != nil && [tradeLogViewController isKindOfClass:[EABaseWebViewController class]]) {
            EABaseWebViewController *tempController = (EABaseWebViewController *)tradeLogViewController;
            [tempController postTradeLogPage:tab shouldHighlight:YES];
        }
    } else {
        NSString *url = nil;
        if(tab != nil) {
            url = [NSString stringWithFormat:@"tradelog.html?page_type=%@&highlight_page=%@", tab, tab];
        } else {
             url = [NSString stringWithFormat:@"tradelog.html"];
        }
        
        tradeLogViewController = [[EABaseWebViewController alloc]initWithHtml:url pageName:EAPageTradeLog enablePullRefresh:YES enablePullRefreshFooter:YES];
        tradeLogViewController.hidesBottomBarWhenPushed=YES;
        
        EAMainTabViewController *mainViewController = viewControllers.firstObject;
        
        NSArray * newViewControllers = [NSArray arrayWithObjects:mainViewController, tradeLogViewController, nil];
        [currentController.navigationController setViewControllers:newViewControllers animated:YES];
    }
}


+ (void)navigationToMyYdbPage:(UIViewController*)currentController withApplyAmount:(NSString*)amount {
    if(currentController == nil) {
        return;
    }
    
    NSArray *viewControllers = currentController.navigationController.viewControllers;
    UIViewController *myYdbViewController = [EAViewControllerHelper findViewController:EAPageMyYdb inViewControllers:viewControllers];
    
    if(myYdbViewController) {
        [currentController.navigationController popToViewController:myYdbViewController animated:YES];
        if(amount && [myYdbViewController isKindOfClass:[EABaseWebViewController class]]) {
            EABaseWebViewController *tempController = (EABaseWebViewController *)myYdbViewController;
            [tempController postYdbApply:[amount doubleValue]];
        }
    } else {
        myYdbViewController = [[EABaseWebViewController alloc]initWithHtml:@"my_ydb.html" pageName:EAPageMyYdb enablePullRefresh:YES enablePullRefreshFooter:YES];
        myYdbViewController.hidesBottomBarWhenPushed=YES;
        if(amount) {
            EABaseWebViewController *tempController = (EABaseWebViewController *)myYdbViewController;
            [tempController postYdbApply:[amount doubleValue]];
        }
        
        EAMainTabViewController *mainViewController = viewControllers.firstObject;
        NSArray * newViewControllers = [NSArray arrayWithObjects:mainViewController, myYdbViewController, nil];
        [currentController.navigationController setViewControllers:newViewControllers animated:YES];
    }
}

+ (void)navigationToAssets:(UIViewController*)currentController {
    if(currentController == nil) {
        return;
    }
    
    NSArray *viewControllers = currentController.navigationController.viewControllers;
    UIViewController *assetsViewController = [EAViewControllerHelper findViewController:EAPageAssets inViewControllers:viewControllers];
    
    if(assetsViewController) {
        [currentController.navigationController popToViewController:assetsViewController animated:YES];
    } else {
        assetsViewController = [[EABaseWebViewController alloc]initWithHtml:@"assets.html" pageName:EAPageAssets enablePullRefresh:YES];
        
        EAMainTabViewController *mainViewController = viewControllers.firstObject;
        
        NSArray * newViewControllers = [NSArray arrayWithObjects:mainViewController, assetsViewController, nil];
        [currentController.navigationController setViewControllers:newViewControllers animated:YES];
    }
}

+ (void)navigationToMyWallet:(UIViewController*)currentController withApplyAmount:(NSString*)amount {
    if(currentController == nil) {
        return;
    }
    
    NSArray *viewControllers = currentController.navigationController.viewControllers;
    UIViewController *myWalletViewController = [EAViewControllerHelper findViewController:EAPageMyWallet inViewControllers:viewControllers];
    
    
    if(myWalletViewController) {
        [currentController.navigationController popToViewController:myWalletViewController animated:YES];
        if(amount && [myWalletViewController isKindOfClass:[EABaseWebViewController class]]) {
            EABaseWebViewController *tempController = (EABaseWebViewController *)myWalletViewController;
            [tempController postWalletApply:[amount doubleValue]];
        }
    } else {
        myWalletViewController = [[EABaseWebViewController alloc]initWithHtml:@"my_wallet.html" pageName:EAPageMyWallet enablePullRefresh:YES];
        myWalletViewController.hidesBottomBarWhenPushed=YES;
        
        EABaseWebViewController *tempController = (EABaseWebViewController *)myWalletViewController;
        [tempController postWalletApply:[amount doubleValue]];
        
        EAMainTabViewController *mainViewController = viewControllers.firstObject;
        
        NSArray * newViewControllers = [NSArray arrayWithObjects:mainViewController, myWalletViewController, nil];
        [currentController.navigationController setViewControllers:newViewControllers animated:YES];
    }

}

@end
