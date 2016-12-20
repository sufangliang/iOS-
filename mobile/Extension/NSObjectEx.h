//
//  NSObjectEx.h
//  sesamelife
//
//  Created by ChenLei on 15/6/2.
//  Copyright (c) 2015年 eggplant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (eggplant)

// ------------- network protocol ---------------
// 从网络协议出来的数据需要进行类型判断，以下接口用于类型判断

- (NSString *)epString;

- (NSDictionary *)epDictionary;

- (NSArray *)epArray;

- (int64_t)epInt64;

- (int)epInt;

- (double)epDouble;

- (float)epFloat;

@end
