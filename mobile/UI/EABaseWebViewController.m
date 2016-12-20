//
//  EABaseViewController.m
//  mobile
//
//  Created by kevin on 15/11/9.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "EABaseWebViewController.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "EAStringUtil.h"
#import "EPInfoAlert.h"
#import "NSErrorEx.h"
#import "EAAssetsModel.h"
#import "ModelManager.h"
#import "EAAccountModel.h"
#import "EAUser.h"
#import "NSStringEx.h"
#import "GTMBase64.h"
#import "EABankAccount.h"
#import "EAConfiguration.h"
#import "AppDelegate.h"
#import "EAMainTabViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "EAAccountModelClient.h"
#import "EAAssetsModelClient.h"
#import "EAUrlProvider.h"
#import "EAViewControllerHelper.h"
#import "EAMeModel.h"
#import "NSObjectEx.h"
#import "MobClick.h"
#import "EAUMengStatistics.h"
#import "EANavigationHelper.h"

#define DEFAULT_WAITING_PROGRESS_DELAY 1.0

@interface EABaseWebViewController () <EAAccountModelClient, EAAssetsModelClient> {
    NSString *_startHtml;
    NSString *_startUrl;
    NSTimer *_timer;
    BOOL _enablePullRefreshHeader;
    BOOL _enablePullRefreshFooter;
    MJRefreshNormalHeader *_header;
    MJRefreshBackNormalFooter *_footer;
    double _walletApplyAmount;
    double _ydbApplyAmount;
    double _walletRedeemAmount;
    NSString *_tradeLogPageType;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation EABaseWebViewController


#pragma mark init method

- (instancetype)initWithUrl:(NSString *)url {
    self = [self initWithUrl:url enablePullRefresh:YES];
    
    return self;
}

- (instancetype)initWithUrl:(NSString *)url enablePullRefresh:(BOOL)enable{
    self = [self initWithUrl:url pageName:EAPageCommon enablePullRefresh:enable];
    return self;
}

- (instancetype)initWithUrl:(NSString *)url pageName:(EAPageName)pageName enablePullRefresh:(BOOL)enable {
    self = [self initWithUrl:url pageName:pageName enablePullRefresh:enable enablePullRefreshFooter:NO];
    
    return self;
}

- (instancetype)initWithUrl:(NSString *)url pageName:(EAPageName)pageName enablePullRefresh:(BOOL)enable enablePullRefreshFooter:(BOOL)enableFooter {
    self = [super init];
    if (self) {
        _startUrl = url;
        _enablePullRefreshHeader = enable;
        _enablePullRefreshFooter = enableFooter;
        _pageName = pageName;
    }
    
    return self;
}

- (instancetype)initWithHtml:(NSString *)html {
    self = [self initWithUrl:html enablePullRefresh:YES];
    return self;
}

- (instancetype)initWithHtml:(NSString *)html enablePullRefresh:(BOOL)enable{
    self = [self initWithHtml:html pageName:EAPageCommon enablePullRefresh:enable];
    return self;
}

- (instancetype)initWithHtml:(NSString *)html pageName:(EAPageName)pageName enablePullRefresh:(BOOL)enable {
    self = [self initWithHtml:html pageName:pageName enablePullRefresh:enable enablePullRefreshFooter:NO];
    return self;
}

- (instancetype)initWithHtml:(NSString *)html pageName:(EAPageName)pageName enablePullRefresh:(BOOL)enable enablePullRefreshFooter:(BOOL)enableFooter {
    self = [super init];
    if (self) {
        _startHtml = html;
        _enablePullRefreshHeader = enable;
        _enablePullRefreshFooter = enableFooter;
        _pageName = pageName;
    }
    
    return self;
}

#pragma mark lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    DDLogInfo(@"pageName = %@", [EABaseModel pageCodeToPageName:self.pageName]);
    
    AddModelClient(EAAccountModelClient, self);
    AddModelClient(EAAssetsModelClient, self);
    
    [self updatePullRefreshHeader];
    [self updatePullRefreshFooter];
    
    __weak EABaseWebViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf refresh];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DDLogInfo(@"pageName = %@", [EABaseModel pageCodeToPageName:self.pageName]);
    
    [MobClick beginLogPageView:[EABaseModel pageCodeToPageName:self.pageName]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    DDLogInfo(@"pageName = %@", [EABaseModel pageCodeToPageName:self.pageName]);
    if(_pageName == EAPageMyWallet) {
        if(_walletApplyAmount > 0) {
            [self execJs:[NSString stringWithFormat:@"walletApply(%@)", [NSString stringWithFormat:@"%.2lf", _walletApplyAmount]]];
            _walletApplyAmount = 0;
        }
    } else if (_pageName == EAPageMyYdb){
        if(_ydbApplyAmount > 0) {
            [self execJs:[NSString stringWithFormat:@"ydbApply(%@)", [NSString stringWithFormat:@"%.2lf", _ydbApplyAmount]]];
            _ydbApplyAmount = 0;
        }
    } else if (_pageName == EAPageTradeLog) {
        if(_tradeLogPageType) {
            [self execJs:[NSString stringWithFormat:@"setCurrentPage('%@')", _tradeLogPageType]];
        }
        _tradeLogPageType = nil;
    } else if(_pageName == EAPageAssets) {
        if(_walletRedeemAmount) {
            [self execJs:[NSString stringWithFormat:@"onWalletRedeemAmount('%@')", [NSString stringWithFormat:@"%.2lf", _walletRedeemAmount]]];
            _walletRedeemAmount=0;
        }
    }
    
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    DDLogInfo(@"pageName = %@", [EABaseModel pageCodeToPageName:self.pageName]);
    
    [MobClick endLogPageView:[EABaseModel pageCodeToPageName:self.pageName]];
}

