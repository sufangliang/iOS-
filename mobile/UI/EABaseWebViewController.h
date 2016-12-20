//
//  EABaseViewController.h
//  mobile
//
//  Created by kevin on 15/11/9.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EABaseModel.h"


@interface EABaseWebViewController : UIViewController

@property(readonly) EAPageName pageName;

- (instancetype)initWithHtml:(NSString *)html;

- (instancetype)initWithUrl:(NSString *)url enablePullRefresh:(BOOL)enable;

- (instancetype)initWithUrl:(NSString *)url pageName:(EAPageName)pageName enablePullRefresh:(BOOL)enable;

- (instancetype)initWithUrl:(NSString *)url pageName:(EAPageName)pageName enablePullRefresh:(BOOL)enable enablePullRefreshFooter:(BOOL)enableFooter;

- (instancetype)initWithUrl:(NSString *)url;

- (instancetype)initWithHtml:(NSString *)html enablePullRefresh:(BOOL)enable;

- (instancetype)initWithHtml:(NSString *)html pageName:(EAPageName)pageName enablePullRefresh:(BOOL)enable;

- (instancetype)initWithHtml:(NSString *)html pageName:(EAPageName)pageName enablePullRefresh:(BOOL)enable enablePullRefreshFooter:(BOOL)enableFooter;

- (void)postWalletApply:(double)applyAmount;

- (void)postYdbApply:(double)applyAmount;

- (void)postWalletRedeem:(double)redeemAmount;

- (void)postTradeLogPage:(NSString*)pageType shouldHighlight:(BOOL)enable;

- (BOOL)isPage:(EAPageName)pageName;

- (void)refresh;

- (void)loadMore;

- (void)execJs:(NSString*)js;

- (void)openLocalWebOutside:(NSString*)html enablePullrefresh:(BOOL)enable;

- (void)openWebOutside:(NSString*)url enablePullrefresh:(BOOL)enable;

- (void)showToast:(NSString*)toast;

- (void)enablePullRefreshHeader:(BOOL)enable;

- (void)onPulldownRefresh;

- (void)onPullUpRefresh;

- (void)onJsCallback:(NSString*)cmd parameters:(NSMutableArray*)parameters;

- (void)backToHome;

@end
