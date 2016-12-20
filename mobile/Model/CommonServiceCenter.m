//
//  CommonServiceCenter.m
//  mobile
//
//  Created by kevin on 15/11/10.
//  Copyright © 2015年 edaga. All rights reserved.
//

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CommonServiceCenter.h"

#import <objc/runtime.h>

#define MULTI_THREAD_SAFE       0

static CommonServiceCenter *_serviceCenter = nil;

@interface CommonServiceCenter ()
{
    NSMutableDictionary *_serviceDictionary;
    NSMutableDictionary *_clientDictionary;
    //用于纪录当前正在遍历中的service
    NSMutableDictionary *_notifyingKeys;
}

@end

@implementation CommonServiceCenter

- (id)init
{
    if(self = [super init])
    {
        DDLogDebug(@"init");
        _serviceDictionary = [[NSMutableDictionary alloc] init];
        _clientDictionary = [[NSMutableDictionary alloc] init];
        _notifyingKeys = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    if (_serviceDictionary != nil)
    {
        DDLogDebug(@"dealloc service center");
#if MULTI_THREAD_SAFE
        @synchronized(self)
#endif
        {
            [_serviceDictionary removeAllObjects];
        }
    }
    
    _serviceCenter = nil;
}

+ (CommonServiceCenter *)defaultCenter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _serviceCenter = [[CommonServiceCenter alloc] init];
    });
    return _serviceCenter;
}

- (id)getService:(Class)cls
{
    NSString *key = [NSString stringWithUTF8String:class_getName(cls)];
    
    id obj = nil;
#if MULTI_THREAD_SAFE
    @synchronized(self)
#endif
    {
        obj = [_serviceDictionary objectForKey:key];
        
        if (obj == nil)
        {
            //obj = [[cls alloc] init];
            // 将init放在alloc之后， 防止在init里面做了啥有影响的东西。
            obj = [[cls alloc] init];
            
            //[obj init];
            
            [_serviceDictionary setObject:obj forKey:key];
            
            DDLogDebug(@"Create service object: %@", obj);
        }
    }
    
    return obj;
}

- (void)removeService:(Class) cls
{
    NSString *key = [NSString stringWithUTF8String:class_getName(cls)];
#if MULTI_THREAD_SAFE
    @synchronized(self)
#endif
    {
        DDLogDebug(@"Remove service object %@", key);
        [_serviceDictionary removeObjectForKey:key];
    }
}

- (NSMutableArray *)_getClientsWithKey:(CommonServiceClientKey)key
{
    if ([NSThread mainThread] != [NSThread currentThread] ) {
        DDLogError(@"get client protocol for key %@ in the other thread",NSStringFromProtocol(key));
    }
    
    NSString *strKey = NSStringFromProtocol(key);
    NSMutableArray *clients = nil;
#if MULTI_THREAD_SAFE
    @synchronized(self)
#endif
    {
        clients = [_clientDictionary objectForKey:strKey];
        if (!clients)
        {
            clients = [[NSMutableArray alloc] init];
            [_clientDictionary setObject:clients forKey:strKey];
        }
    }
    return clients;
}

- (NSArray *)serviceClientsWithKey:(CommonServiceClientKey)key
{
    NSMutableArray *result = [self _getClientsWithKey:key];
    
    return [NSArray arrayWithArray:result];
}

- (void)addServiceClient:(id)client withKey:(CommonServiceClientKey)key
{
    if ([NSThread mainThread] != [NSThread currentThread] ) {
        DDLogError(@"add service client protocol for %p for key %@ in the other thread", client,NSStringFromProtocol(key));
    }
    
    if (client)
    {
        if (![client conformsToProtocol:key])
        {
            DDLogError(@"client doesnot conforms to protocol: %@", NSStringFromProtocol(key));
            //            return;
        }
#if MULTI_THREAD_SAFE
        @synchronized(self)
#endif
        {
            NSMutableArray *clients = [self _getClientsWithKey:key];
            for (CommonServiceClient *obj in clients) {
                if (obj.object == client)
                {
                    return;
                }
            }
            DDLogDebug(@"add client %@ for protocol %@", client, NSStringFromProtocol(key));
            [clients addObject:[[CommonServiceClient alloc] initWithObject:client]];
        }
    }
}

- (void)removeServiceClient:(id)client withKey:(CommonServiceClientKey)key
{
    if ([NSThread mainThread] != [NSThread currentThread] ) {
        DDLogError(@"remove service client protocol for %p for key %@ in the other thread", client,NSStringFromProtocol(key));
    }
    
    if (client)
    {
#if MULTI_THREAD_SAFE
        @synchronized(self)
#endif
        {
            NSMutableArray *clients = [self _getClientsWithKey:key];
            CommonServiceClient *found = nil;
            for (CommonServiceClient *clientObj in clients)
            {
                if (clientObj.object == client)
                {
                    found = clientObj;
                    break;
                }
            }
            if (found)
            {
                DDLogDebug(@"remove client %p for protocol %@", client, NSStringFromProtocol(key));
                found.object = nil;
                [clients removeObject:found];
            }
            
            //检查为空的，因为dealloc的时候weak已经被置空
            NSArray *temp = [NSArray arrayWithArray:clients];
            for (CommonServiceClient *clientObj in temp)
            {
                if (clientObj && clientObj.object == nil)
                {
                    [clients removeObject:clientObj];
                }
            }
        }
    }
}

- (void)removeServiceClient:(id)client
{
    if ([NSThread mainThread] != [NSThread currentThread] ) {
        DDLogError(@"remove service client protocol for %p in the other thread", client);
    }
    DDLogDebug(@"remove all client protocol for %p", client);
    if (client)
    {
#if MULTI_THREAD_SAFE
        @synchronized(self)
#endif
        {
            for (NSMutableArray *clients in [_clientDictionary allValues])
            {
                CommonServiceClient *found = nil;
                for (CommonServiceClient *clientObj in clients)
                {
                    if (clientObj.object == client)
                    {
                        found = clientObj;
                        break;
                    }
                }
                if (found)
                {
                    found.object = nil;
                    [clients removeObject:found];
                }
                
                //检查为空的，因为dealloc的时候weak已经被置空(你好，黑科技)
                NSArray *temp = [NSArray arrayWithArray:clients];
                for (CommonServiceClient *clientObj in temp)
                {
                    if (clientObj && clientObj.object == nil)
                    {
                        [clients removeObject:clientObj];
                    }
                }
            }
        }
    }
}

- (void)setNotifyingClientsWithKey:(CommonServiceClientKey)key isNotifying:(BOOL)isNotifying
{
    NSString *strKey = NSStringFromProtocol(key);
    if (isNotifying)
        [_notifyingKeys setObject:strKey forKey:strKey];
    else
        [_notifyingKeys removeObjectForKey:strKey];
}

- (BOOL)isNotifyingClientsWithKey:(CommonServiceClientKey)key
{
    NSString *strKey = NSStringFromProtocol(key);
    return ([_notifyingKeys objectForKey:strKey] != nil);
}

@end

@implementation CommonServiceClient

- (id)initWithObject:(id)object
{
    if (self = [super init]) {
        self.object = object;
    }
    return self;
}
@end