- (void)dealloc {
    DDLogInfo(@"pageName = %@", [EABaseModel pageCodeToPageName:self.pageName]);
    RemoveModelClientAll(self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIWebViewDelegate
// 开始发送请求的时候就开始调用
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
   
     NSString *requestString = [[request URL] absoluteString];
     NSLog(@"requestString = %@", requestString);
    
    if([requestString containsStringEx:@"recharge_back.html"] && ![requestString containsStringEx:@"_random="]) {
        NSString *newUrl = nil;
        
        NSURL *originalUrl = [NSURL URLWithString:requestString];
        NSString *query = [originalUrl query];
        if(query == nil || [query length] == 0) {
            newUrl = [requestString stringByAppendingFormat:@"?_random=%lld", [EAUrlProvider getTimestamp]];
        } else {
           newUrl = [requestString stringByAppendingFormat:@"&_random=%lld", [EAUrlProvider getTimestamp]];
        }

        DDLogInfo(@"newUrl = %@", newUrl);
        __weak EABaseWebViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:newUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
            [weakSelf.webView loadRequest:request];
        });
        return NO;
    }
// js2native:@:gotoLocalWebPage:@:about_newbie.html?flag=newbie:@:false
    if ([requestString hasPrefix:@"js2native"]) {
        NSString * decodeUrl = [EAStringUtil decodeFromPercentEscapeString:requestString];
         NSArray *dataArray = [decodeUrl componentsSeparatedByString:@":@:"];
         if ([dataArray count] > 1) {
             NSString *cmd = dataArray[1];
             // cmd == gotoLocalWebPage
             NSMutableArray *paramArray = nil;
             if ([dataArray count] > 2) {
                 paramArray = [[NSMutableArray alloc] init];
                 for (int i = 2; i < [dataArray count]; ++i) {
                     [paramArray addObject:[dataArray objectAtIndex:i]];
                 }
             }
             NSLog(@"cmd===========%@", cmd);
             // paramArray = [about_newbie.html?flag=newbie, false]
             __weak EABaseWebViewController *weakSelf = self;
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf onJsCallback:cmd parameters:paramArray];
             });
         }
        
         return NO;
     }
     else {
         return YES;
     }
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    DDLogInfo(@"pageName = %@", [EABaseModel pageCodeToPageName:self.pageName]);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    DDLogInfo(@"pageName = %@", [EABaseModel pageCodeToPageName:self.pageName]);
    [self.webView.scrollView.mj_header endRefreshing];
    [self.webView.scrollView.mj_footer endRefreshing];
    [self hideWaitingProgress];
    
    self.navigationItem.title= [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark MJRefresh

-(MJRefreshNormalHeader*)createMJRefreshHeader{
    __weak EABaseWebViewController *weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf onPulldownRefresh];
    }];
    header.automaticallyChangeAlpha = YES;
    return header;
}

-(MJRefreshBackNormalFooter*)createMJRefreshFooter{
    __weak EABaseWebViewController *weakSelf = self;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf onPullUpRefresh];
    }];
    return footer;
}

- (void)updatePullRefreshHeader{
    if(_enablePullRefreshHeader) {
        if(!_header) {
            _header = [self createMJRefreshHeader];
        }
        self.webView.scrollView.mj_header = _header;
    } else {
        if(_header) {
            [_header removeFromSuperview];
            _header = nil;
        }
    }
}

-(void)updatePullRefreshFooter {
    if(_enablePullRefreshFooter) {
        if(!_footer) {
            _footer = [self createMJRefreshFooter];
        }
        self.webView.scrollView.mj_footer = _footer;
     //   self.webView.scrollView.mj_footer.hidden = YES;
    } else {
        if(_footer) {
            _footer.hidden = YES;
        }
    }
}

#pragma mark waiting progress

- (void)handleShowWaitingNotif:(NSNotification *)notification
{
    NSNumber *delay = [notification object];
    if(delay){
        [self showWaitingProgress:[delay longValue]];
    } else {
        [self showWaitingProgress];
    }
}

- (void)handleHideWaitingNotif:(NSNotification *)notification
{
    [self hideWaitingProgress];
}

- (void)showWaitingProgress:(long)delay
{
    if(delay > 0) {
        [self cancelShowWaitingTimer];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(showWaitingProgress) userInfo:nil repeats:NO];
    } else {
        [self showWaitingProgress];
    }
}

- (void)cancelShowWaitingTimer
{
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)showWaitingProgress
{
    MBProgressHUD *mbProgressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbProgressHUD.dimBackground = YES;
}

- (void)hideWaitingProgress
{
    [self cancelShowWaitingTimer];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark common method

- (void)postWalletApply:(double)applyAmount {
    _walletApplyAmount = applyAmount;
}

- (void)postYdbApply:(double)applyAmount {
    _ydbApplyAmount = applyAmount;
}

- (void)postWalletRedeem:(double)redeemAmount {
    _walletRedeemAmount = redeemAmount;
}

- (void)postTradeLogPage:(NSString*)pageType shouldHighlight:(BOOL)enable {
    _tradeLogPageType = pageType;
}

- (BOOL)isPage:(EAPageName)pageName {
    return _pageName == pageName ? YES : NO;
}

- (void)enablePullRefreshHeader:(BOOL)enable{
    _enablePullRefreshHeader = enable;
    [self updatePullRefreshHeader];
}

- (void)enablePullRefreshFooter:(BOOL)enable{
    _enablePullRefreshFooter = enable;
    [self updatePullRefreshFooter];
}

#pragma mark - 执行 js 的代码
- (void)execJs:(NSString*)js{
    NSLog(@"+++++++++++++++++++%@", js);
    __weak EABaseWebViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.webView stringByEvaluatingJavaScriptFromString:js];
    });
}

