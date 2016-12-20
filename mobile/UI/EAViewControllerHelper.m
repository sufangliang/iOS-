//
//  EAViewControllerHelper.m
//  mobile
//
//  Created by kevin on 15/11/18.
//  Copyright © 2015年 edaga. All rights reserved.
//

#import "EAViewControllerHelper.h"
#import "EABaseWebViewController.h"


@implementation EAViewControllerHelper

+ (UIViewController*)findViewController:(EAPageName)pageName inViewControllers:(NSArray*)viewControllers{
    if(!viewControllers) {
        return nil;
    }
    
    NSEnumerator *enumerator = [viewControllers reverseObjectEnumerator];
    id obj = nil;
    SEL isPageSel = @selector(isPage:);
    while(obj = [enumerator nextObject]){
        if([obj respondsToSelector:isPageSel] && [obj isPage:pageName]) {
            return obj;
        }
    }
    return nil;
}

+ (UIViewController*)prevViewController:(NSArray*)viewControllers {
    if(!viewControllers) {
        return nil;
    }
    
    NSUInteger count = [viewControllers count];
    if(count <2) {
        return nil;
    }
    
    return [viewControllers objectAtIndex:count - 1];
}

+ (UIViewController*)prevViewControllerWithPageName:(EAPageName)pageName inViewControllers:(NSArray*)viewControllers {
    if(!viewControllers) {
        return nil;
    }
    
    NSUInteger count = [viewControllers count];
    if(count <2) {
        return nil;
    }
    
    id prev = [viewControllers objectAtIndex:count - 2];
    SEL isPageSel = @selector(isPage:);
    if([prev respondsToSelector:isPageSel] && [prev isPage:pageName]) {
        return prev;
    }
    return nil;
}

@end
