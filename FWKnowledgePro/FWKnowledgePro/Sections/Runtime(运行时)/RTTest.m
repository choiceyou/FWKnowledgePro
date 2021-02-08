//
//  RTTest.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/1/28.
//

#import "RTTest.h"
#import <objc/runtime.h>

@implementation RTTest

- (void)test
{
    NSLog(@"测试一下");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if ([NSStringFromSelector(sel) isEqualToString:@"test2:"]) {
        return class_addMethod(self, sel, (IMP)customTest2, "v@:@");
    }
    return [super resolveInstanceMethod:sel];
}

void customTest2(id self, SEL _cmd, id param) {
    NSLog(@"customTest2：%@", param);
}

@end
