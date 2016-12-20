//
//  EAStringUtil.h
//  mobile
//
//  Created by kevin on 15/10/21.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EAStringUtil : NSObject


+ (NSString *)encodeToPercentEscapeString: (NSString *) input;

+ (NSString *)decodeFromPercentEscapeString: (NSString *) input;

+ (BOOL)isBlank:(NSString *)input;

+ (BOOL)isBlankIncludeNull:(NSString*)input;

@end
