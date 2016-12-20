//
//  ModelManager.m
//  mobile
//
//  Created by kevin on 15/11/10.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "ModelManager.h"
#import "ModelFactory.h"
#import "CommonServiceCenter.h"
#import "EAMeModel.h"
#import "IMeModel.h"


@interface ModelManager()

@end

@implementation ModelManager
+ (void)initialize
{
    if (self == [ModelManager self]) {
        // Register all model classes
        [self _registerProtocols];
    }
}

+ (void)initModel:(void (^)(void))blcok
{
    DDLogInfo(@"initModel");

    //用于在初始化model之前，先设置好配置
    if (blcok) {
        blcok();
    }
    
    // 预先获取Model实例
    GetModel(EAMeModel);
}

+ (id)getModel:(Class)cls
{
    //    return [[CommonServiceCenter defaultCenter] getService:cls];
    return [ModelFactory getModelFromClass:cls];
}

+ (id)getModelFromProtocol:(Protocol *)protocol
{
    return [ModelFactory getModelFromProtocol:protocol];
}

+ (void)addClient:(id)obj for:(Protocol *)protocol
{
    [[CommonServiceCenter defaultCenter] addServiceClient:obj withKey:protocol];
}

+ (void)removeClient:(id)obj for:(Protocol *)protocol
{
    [[CommonServiceCenter defaultCenter] removeServiceClient:obj withKey:protocol];
}

+ (void)removeClient:(id)obj
{
    [[CommonServiceCenter defaultCenter] removeServiceClient:obj];
}

+ (void)_registerProtocols
{
#define REGISTER_MODEL_PROTOCOL(c, p) [ModelFactory registerClass:([c class]) forProtocol:(@protocol(p))]
    // 注册模块
    
    REGISTER_MODEL_PROTOCOL(EAMeModel, IMeModel);
    
#undef REGISTER_MODEL_PROTOCOL
}



@end
