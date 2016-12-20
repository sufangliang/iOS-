//
//  ModelFactory.m
//  mobile
//
//  Created by kevin on 15/11/10.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "ModelFactory.h"

static NSMapTable *modelClassMap() {
    static NSMapTable *table = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        table = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsStrongMemory];
    });
    return table;
}

static NSMapTable *modelsMap() {
    static NSMapTable *table = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        table = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsStrongMemory];
    });
    return table;
}

@implementation ModelFactory

#pragma mark -

+ (void)registerClass:(Class)cls forProtocol:(Protocol *)protocol
{
    if (![cls conformsToProtocol:protocol]) {
        NSParameterAssert(0);   // class未实现protocol
        return;
    }
    
    [modelClassMap() setObject:cls forKey:protocol];
}

+ (Class)classForProtocol:(Protocol *)protocol
{
    return [modelClassMap() objectForKey:protocol];
}

+ (BOOL)hasRegisteredProtocol:(Protocol *)protocol
{
    NSParameterAssert(protocol);
    return [modelClassMap() objectForKey:protocol] != nil;
}

+ (id)getModelFromClass:(Class)cls
{
    id obj = [modelsMap() objectForKey:cls];
    if (nil == obj) {
        obj = [[cls alloc] init];
        [modelsMap() setObject:obj forKey:cls];
    }
    return obj;
}

+ (id)getModelFromProtocol:(Protocol *)protocol
{
    id obj;
    Class impClass = [modelClassMap() objectForKey:protocol];
    if (impClass) {
        obj = [modelsMap() objectForKey:impClass];
        if (nil == obj) {
            obj = [[impClass alloc] init];
            [modelsMap() setObject:obj forKey:impClass];
        }
    }
    return obj;
}
@end