- (void)openLocalWebOutside:(NSString*)html enablePullrefresh:(BOOL)enable{
    __weak EABaseWebViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        EABaseWebViewController *nextVC = [[EABaseWebViewController alloc] initWithHtml:html enablePullRefresh:enable];
        nextVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:nextVC animated:YES];
    });
}

- (void)openWebOutside:(NSString*)url enablePullrefresh:(BOOL)enable{
    __weak EABaseWebViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        EABaseWebViewController *nextVC = [[EABaseWebViewController alloc] initWithUrl:url enablePullRefresh:enable];
        nextVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:nextVC animated:YES];
    });
}

- (void)showToast:(NSString*)toast{
    if(!toast) {
        return;
    }
    
    __weak EABaseWebViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [EPInfoAlert showInfo:toast inView:weakSelf.view];
    });
}


#pragma mark callback

- (void)onPulldownRefresh{
    [self refresh];
}

- (void)onPullUpRefresh {
    [self loadMore];
}


- (void)onJsCallback:(NSString*)cmd parameters:(NSMutableArray*)parameters{
    DDLogInfo(@"cmd = %@", cmd);
    if([@"gotoLocalWebPage" isEqualToString:cmd]) {
        [self handleGotoLocalPage:parameters];
    } else if ([@"getUser" isEqualToString:cmd]) {
        [self showWaitingProgress:1.0];
        EAAccountModel *model = [ModelManager getModel:[EAAccountModel class]];
        [model requestUser:^(NSString *detail) {
            [self hideWaitingProgress];
            EAUser *user = [[EAUser alloc] init];
            [user parseJsonString:detail];
            user.name = [user.name base64DecodeString];
            
            NSString *jsStr = [NSString stringWithFormat:@"getUser('%@')", [user jsonString]];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"getMyAccount" isEqualToString:cmd]){
        [self showWaitingProgress:1.0];
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model myAccount:^(NSString *detail) {
            [self hideWaitingProgress];
            NSString *jsStr = [NSString stringWithFormat:@"getMyAccount('%@')", detail];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    }  else if ([@"getMyBankAccount" isEqualToString:cmd]) {
        [self showWaitingProgress:1.0];
        EAAccountModel *model = [ModelManager getModel:[EAAccountModel class]];
        [model myBankAccount:^(NSString *detail) {
            [self hideWaitingProgress];
            EABankAccount* bankAccount = [[EABankAccount alloc] init];
            [bankAccount parseJsonString:detail];
            bankAccount.bankFullNAME = [bankAccount.bankFullNAME base64DecodeString];
            NSString *jsStr = [NSString stringWithFormat:@"getMyBankAccount('%@')", [bankAccount jsonString]];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"getBankList" isEqualToString:cmd]) {
        [self showWaitingProgress:1.0];
        EAAccountModel *model = [ModelManager getModel:[EAAccountModel class]];
        [model bankList:^(NSString *detail) {
            [self hideWaitingProgress];
             NSString *jsStr = [NSString stringWithFormat:@"getBankList('%@')", detail];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"getWallet" isEqualToString:cmd]) {
        [self showWaitingProgress:1.0];
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model wallet:^(NSString *detail) {
            [self hideWaitingProgress];
            NSString *jsStr = [NSString stringWithFormat:@"getWallet('%@')", detail];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"getAboutWallet" isEqualToString:cmd]) {
        [self showWaitingProgress:1.0];
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model aboutWallet:^(NSString *detail) {
            [self hideWaitingProgress];
             NSString *jsStr = [NSString stringWithFormat:@"getAboutWallet('%@')", detail];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"getMyWallet" isEqualToString:cmd]) {
        [self showWaitingProgress:1.0];
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model myWalletDetail:^(NSString *detail) {
            [self hideWaitingProgress];
            NSString *jsStr = [NSString stringWithFormat:@"getMyWallet('%@')", detail];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"getMyTradeLog" isEqualToString:cmd]) {
        [self showWaitingProgress:1.0];
        if ([parameters count] != 3) {
             [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        NSString *type = parameters[0];
        NSString *page = parameters[1];
        NSString *pageCount = parameters[2];
        
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model myTradeLog:type page:[page epInt] pageCount:[pageCount epInt] success:^(NSString *type, NSString *list) {
            [self hideWaitingProgress];
            NSString *jsStr = nil;
            
            if ([type isEqualToString:@"apply"]) {
                jsStr = [NSString stringWithFormat:@"getMyTradeLogApply('%@')", list];
            } else if ([type isEqualToString:@"11"]) {
                jsStr = [NSString stringWithFormat:@"getMyTradeLogRedeem('%@')", list];
            } else if ([type isEqualToString:@"1"]) {
                jsStr = [NSString stringWithFormat:@"getMyTradeLogRecharge('%@')", list];
            } else if ([type isEqualToString:@"2"]) {
                jsStr = [NSString stringWithFormat:@"getMyTradeLogWithdraw('%@')", list];
            }
            
            if (jsStr) {
                [self execJs:jsStr];
            } else {
                [self showToast:[[NSError epOtherErrorWithDescription:@"无法连接到服务器，请检查您的网络后重试"] localizedDescription]];
            }
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"gotoLoginPage" isEqualToString:cmd]) {
        NSString *signature = [[EAConfiguration sharedInstance] getSignature];
        if ([signature length] == 0) {
            [EANavigationHelper navigationToUrl:self url:@"login.html"];
        }
    } else if ([@"gotoWebUrl" isEqualToString:cmd]) {
        if ([parameters count] == 0) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        NSString *url = parameters[0];
        
        EABaseWebViewController *viewController = [[EABaseWebViewController alloc]initWithUrl:url pageName:EAPageCommon enablePullRefresh:YES];
        viewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }  else if ([@"getRandomSms" isEqualToString:cmd]) {
        if ([parameters count] != 2) {
             [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        NSString *mobile = parameters[0];
        NSString *pwd = parameters[1];
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model randomSms:mobile pwd:pwd success:^(NSString *detail) {
            [self hideWaitingProgress];
            [self execJs:@"getMobileCheckCode()"];
            [self showToast:@"短信已发送，请注意查收"];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"register" isEqualToString:cmd]) {
        if ([parameters count] != 3) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        
        NSString *mobile = parameters[0];
        NSString *pwd = parameters[1];
        NSString *code = parameters[2];
        
        EAAccountModel *model = [ModelManager getModel:[EAAccountModel class]];
        [model register:mobile pwd:pwd code:code success:^{
            [self hideWaitingProgress];
            
           // 注册成功，回退到倒数第一个不是登陆的界面
             __weak EABaseWebViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *viewControllers = weakSelf.navigationController.viewControllers;
                EABaseWebViewController *lastValidViewController = nil;
                NSEnumerator *enumerator = [viewControllers reverseObjectEnumerator];
                id obj = nil;
                while(obj = [enumerator nextObject]){
                    if([obj isKindOfClass:[EABaseWebViewController class]]) {
                        EABaseWebViewController *temp = obj;
                        if([temp isPage:EAPageRegister]) {
                            continue;
                        } else if ([temp isPage:EAPageLogin]) {
                            continue;
                        } else {
                            lastValidViewController = obj;
                            break;
                        }
                    }
                }
                
                if(lastValidViewController) {
                    [weakSelf.navigationController popToViewController:lastValidViewController animated:YES];
                } else {
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
                
                [AppDelegate showTipsOnGlobalWindow:@"注册成功"];
            });
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
             [self showToast:[error localizedDescription]];
        }];
    } else if ([@"walletApply" isEqualToString:cmd]) {
        if ([parameters count] != 7) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        
        NSString *amount = parameters[0];
        NSString *payPwd = parameters[1];
        NSString *userBalance = parameters[2];
        NSString *havePayPwd = parameters[3];
        NSString *cjResultId = parameters[4];
        NSString *minNum = parameters[5];
        NSString *isRefreshEvent = parameters[6];
        
        BOOL havePayPwdBool = [@"true" isEqualToString:havePayPwd] ? YES : NO;
        BOOL isRefreshEventBool = [@"true" isEqualToString:isRefreshEvent] ? YES : NO;
        
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model walletApply:amount payPwd:payPwd useBalance:userBalance havePayPwd:havePayPwdBool cjResultId:cjResultId minNum:minNum isRefreshEvent:isRefreshEventBool inadequateJs:^(NSString *jsCallback) {
            [self hideWaitingProgress];
            [self execJs:jsCallback];
        } success:^{
            [self hideWaitingProgress];
            
            // 益钱包投资成功，跳转到我的益钱包
             __weak EABaseWebViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [EANavigationHelper navigationToMyWallet:weakSelf withApplyAmount:amount];
                [AppDelegate showTipsOnGlobalWindow:@"投资成功"];
            });
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
             [self showToast:[error localizedDescription]];
        }];
    } else if ([@"myWalletMaxRedeem" isEqualToString:cmd]) {
        [self showWaitingProgress:1.0];
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model myWalletMaxRedeem:^(NSString *detail) {
            [self hideWaitingProgress];
            NSString *jsStr = [NSString stringWithFormat:@"getMyWalletMaxRedeem('%@')", detail];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"walletRedeem" isEqualToString:cmd]) {
        if ([parameters count] != 3) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        
        NSString *amount = parameters[0];
        NSString *payPwd = parameters[1];
        NSString *maxRedeemAmount = parameters[2];
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model walletRedeem:amount pawPwd:payPwd maxRedeemAmount:maxRedeemAmount success:^{
            __weak EABaseWebViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [EANavigationHelper navigationToAssets:weakSelf];
                [AppDelegate showTipsOnGlobalWindow:@"赎回成功"];
            });
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"withdraw" isEqualToString:cmd]) {
        if ([parameters count] != 3) {
             [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        
        NSString *amount = parameters[0];
        NSString *payPwd = parameters[1];
        NSString *userBalance = parameters[2];
        
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model withdraw:amount payPwd:payPwd useBalance:userBalance success:^{
            [self hideWaitingProgress];
            
            // 提现成功
            __weak EABaseWebViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [EANavigationHelper navigationToTradeLogPage:weakSelf highlightTab:@"2"];
            });

        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"recharge" isEqualToString:cmd]) {
        if ([parameters count] != 6) {
             [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        
        NSString *moneyOrder = parameters[0];
        NSString *haveIdCard = parameters[1];
        NSString *haveBankCard = parameters[2];
        NSString *name = parameters[3];
        NSString *idCard = parameters[4];
        NSString *bankCard = parameters[5];
        
        BOOL haveIdCardBool = [@"true" isEqualToString:haveIdCard] ? YES : NO;
        BOOL haveBankCardBool = [@"true" isEqualToString:haveBankCard] ? YES : NO;
        
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model recharge:moneyOrder haveIdCard:haveIdCardBool haveBankCard:haveBankCardBool name:name idCard:idCard bankCard:bankCard success:^(NSString *jsCallback) {
            [self execJs:jsCallback];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"verify" isEqualToString:cmd]) {
        if ([parameters count] != 3) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        NSString *name = parameters[0];
        NSString *idCard = parameters[1];
        NSString *bankCard = parameters[2];
        EAAccountModel *model = [ModelManager getModel:[EAAccountModel class]];
        [model verify:name idCard:idCard bankCard:bankCard success:^{
            [self hideWaitingProgress];
            __weak EABaseWebViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                [AppDelegate showTipsOnGlobalWindow:@"认证成功"];
            });
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"getChangeLoginPasswordRandomSms" isEqualToString:cmd]) {
        if ([parameters count] != 2) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        NSString *mobile = parameters[0];
        NSString *pwd = parameters[1];
        
        EAAccountModel *model = [ModelManager getModel:[EAAccountModel class]];
        [model requestChangeLoginPasswordRandomSms:mobile pwd:pwd success:^{
            [self hideWaitingProgress];
            [self execJs:@"getMobileCheckCode()"];
            
            [AppDelegate showTipsOnGlobalWindow:@"短信已发送，请注意查收"];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"changeLoginPassword" isEqualToString:cmd]) {
        if ([parameters count] != 3) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        NSString *mobile = parameters[0];
        NSString *pwd = parameters[1];
        NSString *code = parameters[2];
        
        EAAccountModel *model = [ModelManager getModel:[EAAccountModel class]];
        [model changeLoginPassword:mobile pwd:pwd code:code success:^{
            [self hideWaitingProgress];
            __weak EABaseWebViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                [AppDelegate showTipsOnGlobalWindow:@"登录密码设置成功"];
            });
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"getChangePayPasswordRandomSms" isEqualToString:cmd]) {
        if ([parameters count] != 3) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        NSString *mobile = parameters[0];
        NSString *pwd = parameters[1];
        NSString *havePayPwd = parameters[2];
        
        BOOL havePayPwdBool = [@"true" isEqualToString:havePayPwd] ? YES : NO;
        
        EAAccountModel *model = [ModelManager getModel:[EAAccountModel class]];
        [model requestChangePayPasswordRandomSms:mobile pwd:pwd havePayPwd:havePayPwdBool success:^{
            [self hideWaitingProgress];
            [self execJs:@"getMobileCheckCode()"];
            [AppDelegate showTipsOnGlobalWindow:@"短信已发送，请注意查收"];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"doChangePayPassword" isEqualToString:cmd]) {
        if ([parameters count] != 4) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        NSString *idCard = parameters[0];
        NSString *pwd = parameters[1];
        NSString *code = parameters[2];
        NSString *havePayPwd = parameters[3];
        
        BOOL havePayPwdBool = [@"true" isEqualToString:havePayPwd] ? YES : NO;
        
        EAAccountModel *model = [ModelManager getModel:[EAAccountModel class]];
        [model changePayPassword:idCard pwd:pwd code:code havePayPwd:havePayPwdBool success:^{
            [self hideWaitingProgress];
            __weak EABaseWebViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                [AppDelegate showTipsOnGlobalWindow:@"交易密码设置成功"];
            });
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"refreshLoginState" isEqualToString:cmd]) {
       EAAccountModel *model = [ModelManager getModel:[EAAccountModel class]];
        [model refreshLoginState:^(NSString *jsCallback) {
            [self execJs:jsCallback];
        } failure:^(NSError *error) {
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"loadNews" isEqualToString:cmd]) {
        [self showWaitingProgress:1.0];
        EAAccountModel *model = [ModelManager getModel:[EAAccountModel class]];
        [model loadNews:^(NSString *jsCallback) {
            [self hideWaitingProgress];
            [self execJs:jsCallback];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"tips" isEqualToString:cmd]) {
        if ([parameters count] != 1) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        NSString *tips = parameters[0];
        [self showToast:tips];
    } else if ([@"getCurrentMobile" isEqualToString:cmd]) {
        [self showWaitingProgress:1.0];
        EAAccountModel *model = [ModelManager getModel:[EAAccountModel class]];
        [model getLoginMobile:^(NSString *jsCallback) {
            [self hideWaitingProgress];
            [self execJs:jsCallback];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"getYdb" isEqualToString:cmd]) {
        if ([parameters count] != 1) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        NSString *type = parameters[0];
         EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model ydb:type success:^(NSString *detail) {
            [self hideWaitingProgress];
            NSString *jsStr = [NSString stringWithFormat:@"getYdb('%@')", detail];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];

    } else if ([@"ydbApply" isEqualToString:cmd]) {
        if ([parameters count] != 9) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        
        NSString *amount = parameters[0];
        NSString *payPwd = parameters[1];
        NSString *useBalance = parameters[2];
        NSString *hasPayPwd = parameters[3];
        NSString *cjResultId = parameters[4];
        NSString *aid = parameters[5];
        NSString *remainAmount = parameters[6];
        NSString *minNum = parameters[7];
        NSString *isRefreshEvent = parameters[8];
        
        BOOL hasPayPwdBool = [@"true" isEqualToString:hasPayPwd] ? YES : NO;
        BOOL isRefreshEventBool = [@"true" isEqualToString:isRefreshEvent] ? YES : NO;
        
         EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model ydbApply:amount payPwd:payPwd useBalance:useBalance hasPayPwd:hasPayPwdBool cjResultId:cjResultId aid:aid remainAmount:remainAmount minNum:minNum isRefreshEvent:isRefreshEventBool inadequateJs:^(NSString *jsCallback) {
            [self hideWaitingProgress];
            [self execJs:jsCallback];
        } success:^{
            [self hideWaitingProgress];
            // 益定宝投资成功,跳转我的益定宝页面
            __weak EABaseWebViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [EANavigationHelper navigationToMyYdbPage:weakSelf withApplyAmount:amount];
                [AppDelegate showTipsOnGlobalWindow:@"投资成功"];
            });

        } failure:^(NSError *error) {
            [self hideWaitingProgress];
           [self showToast:[error localizedDescription]];
        }];
    } else if ([@"custom" isEqualToString:cmd]) {
        
        [self showWaitingProgress:1.0];
        EAMeModel *model = [ModelManager getModel:[EAMeModel class]];
        [model custom:^{
            [self hideWaitingProgress];
            __weak EABaseWebViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
                conversationVC.hidesBottomBarWhenPushed = YES;
                conversationVC.conversationType =ConversationType_CUSTOMERSERVICE;
                conversationVC.targetId = @"KEFU1439102885169";
                conversationVC.userName =@"KEFU1439102885169";
                conversationVC.title = @"在线客服";
                [weakSelf.navigationController pushViewController:conversationVC animated:YES];
            });
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"callTel" isEqualToString:cmd]) {
        __weak EABaseWebViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *telStr = [NSString stringWithFormat:@"tel:%@", @"4008533178"];
            NSURL *telURL =[NSURL URLWithString:telStr];
            [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:telURL]];
        });
    } else if ([@"getMyYdbList" isEqualToString:cmd]) {
        if ([parameters count] != 1) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        NSString *applyStatus = parameters[0];
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model myYdbList:applyStatus success:^(NSString *list) {
            [self hideWaitingProgress];
            NSString *jsStr = [NSString stringWithFormat:@"getMyYdbList%@('%@')", applyStatus, list];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"getHost" isEqualToString:cmd]) {
        [self showWaitingProgress:1.0];
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model getHost:^(NSString *jsCallback) {
            [self hideWaitingProgress];
            [self execJs:jsCallback];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
           [self showToast:[error localizedDescription]];
        }];
    } else if ([@"getInviteCode" isEqualToString:cmd]) {
        [self showWaitingProgress:1.0];
        EAMeModel *model = [ModelManager getModel:[EAMeModel class]];
        [model getInviteCode:^(NSString *jsCallback) {
            [self hideWaitingProgress];
            [self execJs:jsCallback];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"getUserVerify" isEqualToString:cmd]) {
        [self showWaitingProgress:1.0];
        EAAccountModel *model = [ModelManager getModel:[EAAccountModel class]];
        [model userVerifyState:^(NSString *detail) {
            [self hideWaitingProgress];
            
            if([detail isEqualToString:@"1"] || [detail isEqualToString:@"true"]) {
                detail = @"true";
            } else {
                detail = @"false";
            }

           NSString *jsStr = [NSString stringWithFormat:@"getUserVerify('%@')", detail];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
           [self showToast:[error localizedDescription]];
        }];
    } else if ([@"queryBankCardBinLimit" isEqualToString:cmd]) {
        if ([parameters count] != 1) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        
        NSString *bankCard = parameters[0];
        EAAccountModel *model = [ModelManager getModel:[EAAccountModel class]];
        [model bankCardBinLimit:bankCard success:^(NSString *detail) {
            [self hideWaitingProgress];
           NSString *jsStr = [NSString stringWithFormat:@"queryBankCardBinLimit('%@')", detail];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
         [self showToast:[error localizedDescription]];
        }];
    } else if ([@"queryBankLimit" isEqualToString:cmd]) {
        if ([parameters count] != 1) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        
        NSString *bankFullName = parameters[0];
        EAAccountModel *model = [ModelManager getModel:[EAAccountModel class]];
        [model bankLimit:bankFullName success:^(NSString *detail) {
            [self hideWaitingProgress];
            NSString *jsStr = [NSString stringWithFormat:@"queryBankLimit('%@')", detail];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
           [self showToast:[error localizedDescription]];
        }];
    } else if ([@"getMyMoneyStatistics" isEqualToString:cmd]) {
        [self showWaitingProgress:1.0];
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model myMoneyStatisics:^(NSString *detail) {
            [self hideWaitingProgress];
           NSString *jsStr = [NSString stringWithFormat:@"getMyMoneyStatistics('%@')", detail];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
           [self showToast:[error localizedDescription]];
        }];
    } else if ([@"backAndDestroy" isEqualToString:cmd]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            DDLogInfo(@"backAndDestroy");
            [self.navigationController popViewControllerAnimated:YES];
        });
    } else if ([@"toWelcomePage" isEqualToString:cmd]) {
        dispatch_async(dispatch_get_main_queue(), ^{ 
            AppDelegate* delegate = [UIApplication sharedApplication].delegate;
            [delegate showGuideView];
        });
    } else if ([@"getWalletDetail" isEqualToString:cmd]) {
        [self showWaitingProgress:1.0];
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model walletDetail:^(NSString *detail) {
            [self hideWaitingProgress];
           NSString *jsStr = [NSString stringWithFormat:@"getWalletDetail('%@')", detail];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
           [self showToast:[error localizedDescription]];
        }];
    } else if ([@"getMyWalletDetail" isEqualToString:cmd]) {
        [self showWaitingProgress:1.0];
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model myWalletDetail:^(NSString *detail) {
            [self hideWaitingProgress];
            NSString *jsStr = [NSString stringWithFormat:@"getMyWalletDetail('%@')", detail];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"onRechargeSuccess" isEqualToString:cmd]) {
        __weak EABaseWebViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *viewControllers = weakSelf.navigationController.viewControllers;
            
            if(!viewControllers) {
                // 跟视图
                NSString *url = [NSString stringWithFormat:@"tradelog.html?page_type=1&highlight_page=1"];
                EABaseWebViewController * tradeLogViewController = [[EABaseWebViewController alloc]initWithHtml:url pageName:EAPageTradeLog enablePullRefresh:YES];
                tradeLogViewController.hidesBottomBarWhenPushed=YES;
                [weakSelf.navigationController pushViewController:tradeLogViewController animated:YES];
                return;
            }
            
            UIViewController *prevViewController = [EAViewControllerHelper prevViewControllerWithPageName:EAPageWalletApply inViewControllers:viewControllers];
            if(!prevViewController) {
                prevViewController = [EAViewControllerHelper prevViewControllerWithPageName:EAPageYdbApply inViewControllers:viewControllers];
            }
            
            if(prevViewController) {
                // 前一个页面是益钱包投资或者益定宝投资，直接继续投资
                [weakSelf.navigationController popViewControllerAnimated:YES];
                // 发送充值成功的消息
                NotifyModelClient(EAAssetsModelClient, @selector(onRechargeSuccess), onRechargeSuccess);
            } else {
                // 普通充值，跳转充值流水
                [EANavigationHelper navigationToTradeLogPage:weakSelf highlightTab:@"1"];
            }
        });
    } else if ([@"login" isEqualToString:cmd]) {
        if ([parameters count] != 2) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        
        NSString *mobile = parameters[0];
        NSString *pwd = parameters[1];
        
        EAAccountModel *model = [ModelManager getModel:[EAAccountModel class]];
        [model login:mobile pwd:pwd success:^{
            [self hideWaitingProgress];
            __weak EABaseWebViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [AppDelegate showTipsOnGlobalWindow:@"登录成功"];
            });
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"doLogOut" isEqualToString:cmd]) {
        EAAccountModel *model = [ModelManager getModel:[EAAccountModel class]];
        [model logout:^{
            [self refresh];
        } failure:^(NSError *error) {
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"jsLog" isEqualToString:cmd]) {
        if ([parameters count] != 1) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
//        NSString *info = parameters[0];
//        NSString *logInfo = [NSString stringWithFormat:@"jsLog %@", info];
//        DDLogDebug(logInfo);
    } else if ([@"getDqByFlag" isEqualToString:cmd]) {
        if ([parameters count] != 1) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        NSString *flag = parameters[0];
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model getDqByFlag:flag success:^(NSString *detail) {
            [self hideWaitingProgress];
            NSString *jsStr = [NSString stringWithFormat:@"getDqByFlag('%@')", detail];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"doDqApply" isEqualToString:cmd]) {
        if ([parameters count] != 9) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        
        NSString *amount = parameters[0];
        NSString *payPwd = parameters[1];
        NSString *useBalance = parameters[2];
        NSString *hasPayPwd = parameters[3];
        NSString *cjResultId = parameters[4];
        NSString *flag = parameters[5];
        NSString *minNum = parameters[6];
        NSString *maxNum = parameters[7];
        NSString *isRefreshEvent = parameters[8];
        
        BOOL hasPayPwdBool = [@"true" isEqualToString:hasPayPwd] ? YES : NO;
        BOOL isRefreshEventBool = [@"true" isEqualToString:isRefreshEvent] ? YES : NO;
        
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model dqApply:amount payPwd:payPwd useBalance:useBalance havePayPwd:hasPayPwdBool cjResultId:cjResultId flag:flag minNum:minNum maxNum:maxNum isRefreshEvent:isRefreshEventBool inadequateJs:^(NSString *jsCallback) {
            [self hideWaitingProgress];
            [self execJs:jsCallback];
        } success:^{
            [self hideWaitingProgress];
            // 益定宝投资成功,跳转我的益定宝页面
            __weak EABaseWebViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [EANavigationHelper navigationToMyYdbPage:weakSelf withApplyAmount:amount];
                [AppDelegate showTipsOnGlobalWindow:@"投资成功"];
            });
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"getMyDqApplyList" isEqualToString:cmd]) {
        if ([parameters count] != 3) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        
        NSString *finish = parameters[0];
        NSString *page = parameters[1];
        NSString *pageSize = parameters[2];
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model myDqApplyList:finish page:[page intValue] pageSize:[pageSize intValue] success:^(NSString *detail) {
            [self hideWaitingProgress];
            NSString *jsStr = [NSString stringWithFormat:@"getMyDqApplyList%@('%@')", finish, detail];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
             [self hideWaitingProgress];
             [self showToast:[error localizedDescription]];
        }];
    } else if ([@"getIncomeCounterList" isEqualToString:cmd]) {
        if ([parameters count] != 4) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        NSString *counterWay = parameters[0];
        NSString *tzAmount = parameters[1];
        NSString *yearRate = parameters[2];
        NSString *tzNo = parameters[4];
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model inComeCounterList:counterWay tzAmount:tzAmount yearRate:yearRate tzNo:tzNo success:^(NSString*detail){
            [self hideWaitingProgress];
            NSString *jsStr = [NSString stringWithFormat:@"getIncomeCounterList('%@')", detail];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"getExpectedIncome" isEqualToString:cmd]) {
        if ([parameters count] != 3) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
       
        [self showWaitingProgress:1.0];
        
        NSString *tzAmount = parameters[0];
        NSString *yearRate = parameters[1];
        NSString *tzNo = parameters[2];
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model expectedIncome:tzAmount yearRate:yearRate tzNo:tzNo success:^(NSString*detail){
            [self hideWaitingProgress];
            NSString *jsStr = [NSString stringWithFormat:@"getExpectedIncome('%@')", detail];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"getMyProtocol" isEqualToString:cmd]) {
        if ([parameters count] != 1) {
            [self showToast:[[NSError epParameterError] localizedDescription]];
            return;
        }
        
        [self showWaitingProgress:1.0];
        
        NSString *applyId = parameters[0];
        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model myProtocol:applyId success:^(NSString*detail){
            [self hideWaitingProgress];
            NSString *jsStr = [NSString stringWithFormat:@"getMyProtocol('%@')", detail];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"getDqApplyRecord" isEqualToString:cmd]) {
        [self showWaitingProgress:1.0];

        EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
        [model dqApplyRecord:^(NSString *detail) {
            [self hideWaitingProgress];
            NSString *jsStr = [NSString stringWithFormat:@"getDqApplyRecord('%@')", detail];
            [self execJs:jsStr];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"getMemberIsNewbie" isEqualToString:cmd]) {
        [self showWaitingProgress:1.0];
        
        EAAccountModel *model = [ModelManager getModel:[EAAccountModel class]];
        [model memberIsNewbie:^(NSString *jsCallback) {
            [self hideWaitingProgress];
            [self execJs:jsCallback];
        } failure:^(NSError *error) {
            [self hideWaitingProgress];
            [self showToast:[error localizedDescription]];
        }];
    } else if ([@"finishLoadMore" isEqualToString:cmd]) {
        [self hideWaitingProgress];
        [self.webView.scrollView.mj_footer endRefreshing];
    }
}

