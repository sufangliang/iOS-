//
//  EAUser.h
//  mobile
//
//  Created by ChenLei on 15/9/19.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EAUser : NSObject

@property(nonatomic) int uid;
@property(nonatomic, strong) NSString *loginName;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *mobile;
@property(nonatomic, strong) NSString *idCard;
@property(nonatomic) int idCardStatus;

- (void)parseJsonString:(NSString *)jsonStr;
- (NSString *)jsonString;

@end
