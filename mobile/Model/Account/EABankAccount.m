//
//  EABankAccount.m
//  mobile
//
//  Created by ChenLei on 15/9/19.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "EABankAccount.h"
#import "NSObjectEx.h"

@implementation EABankAccount

- (void)parseJsonString:(NSString *)jsonStr
{
    if ([jsonStr length] == 0)
        return;
    
    NSError *error;
    NSDictionary *jsonInfo = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                                             options:NSJSONReadingMutableContainers
                                                               error:&error];
    
    self.aId = [jsonInfo[@"id"] epInt];
    self.bankAccount = [jsonInfo[@"BANK_ACCOUNT"] epString];
    self.bankName = [jsonInfo[@"BANK_NAME"] epString];
    self.bankFullNAME = [jsonInfo[@"BANK_FULL_NAME"] epString];
}

- (NSString *)jsonString
{
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    infoDic[@"id"] = @(self.aId);
    if (self.bankAccount)
        infoDic[@"BANK_ACCOUNT"] = self.bankAccount;
    if (self.bankName)
        infoDic[@"BANK_NAME"] = self.bankName;
    if (self.bankFullNAME)
        infoDic[@"BANK_FULL_NAME"] = self.bankFullNAME;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDic
                                                       options:0
                                                         error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end