#pragma mark private method

-(void)loadMore {
    NSString *jsStr = [NSString stringWithFormat:@"loadMore('')"];
    [self execJs:jsStr];
}

/*
 * 默认刷新方法
 */
- (void)refresh{
    DDLogInfo(@"");
    
    if ([_startUrl length] > 0) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_startUrl]];
        [_webView loadRequest:request];
    } else if (![_startHtml hasSuffix:@"html"]){
        NSRange htmlRange = [_startHtml rangeOfString:@".html?"];
        if (htmlRange.location != NSNotFound) {
            NSString *preStr = [_startHtml substringToIndex:htmlRange.location + htmlRange.length - 1];
            NSString *sufStr = [_startHtml substringFromIndex:htmlRange.location + htmlRange.length];
            NSString *htmlPath = [[[ModelManager getModel:[EAAssetsModel class]] htmlBasePath] stringByAppendingPathComponent:preStr];
            NSString *encodedPath = [htmlPath stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@?%@",
                                               encodedPath,
                                               sufStr]];
            NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
            [_webView loadRequest:request];
        }
    } else {
        NSString *htmlPath = [[[ModelManager getModel:[EAAssetsModel class]] htmlBasePath] stringByAppendingPathComponent:_startHtml];
        NSString *htmlStr = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
        [_webView loadHTMLString:htmlStr baseURL:[[ModelManager getModel:[EAAssetsModel class]]localBaseUrl]];
    }
}

