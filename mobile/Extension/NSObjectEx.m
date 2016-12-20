//
//  NSObjectEx.m
//  sesamelife
//
//  Created by ChenLei on 15/6/2.
//  Copyright (c) 2015年 eggplant. All rights reserved.
//

#import "NSObjectEx.h"

@implementation NSObject (eggplant)

- (NSString *)epString
{
    if ([self isKindOfClass:[NSString class]])
        return (NSString *)self;
    else if ([self isKindOfClass:[NSNumber class]])
        return [(NSNumber *)self stringValue];
    else
        return nil;
}

- (NSDictionary *)epDictionary
{
    if ([self isKindOfClass:[NSDictionary class]])
        return (NSDictionary *)self;
    else
        return nil;
}

- (NSArray *)epArray
{
    if ([self isKindOfClass:[NSArray class]])
        return (NSArray *)self;
    else
        return nil;
}

- (int64_t)epInt64
{
    if ([self isKindOfClass:[NSString class]])
        return [(NSString *)self longLongValue];
    else if ([self isKindOfClass:[NSNumber class]])
        return [(NSNumber *)self longLongValue];
    else
        return 0;
}

- (int)epInt
{
    if ([self isKindOfClass:[NSString class]])
        return [(NSString *)self intValue];
    else if ([self isKindOfClass:[NSNumber class]])
        return [(NSNumber *)self intValue];
    else
        return 0;
}

- (double)epDouble
{
    if ([self isKindOfClass:[NSString class]])
        return [(NSString *)self doubleValue];
    else if ([self isKindOfClass:[NSNumber class]])
        return [(NSNumber *)self doubleValue];
    else
        return 0;
}

- (float)epFloat
{
    if ([self isKindOfClass:[NSString class]])
        return [(NSString *)self floatValue];
    else if ([self isKindOfClass:[NSNumber class]])
        return [(NSNumber *)self floatValue];
    else
        return 0;
}

@end
