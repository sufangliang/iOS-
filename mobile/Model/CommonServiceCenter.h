//
//  CommonServiceCenter.h
//  mobile
//
//  Created by kevin on 15/11/10.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef Protocol * CommonServiceClientKey;

// 持久对象中心。 用来存放为全局服务的对象。
@interface CommonServiceCenter : NSObject

+ (CommonServiceCenter *)defaultCenter;

// 获取服务对象。
// 如果对象不存在， 会自动创建。
- (id)getService:(Class) cls;

- (void)removeService:(Class) cls;

- (void)setNotifyingClientsWithKey:(CommonServiceClientKey)key isNotifying:(BOOL)isNotifying;
- (BOOL)isNotifyingClientsWithKey:(CommonServiceClientKey)key;
- (NSArray *)serviceClientsWithKey:(CommonServiceClientKey)key;
- (void)addServiceClient:(id)client withKey:(CommonServiceClientKey)key;
- (void)removeServiceClient:(id)client withKey:(CommonServiceClientKey)key;
- (void)removeServiceClient:(id)client;

@end

#define GET_SERVICE(obj) (obj *)[[CommonServiceCenter defaultCenter] getService:[obj class]]

#define REMOVE_SERVICE(obj) [[CommonServiceCenter defaultCenter] removeService:[obj class]]

/// 为了client不被增加引用计数，引入一个包装类。
@interface CommonServiceClient : NSObject

@property (nonatomic, weak) id object;
- (id)initWithObject:(id)object;

@end

#define ADD_SERVICE_CLIENT(protocolName, object) [[CommonServiceCenter defaultCenter] addServiceClient:object withKey:@protocol(protocolName)]
#define REMOVE_SERVICE_CLIENT(protocolName, object) [[CommonServiceCenter defaultCenter] removeServiceClient:object withKey:@protocol(protocolName)]
#define REMOVE_ALL_SERVICE_CLIENT(object) [[CommonServiceCenter defaultCenter] removeServiceClient:object]
#define NOTIFY_SERVICE_CLIENT(protocolName, selector, func) \
{ \
NSAssert(![[CommonServiceCenter defaultCenter] isNotifyingClientsWithKey:@protocol(protocolName)], @"recusively call the same service clients."); \
[[CommonServiceCenter defaultCenter] setNotifyingClientsWithKey:@protocol(protocolName) isNotifying:YES]; \
NSArray *__clients__ = [[CommonServiceCenter defaultCenter] serviceClientsWithKey:@protocol(protocolName)]; \
for (CommonServiceClient *client in __clients__) \
{ \
id obj = client.object; \
if ([obj respondsToSelector:selector]) \
{ \
[obj func]; \
} \
} \
[[CommonServiceCenter defaultCenter] setNotifyingClientsWithKey:@protocol(protocolName) isNotifying:NO]; \
}
