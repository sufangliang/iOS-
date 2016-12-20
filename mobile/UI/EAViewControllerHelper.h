//
//  EAViewControllerHelper.h
//  mobile
//
//  Created by kevin on 15/11/18.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EABaseModel.h"

@interface EAViewControllerHelper : NSObject

+ (UIViewController*)findViewController:(EAPageName)pageName inViewControllers:(NSArray*)viewControllers;

+ (UIViewController*)prevViewController:(NSArray*)viewControllers;

+ (UIViewController*)prevViewControllerWithPageName:(EAPageName)pageName inViewControllers:(NSArray*)viewControllers;

@end
