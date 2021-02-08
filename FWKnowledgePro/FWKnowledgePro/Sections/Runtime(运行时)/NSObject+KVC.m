//
//  NSObject+KVC.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/1/28.
//  自定义KVC


/**
 KVC valueForKey (总体规则：先找相关方法，再找相关变量)
 1、先找先关方法：set<Key>、setIs<Key>，如果相关方法找不到往下继续找；
 2、根据accessInstanceVariablesDirectly方法来判断，如果返回NO，直接执行KVC的valueForUndefinedKey（系统抛出一个异常，未定义key）；
 3、根据accessInstanceVariablesDirectly方法来判断，如果返回YES（默认返回的是YES），继续找相关变量（相关变量依次有：_<key>,_is<key>,<key>,is<Key>）；
 */

#import "NSObject+KVC.h"
#import <objc/runtime.h>

@implementation NSObject (KVC)

- (void)fw_setValue:(nullable id)value forKey:(NSString *)key
{
    if (key == nil || key.length == 0) {
        return;
    }
    
    NSString *cKey = key.capitalizedString;
    
    // 1、先找先关方法：set<Key>、setIs<Key>;
    NSString *setKey = [NSString stringWithFormat:@"set%@", cKey];
    if ([self respondsToSelector:NSSelectorFromString(setKey)]) {
        [self performSelector:NSSelectorFromString(setKey) withObject:value];
        return;
    }
    
    NSString *setIsKey = [NSString stringWithFormat:@"setIs%@", cKey];
    if ([self respondsToSelector:NSSelectorFromString(setIsKey)]) {
        [self performSelector:NSSelectorFromString(setIsKey) withObject:value];
        return;
    }
    
    // 2、根据accessInstanceVariablesDirectly方法来判断，如果返回NO，直接执行KVC的valueForUndefinedKey（系统抛出一个异常，未定义key）；
    if (![[self class] accessInstanceVariablesDirectly]) {
        NSException *exception = [NSException exceptionWithName:@"出现异常" reason:@"没找到相关方法" userInfo:nil];
        @throw exception;
        return;
    }
    
    // 3、根据accessInstanceVariablesDirectly方法来判断，如果返回YES（默认返回的是YES），继续找相关变量（相关变量依次有：_<key>,_is<key>,<key>,is<Key>）；
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    NSMutableArray *tmpArray = @[].mutableCopy;
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *varName = ivar_getName(ivar);
        NSString *name = [NSString stringWithUTF8String:varName];
        [tmpArray addObject:name];
    }
    
    for (int i = 0; i < tmpArray.count; i++) {
        NSString *keyName = tmpArray[i];
        if ([keyName isEqualToString:[NSString stringWithFormat:@"_%@", key]]) {
            object_setIvar(self, ivars[i], value);
            free(ivars);
            return;
        }
    }
    
    for (int i = 0; i < tmpArray.count; i++) {
        NSString *keyName = tmpArray[i];
        if ([keyName isEqualToString:[NSString stringWithFormat:@"_is%@", cKey]]) {
            object_setIvar(self, ivars[i], value);
            free(ivars);
            return;
        }
    }
    
    for (int i = 0; i < tmpArray.count; i++) {
        NSString *keyName = tmpArray[i];
        if ([keyName isEqualToString:key]) {
            object_setIvar(self, ivars[i], value);
            free(ivars);
            return;
        }
    }
    
    for (int i = 0; i < tmpArray.count; i++) {
        NSString *keyName = tmpArray[i];
        if ([keyName isEqualToString:[NSString stringWithFormat:@"is%@", cKey]]) {
            object_setIvar(self, ivars[i], value);
            free(ivars);
            return;
        }
    }
    
    [self setValue:value forKey:key];
    free(ivars);
}

@end
