//
//  EAConfiguration.m
//  mobile
//
//  Created by ChenLei on 15/9/15.
//  Copyright (c) 2015年 edaga. All rights reserved.
//

#import "EAConfiguration.h"
#import "NSStringEx.h"
#import "ER3DESEncrypt.h"

// user default Key
static NSString *const kEAConfigLoginSecret = @"38huhrfuirh32iu";
static NSString *const kEAConfigLoginState = @"8feuy3h5j4j3h3h";

@implementation EAConfiguration
{
    ER3DESEncrypt *_des3Utils;
}

+ (instancetype)sharedInstance
{
    static EAConfiguration *instance = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        instance = [[EAConfiguration alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _des3Utils = [[ER3DESEncrypt alloc] init];
    }
    
    return self;
}

- (void)clearAll
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kEAConfigLoginSecret];
    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:kEAConfigLoginState];
}

- (NSString *)getPaySignature:(NSString *)paypwd
{
    NSString *secret = [[NSUserDefaults standardUserDefaults] valueForKey:kEAConfigLoginSecret];
    if ([secret length] == 0) {
        return @"";
    }
    
    NSString *raw = [_des3Utils decryptString:secret];
    if ([raw length] == 0) {
        return @"";
    }
        
    NSArray *array = [raw componentsSeparatedByString:@" "];
    if ([array count] != 3) return @"";
        
    NSString *mobile = array[0];
    NSString *pwd = array[1];
    return [NSString stringWithFormat:@"mobile=%@&signature=%@", mobile, [[NSString stringWithFormat:@"%@ %@ %@", mobile, pwd, paypwd] md5]];
}

- (NSString *)getSignature
{
    NSString *secret = [[NSUserDefaults standardUserDefaults] valueForKey:kEAConfigLoginSecret];
    if ([secret length] == 0) {
        return @"";
    }
    
    NSString *raw = [_des3Utils decryptString:secret];
    if ([raw length] == 0) {
        return @"";
    }
    
    NSArray *array = [raw componentsSeparatedByString:@" "];
    if ([array count] != 3) return @"";
    
    NSString *mobile = array[0];
    NSString *pwd = array[1];
    return [NSString stringWithFormat:@"mobile=%@&signature=%@", mobile, [[NSString stringWithFormat:@"%@ %@", mobile, pwd] md5]];
}

- (NSString *)getMobile
{
    NSString *secret = [[NSUserDefaults standardUserDefaults] valueForKey:kEAConfigLoginSecret];
    if ([secret length] == 0) {
        return @"";
    }
    
    NSString *raw = [_des3Utils decryptString:secret];
    if ([raw length] == 0) {
        return @"";
    }
    
    NSArray *array = [raw componentsSeparatedByString:@" "];
    if ([array count] != 3) return @"";
    return array[0];
}

- (void)setSignature:(NSString *)mobile password:(NSString *)pwd
{
    if ([mobile length] == 0 || [pwd length] == 0)
        return;
    
    int rand = arc4random();
    NSString *raw = [NSString stringWithFormat:@"%@ %@ %d", mobile, [pwd md5], rand];
    NSString *secret = [_des3Utils encryptString:raw];
    [[NSUserDefaults standardUserDefaults] setValue:secret forKey:kEAConfigLoginSecret];
}

- (void)setLoginState:(BOOL)loginState
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:loginState] forKey:kEAConfigLoginState];
}

- (BOOL)loginState
{
    NSNumber *stateNum = [[NSUserDefaults standardUserDefaults] objectForKey:kEAConfigLoginState];
    return [stateNum boolValue];
}


@end
