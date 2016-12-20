//
//  EAStringUtil.m
//  mobile
//
//  Created by kevin on 15/10/21.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "EAStringUtil.h"

@implementation EAStringUtil

+(NSString *)encodeToPercentEscapeString: (NSString *) input
{

    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)input,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8));
    return outputStr;
}

+(NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+(BOOL)isBlank:(NSString *)input
{
    if(!input || input.length == 0) {
        return YES;
    }
    
    return NO;
}

+(BOOL)isBlankIncludeNull:(NSString*)input {
    BOOL result = [EAStringUtil isBlank:input];
    if(!result) {
        result = [input compare:@"null"
                        options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame;
    }
    return result;
}

@end
