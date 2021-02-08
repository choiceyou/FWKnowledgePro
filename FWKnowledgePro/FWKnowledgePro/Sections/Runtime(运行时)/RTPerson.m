//
//  RTPerson.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/1/27.
//

#import "RTPerson.h"
#import <objc/runtime.h>

@implementation RTPerson

#pragma mark 编码
- (void)encodeWithCoder:(nonnull NSCoder *)coder
{
    unsigned int count = 0;
    // 1.获取所有的实例变量
    Ivar *ivars = class_copyIvarList([RTPerson class], &count);
    
    // 2.遍历
    for (int i = 0; i < count; i++) {
        Ivar var = ivars[i];
        char const *name = ivar_getName(var);
        NSString *key = [NSString stringWithUTF8String:name];
        // 3.通过kvc的方式取值
        id value = [self valueForKey:key];
        // 4.编码
        [coder encodeObject:value forKey:key];
    }
    
    // 5.copy create alloc 是在堆开辟内存空间，不使用的时候需要手动释放
    free(ivars);
}

#pragma mark 解码
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder
{
    self = [super init];
    if (self) {
        unsigned int count = 0;
        // 1.获取所有的实例变量
        Ivar *ivars = class_copyIvarList([RTPerson class], &count);
        
        // 2.遍历
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            char const *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            // 3.解码
            id value = [coder decodeObjectForKey:key];
            // 4.通过kvc的方式赋值
            [self setValue:value forKey:key];
        }
        // 5.copy create alloc 是在堆开辟内存空间，不使用的时候需要手动释放
        free(ivars);
    }
    return self;
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
