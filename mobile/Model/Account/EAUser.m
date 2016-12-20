//
//  EAUser.m
//  mobile
//
//  Created by ChenLei on 15/9/19.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "EAUser.h"
#import "NSObjectEx.h"

@implementation EAUser

- (void)parseJsonString:(NSString *)jsonStr
{
    if ([jsonStr length] == 0)
        return;
    
    NSError *error;
    NSDictionary *jsonInfo = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                                             options:NSJSONReadingMutableContainers
                                                               error:&error];
    
    self.uid = [jsonInfo[@"id"] epInt];
    self.loginName = [jsonInfo[@"LOGIN_NAME"] epString];
    self.name = [jsonInfo[@"NAME"] epString];
    self.mobile = [jsonInfo[@"MOBILE"] epString];
    self.idCard = [jsonInfo[@"ID_CARD"] epString];
    self.idCardStatus = [jsonInfo[@"ID_CARD_STATUS"] epInt];
}

- (NSString *)jsonString
{
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    infoDic[@"id"] = @(self.uid);
    if (self.loginName)
        infoDic[@"LOGIN_NAME"] = self.loginName;
    if (self.name)
        infoDic[@"NAME"] = self.name;
    if (self.mobile)
        infoDic[@"MOBILE"] = self.mobile;
    if (self.idCard)
        infoDic[@"ID_CARD"] = self.idCard;
    infoDic[@"ID_CARD_STATUS"] = @(self.idCardStatus);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDic
                                                       options:0
                                                         error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
