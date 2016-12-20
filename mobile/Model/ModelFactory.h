//
//  ModelFactory.h
//  mobile
//
//  Created by kevin on 15/11/10.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelFactory : NSObject

+ (void)registerClass:(Class)cls forProtocol:(Protocol *)protocol;
+ (Class)classForProtocol:(Protocol *)protocol;
+ (BOOL)hasRegisteredProtocol:(Protocol *)protocol;

+ (id)getModelFromClass:(Class)cls;
+ (id)getModelFromProtocol:(Protocol *)protocol;

@end
