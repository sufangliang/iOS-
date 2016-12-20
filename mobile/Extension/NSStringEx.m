//
//  NSStringEx.m
//  sesamelife
//
//  Created by ChenLei on 15/5/13.
//  Copyright (c) 2015年 eggplant. All rights reserved.
//

#import "NSStringEx.h"
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"

/*** MD5 ***/
#define CC_MD5_DIGEST_LENGTH    16          /* digest length in bytes */

@implementation NSString (eggplant)

- (NSString*)md5
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    const char *cstr = [self UTF8String];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

- (NSString *)base64String
{
    if ([self length] == 0)
        return self;
    
    return [GTMBase64 encodeBase64String:self];
}

- (NSString *)base64DecodeString
{
    if ([self length] == 0)
        return self;
    
    return [GTMBase64 decodeBase64String:self];
}

- (NSString *)URLEncodedString {
    // NSURL's stringByAddingPercentEscapesUsingEncoding: does not escape
    // some characters that should be escaped in URL parameters, like / and ?;
    // we'll use CFURL to force the encoding of those
    //
    // We'll explicitly leave spaces unescaped now, and replace them with +'s
    //
    // Reference: <a href="%5C%22http://www.ietf.org/rfc/rfc3986.txt%5C%22" target="\"_blank\"" onclick='\"return' checkurl(this)\"="" id="\"url_2\"">http://www.ietf.org/rfc/rfc3986.txt</a>
    
    NSString *resultStr = self;
    
    CFStringRef originalString = (__bridge CFStringRef) self;
    CFStringRef leaveUnescaped = CFSTR(" ");
    CFStringRef forceEscaped = CFSTR("!*'();:@&=+$,/?%#[]");
    CFStringRef escapedStr;
    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                         originalString,
                                                         leaveUnescaped,
                                                         forceEscaped,
                                                         kCFStringEncodingUTF8);
    
    if( escapedStr ) {
        NSMutableString *mutableStr = [NSMutableString stringWithString:(__bridge NSString *)escapedStr];
        CFRelease(escapedStr);
        
        // replace spaces with plusses
        [mutableStr replaceOccurrencesOfString:@" "
                                    withString:@"%20"
                                       options:0
                                         range:NSMakeRange(0, [mutableStr length])];
        resultStr = mutableStr;
    }
    return resultStr;
}

+ (NSString *)formatStarMobile:(NSString *)raw
{
    if ([raw length] < 11)
        return @"";
    NSString *ret = [raw substringWithRange:NSMakeRange(0, 3)];
    ret = [ret stringByAppendingFormat:@"****%@", [raw substringFromIndex:7]];
    return ret;
}


- (BOOL)isPureInt
{
    if ([self length] == 0)
        return NO;
    
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (CGSize)epSizeForFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    if ([self length] == 0)
        return CGSizeZero;
    
    NSDictionary * attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize epSize = [self boundingRectWithSize:size
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attributes
                                    context:nil].size;
    
    return epSize;
}

- (BOOL)containsStringEx:(NSString *)str {
    if (IOS8_OR_LATER) {
        return [self containsString:str];
    } else {
        NSRange range = [self rangeOfString:str];
        return range.length != 0;
    }
}

- (BOOL)isPureNumandCharacters
{
    NSString *temp = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(temp.length > 0)
    {
        return NO;
    }
    return YES;
}

@end
