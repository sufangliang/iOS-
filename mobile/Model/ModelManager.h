//
//  ModelManager.h
//  mobile
//
//  Created by kevin on 15/11/10.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonServiceCenter.h"

#define GetModel(className) ((className *)[ModelManager getModel:[className class]])
#define GetModelI(InterfaceName) ((id<InterfaceName>)[ModelManager getModelFromProtocol:@protocol(InterfaceName)])

#define AddModelClient(protocolName, client) ([ModelManager addClient:client for:@protocol(protocolName)])

#define RemoveModelClient(protocolName, client) ([ModelManager removeClient:client for:@protocol(protocolName)])

#define RemoveModelClientAll(client) ([ModelManager removeClient:client])

#define NotifyModelClient(protocolName, selector, func) NOTIFY_SERVICE_CLIENT(protocolName, selector, func)

@interface ModelManager : NSObject

+ (void)initModel:(void (^)(void))blcok;

+ (id)getModel:(Class)cls;
+ (id)getModelFromProtocol:(Protocol *)protocol;

+ (void)addClient:(id)obj for:(Protocol *)protocol;

+ (void)removeClient:(id)obj for:(Protocol *)protocol;

+ (void)removeClient:(id)obj;

@end