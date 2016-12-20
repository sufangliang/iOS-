//
//  EALogFormater.m
//  mobile
//
//  Created by kevin on 15/11/4.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "EALogFormater.h"

@implementation EALogFormater

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString *logLevel = nil;
    switch (logMessage->_level)
    {
        case DDLogFlagError:
            logLevel = @"[ERROR]:";
            break;
        case DDLogLevelWarning:
            logLevel = @"[WARN]:";
            break;
        case DDLogLevelInfo:
            logLevel = @"[INFO]:";
            break;
        case DDLogLevelDebug:
            logLevel = @"[DEBUG]:";
            break;
        default:
            logLevel = @"[VBOSE]:";
            break;
    }
    
    NSString *formatStr = [NSString stringWithFormat:@"%@ %@ [line %lu] (%@ -> %@)", logLevel, logMessage->_message, (unsigned long)logMessage->_line, logMessage->_function, logMessage.fileName];
    return formatStr;
}

@end
