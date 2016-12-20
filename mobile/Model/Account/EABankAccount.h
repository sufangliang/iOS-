//
//  EABankAccount.h
//  mobile
//
//  Created by ChenLei on 15/9/19.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EABankAccount : NSObject

@property(nonatomic) int aId;
@property(nonatomic, strong) NSString *bankAccount;
@property(nonatomic, strong) NSString *bankName;
@property(nonatomic, strong) NSString *bankFullNAME;

- (void)parseJsonString:(NSString *)jsonStr;
- (NSString *)jsonString;

@end

