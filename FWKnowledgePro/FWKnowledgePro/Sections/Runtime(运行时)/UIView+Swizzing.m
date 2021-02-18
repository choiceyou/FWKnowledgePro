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
    // 类簇（如：NSString、NSArray、NSDictionary ）的真实类型可能是其它，如：
    //    NSMutableArray *array = @[].mutableCopy;
    //    NSLog(@"%@", [array class]); // 结果为：__NSArrayM
    // 因此：传入第一个参数时需要特别注意
    
    Method m1 = class_getInstanceMethod(self, @selector(setBackgroundColor:));
    Method m2 = class_getInstanceMethod(self, @selector(fw_setBackgroundColor:));
    // 一旦调用这个方法，会去清空方法缓存
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
