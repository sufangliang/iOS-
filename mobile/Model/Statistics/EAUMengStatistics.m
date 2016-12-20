//
//  EAUMengStatistics.m
//  mobile
//
//  Created by kevin on 15/11/24.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "EAUMengStatistics.h"
#import "MobClick.h"

#define YOUMENG_APPKEY @"5652bbb167e58e76a900340c"

NSString *const EVENT_KEY_REGISTER = @"Register";
NSString *const EVENT_KEY_WALLETAPPLY = @"WalletApply";
NSString *const EVENT_KEY_YDBAPPLY = @"YdbApply";

@implementation EAUMengStatistics

+ (instancetype)shareInstance {
    static EAUMengStatistics *instance = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        instance = [[EAUMengStatistics alloc] init];
    });
    return instance;
}

- (void)initWhenLaunchForOnce {
    [MobClick startWithAppkey:YOUMENG_APPKEY reportPolicy:BATCH channelId:nil];
    
    // 设置版本号
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    // 设置日记加密发送
    [MobClick setEncryptEnabled:YES];
    
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#else
    [MobClick setLogEnabled:NO];
#endif
}

/** 自定义事件,数量统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 
 @param  eventId 网站上注册的事件Id.
 @param  label 分类标签。不同的标签会分别进行统计，方便同一事件的不同标签的对比,为nil或空字符串时后台会生成和eventId同名的标签.
 @param  accumulation 累加值。为减少网络交互，可以自行对某一事件ID的某一分类标签进行累加，再传入次数作为参数。
 @return void.
 */
- (void)event:(NSString *)eventId; {
    [MobClick event:eventId];
}

/** 自定义事件,数量统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 */
- (void)event:(NSString *)eventId label:(NSString *)label {
    [MobClick event:eventId label:label];
}

/** 自定义事件,数量统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 */
- (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes {
   [MobClick event:eventId attributes:attributes];
}

- (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes counter:(int)number {
    [MobClick event:eventId attributes:attributes counter:number];
}

/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 beginEvent,endEvent要配对使用,也可以自己计时后通过durations参数传递进来
 
 @param  eventId 网站上注册的事件Id.
 @param  label 分类标签。不同的标签会分别进行统计，方便同一事件的不同标签的对比,为nil或空字符串时后台会生成和eventId同名的标签.
 @param  primarykey 这个参数用于和event_id一起标示一个唯一事件，并不会被统计；对于同一个事件在beginEvent和endEvent 中要传递相同的eventId 和 primarykey
 @param millisecond 自己计时需要的话需要传毫秒进来
 @return void.
 
 
 @warning 每个event的attributes不能超过10个
 eventId、attributes中key和value都不能使用空格和特殊字符，且长度不能超过255个字符（否则将截取前255个字符）
 id， ts， du是保留字段，不能作为eventId及key的名称
 
 */
- (void)beginEvent:(NSString *)eventId {
    [MobClick beginEvent:eventId];
}

/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */
- (void)endEvent:(NSString *)eventId {
     [MobClick endEvent:eventId];
}

/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

- (void)beginEvent:(NSString *)eventId label:(NSString *)label {
    [MobClick beginEvent:eventId label:label];
}
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

- (void)endEvent:(NSString *)eventId label:(NSString *)label {
    [MobClick endEvent:eventId label:label];
}
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

- (void)beginEvent:(NSString *)eventId primarykey :(NSString *)keyName attributes:(NSDictionary *)attributes {
    [MobClick beginEvent:eventId primarykey:keyName attributes:attributes];
}
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

- (void)endEvent:(NSString *)eventId primarykey:(NSString *)keyName {
    [MobClick endEvent:eventId primarykey:keyName];
}
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

- (void)event:(NSString *)eventId durations:(int)millisecond {
    [MobClick event:eventId durations:millisecond];
}
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */

- (void)event:(NSString *)eventId label:(NSString *)label durations:(int)millisecond {
    [MobClick event:eventId label:label durations: millisecond];
}
/** 自定义事件,时长统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID.
 */
- (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes durations:(int)millisecond {
    [MobClick event:eventId attributes:attributes durations:millisecond];
}

@end
