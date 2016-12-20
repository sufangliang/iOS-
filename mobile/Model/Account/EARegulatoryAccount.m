//
//  EARegulatoryAccount.m
//  mobile
//
//  Created by kevin on 15/10/20.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "EARegulatoryAccount.h"
#import "NSObjectEx.h"

@implementation EARegulatoryAccount

- (void)parseJsonString:(NSString *)jsonStr
{
    if ([jsonStr length] == 0)
    return;
    
    NSError *error;
    NSDictionary *jsonInfo = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                                             options:NSJSONReadingMutableContainers
                                                               error:&error];
    
    self.aId = [jsonInfo[@"id"] epInt];
    self.accountsBalance = [jsonInfo[@"ACCOUNTS_BALANCE"] epDouble];
    self.applyFrozenAmount = [jsonInfo[@"APPLY_FROZEN_AMOUNT"] epDouble];
    self.useBalance = [jsonInfo[@"USE_BALANCE"] epDouble];
    self.withdrawFrozenAmount = [jsonInfo[@"WITHDRAW_FROZEN_AMOUNT"] epDouble];
    self.havePayPwd = [jsonInfo[@"HAVE_PAY_PWD"] epDouble];
    self.learnFrozenAmount = [jsonInfo[@"LEARN_FROZEN_AMOUNT"] epDouble];
    self.learnBalance = [jsonInfo[@"LEARN_BALANCE"] epDouble];

}

- (NSString *)jsonString
{
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    infoDic[@"id"] = @(self.aId);
    infoDic[@"ACCOUNTS_BALANCE"] = @(self.accountsBalance);
    infoDic[@"ACCOUNTS_BALANCE"] = @(self.applyFrozenAmount);
    infoDic[@"USE_BALANCE"] = @(self.useBalance);
    infoDic[@"WITHDRAW_FROZEN_AMOUNT"] = @(self.withdrawFrozenAmount);
    infoDic[@"HAVE_PAY_PWD"] = @(self.havePayPwd);
    infoDic[@"LEARN_FROZEN_AMOUNT"] = @(self.learnFrozenAmount);
    infoDic[@"LEARN_BALANCE"] = @(self.learnBalance);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
