//
//  EACheckUtil.m
//  mobile
//
//  Created by ChenLei on 15/9/23.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "EACheckUtil.h"

@implementation EACheckUtil

+ (BOOL)isMobile:(NSString *)str
{
    NSString *regex = @"^[1][3,4,5,7,8][0-9]{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:str];
}

+ (BOOL)isRightPwd:(NSString *)str
{
    NSString *regex = @"^(?![^a-zA-Z]+$)(?!\\D+$).{6,20}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:str];
}

+ (BOOL)isRightMoney:(NSString *)str
{
    NSString *regex = @"^[0-9]+(.[0-9]{1,2})?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:str];
}

+ (BOOL)isRealName:(NSString *)str
{
    NSString *regex = @"^[\\u4e00-\\u9fa5]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:str];
}

+ (NSString *)checkBankNum:(NSString *)bankNo
{
    if ([bankNo length] < 16 || [bankNo length] > 19) {
        return @"银行卡号长度必须在16到19之间";
    }
    
    NSString *regex = @"[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![predicate evaluateWithObject:bankNo]) {
        return @"银行卡必须全部为数字";
    }
    
    // if (strBin.indexOf(bankno.substring(0, 2)) == -1) {
    // return "银行卡号开头6位不符合规范";
    // }
    
    int lastNum = [[bankNo substringFromIndex:[bankNo length] - 1] intValue];// 取出最后一位（与luhm进行比较）
    
    NSString *first15Num = [bankNo substringToIndex:[bankNo length] - 1];  // 前15或18位
    NSMutableArray<NSString *> *newArr = [[NSMutableArray alloc] init];
    for (int i = (int)[first15Num length] - 1; i >=  0; --i) {  // 倒叙装入newArr
        NSString* num = [first15Num substringWithRange:NSMakeRange(i, 1)];
        [newArr addObject:num];
    }
    
    NSUInteger newArrLen = [newArr count];
   
    int arrSingleNum[newArrLen];// 奇数位*2的积 <9
    int arrSingleNum2[newArrLen];// 奇数位*2的积 >9
    int arrDoubleNum[newArrLen]; // 偶数位数组
    
    for(int mm = 0 ; mm < newArrLen; mm++) {
        arrSingleNum[mm] = 0;
    }
    for(int mm = 0 ; mm < newArrLen; mm++) {
       arrSingleNum2[mm] = 0;
    }
    for(int mm = 0 ; mm < newArrLen; mm++) {
         arrDoubleNum[mm] = 0;
    }
    
    for (int j = 0; j < newArrLen; j++) {
        
        char num = [newArr[j] characterAtIndex:0];
        if ((j + 1) % 2 == 1) {// 奇数位
            if ((int) (num - 48) * 2 < 9)
               arrSingleNum[j] = (num - 48) * 2;
            else
               arrSingleNum2[j] = (num - 48) * 2;
        } else
            // 偶数位
            arrDoubleNum[j] = (num - 48);
    }
    
    int arrSingleNumChild[newArrLen]; // 奇数位*2 >9 的分割之后的数组个位数
    int arrSingleNum2Child[newArrLen];// 奇数位*2 >9 的分割之后的数组十位数
    for(int mm = 0 ; mm < newArrLen; mm++) {
        arrSingleNumChild[mm] = 0;
    }
    for(int mm = 0 ; mm < newArrLen; mm++) {
        arrSingleNum2Child[mm] = 0;
    }

    
    for (int h = 0; h < newArrLen; h++) {
        arrSingleNumChild[h] = arrSingleNum2[h] % 10;
        arrSingleNum2Child[h] =arrSingleNum2[h] / 10;
    }
    
    int sumSingleNum = 0; // 奇数位*2 < 9 的数组之和
    int sumDoubleNum = 0; // 偶数位数组之和
    int sumSingleNumChild = 0; // 奇数位*2 >9 的分割之后的数组个位数之和
    int sumSingleNum2Child = 0; // 奇数位*2 >9 的分割之后的数组十位数之和
    int sumTotal = 0;
    for (int m = 0; m < newArrLen; m++) {
        sumSingleNum = sumSingleNum + arrSingleNum[m] ;
    }
    
    for (int n = 0; n < newArrLen; n++) {
        sumDoubleNum = sumDoubleNum + arrDoubleNum[n];
    }

    for (int p = 0; p < newArrLen; p++) {
        sumSingleNumChild = sumSingleNumChild + arrSingleNumChild[p] ;
        sumSingleNum2Child = sumSingleNum2Child + arrSingleNum2Child[p];
    }
    
    sumTotal = sumSingleNum + sumDoubleNum + sumSingleNumChild + sumSingleNum2Child;

    // 计算Luhm值
    int k = sumTotal % 10 == 0 ? 10 : sumTotal % 10;
    int luhm = 10 - k;

    
    if (lastNum == luhm) {
        return @"true";// 验证通过
    } else {
        return @"银行卡不符合规则";
    }
}

+ (BOOL)validateIDCardNumber:(NSString *)value
{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSUInteger length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year = 0;
    switch (length) {
        case 15:
            year = [[value substringWithRange:NSMakeRange(6,2)] intValue] + 1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch > 0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}

@end
