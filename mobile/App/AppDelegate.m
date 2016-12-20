//
//  AppDelegate.m
//  mobile
//
//  Created by ChenLei on 15/9/12.
//  Copyright (c) 2015年 edaga. All rights reserved.
//

#import "AppDelegate.h"
#import "EAMainTabViewController.h"
#import "EAGuideView.h"
#import "UIImage+NSUIImageEx.h"
#import "RongIMKit/RongIMKit.h"
#import <RongIMLib/RongIMLib.h>
#import "EALogFormater.h"
#import "EPInfoAlert.h"
#import "EAUMengStatistics.h"


#define RONGCLOUD_IM_APPKEY @"m7ua80gbufs7m"



@interface AppDelegate ()



@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    DDLogInfo(@"");
    
    // CocoaLumberjack init
    [self initCocoaLumberjack];
    
    // 友盟统计
    [[EAUMengStatistics shareInstance] initWhenLaunchForOnce];
    
    // 融云sdk
    [self initRongIm];
    
    
    // badge
    application.applicationIconBadgeNumber = 0;
    
    // push
    [self registerRemoteNotification];
    
    // init UI
    UIViewController *rootVC = [self createMainUI];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    
    // guide View
    [self checkGuideView];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // 清除通知
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

/**
 *  将得到的devicetoken 传给融云用于离线状态接收push ，您的app后台要上传推送证书
 *
 *  @param application <#application description#>
 *  @param deviceToken <#deviceToken description#>
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token =[[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]
                       stringByReplacingOccurrencesOfString:@">" withString:@""]
     stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}

#pragma mark - Common Mothed

- (void)registerRemoteNotification
{
    UIApplication *application = [UIApplication sharedApplication];
    NSUInteger UserNotificationType = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    
    if (IOS8_OR_LATER)
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UserNotificationType
                                                                                        categories:nil]];
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:UserNotificationType];
    }
}

#define GUIDE_KEY  @"hasShowGuide"
- (void)checkGuideView
{
    BOOL hasShow = [[NSUserDefaults standardUserDefaults] boolForKey:GUIDE_KEY];
    if (!hasShow) {
        
        [self showGuideView];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:GUIDE_KEY];
    }
}

- (void)showGuideView
{
    EAGuideView *guideView = [[EAGuideView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.window addSubview:guideView];
}

+ (void) showTipsOnGlobalWindow:(NSString*) tips
{
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    [EPInfoAlert showInfo:tips inView:[delegate.window.rootViewController view]];
}

#pragma mark - UI Init

- (UIViewController *)createMainUI
{
    EAMainTabViewController *mainTabViewController = [[EAMainTabViewController alloc]init];
    _mainViewController = mainTabViewController;
    return mainTabViewController;
}

- (void)addNaviBarCommonProperty:(UINavigationController *)naviVC
{
//    naviVC.navigationBar.tintColor = [UIColor whiteColor];
    naviVC.navigationBar.tintColor = [UIColor blueColor];
    
//    naviVC.navigationBar.translucent = NO;

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

- (void)initRongIm
{
    
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessageNotification:) name:RCKitDispatchMessageNotification object:nil];
  //  [[RCIM sharedRCIM] setConnectionStatusDelegate:self];

}


/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
   
}

- (void)didReceiveMessageNotification:(NSNotification *)notification {
    if([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    }
}

- (void) initCocoaLumberjack
{
    EALogFormater *formatter = [[EALogFormater alloc]init];
    [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
    [[DDASLLogger sharedInstance]  setLogFormatter:formatter];
    [DDLog addLogger:[DDASLLogger sharedInstance] withLevel:DDLogLevelWarning];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    DDFileLogger* ddFileLogger = [[DDFileLogger alloc]init];
    ddFileLogger.rollingFrequency = 24 * 60 * 60;
    ddFileLogger.logFileManager.maximumNumberOfLogFiles=7;
    [DDLog addLogger:ddFileLogger withLevel:DDLogLevelWarning];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
}

@end
