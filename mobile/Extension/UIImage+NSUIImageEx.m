//
//  UIImage+NSUIImageEx.m
//  mobile
//
//  Created by kevin on 15/10/28.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "UIImage+NSUIImageEx.h"

@implementation UIImage (NSUIImageEx)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size

{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