- (void)backToHome {
    __weak EABaseWebViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    });
}

- (void)handleGotoLocalPage:(NSArray*)parameters {
    if ([parameters count] != 2) {
        [self showToast:[[NSError epParameterError] localizedDescription]];
        return;
    }
    
    NSString *url = parameters[0];
    NSString *check = parameters[1];
    
    EAAssetsModel *model = [ModelManager getModel:[EAAssetsModel class]];
    [self showWaitingProgress:DEFAULT_WAITING_PROGRESS_DELAY];
    [model gotoLocalWebPage:url checkLogin:check goto:^(NSString *page) {
        [self hideWaitingProgress];
        [EANavigationHelper navigationToUrl:self url:page];
    } failure:^(NSError *error) {
        [self hideWaitingProgress];
         [self showToast:[error localizedDescription]];
    }];
}

#pragma mark @protocol EAAccountModelClient

-(void)onLogin {
    DDLogInfo(@"pageName = %@", [EABaseModel pageCodeToPageName:self.pageName]);
    [self refresh];
}

-(void)onLogout {
    DDLogInfo(@"pageName = %@", [EABaseModel pageCodeToPageName:self.pageName]);
    [self refresh];
}

- (void)onVerify {
    if(self.pageName == EAPageMe) {
        [self refresh];
    }
}

