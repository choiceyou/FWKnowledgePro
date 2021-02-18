//
//  UIView+Swizzing.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/1/27.
//  

#import "UIView+Swizzing.h"
#import <objc/runtime.h>

@implementation UIView (Swizzing)

+ (void)load
{
    Method m1 = class_getInstanceMethod([self class], @selector(setBackgroundColor:));
    Method m2 = class_getInstanceMethod([self class], @selector(fw_setBackgroundColor:));
    method_exchangeImplementations(m1, m2);
}

- (void)fw_setBackgroundColor:(UIColor *)color
{
    if (color == [UIColor whiteColor]) {
        [self fw_setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.99]];
    } else {
        [self fw_setBackgroundColor:color];
    }
}

@end