#pragma mark @protocol EAAssetsModelClient

-(BOOL)onRechargeSuccess {
    DDLogInfo(@"");
    if(_pageName == EAPageWalletApply || _pageName == EAPageYdbApply) {
        __weak EABaseWebViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf execJs:@"onRechargeSuccess()"];
        });
        return YES;
    }
    return NO;
}

-(void)onWalletApply:(double)applyAmount {
    DDLogInfo(@"applyAmount = %f, pageName = %@", applyAmount, [EABaseModel pageCodeToPageName:_pageName]);
    if(_pageName == EAPageMyWallet) {
         _walletApplyAmount = applyAmount;
    }
    if(self.pageName == EAPageAssets) {
        DDLogInfo(@"onWalletApply ");
        [self refresh];
    }
}

-(void)onWalletRedeem:(double)redeemAmount {
    DDLogInfo(@"redeemAmount = %f", redeemAmount);
    if(self.pageName == EAPageAssets) {
        DDLogInfo(@"onWalletRedeem ");
        _walletRedeemAmount = redeemAmount;
        [self refresh];
    }
}

-(void)onWithdraw:(double)withdrawAmount {
    DDLogInfo(@"withdrawAmount = %f", withdrawAmount);
    if(self.pageName == EAPageAssets) {
        DDLogInfo(@"onWithdraw ");
        [self refresh];
    }
}

-(void)onYdbApply:(double)applyAmount {
    DDLogInfo(@"applyAmount = %f, pageName = %@", applyAmount, [EABaseModel pageCodeToPageName:_pageName]);
    if(_pageName == EAPageMyYdb) {
        _ydbApplyAmount = applyAmount;
    }
    if(self.pageName == EAPageAssets) {
        DDLogInfo(@"onYdbApply ");
        [self refresh];
    }
}


@end
