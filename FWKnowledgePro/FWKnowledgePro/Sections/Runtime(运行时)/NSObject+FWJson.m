//
//  NSObject+FWJson.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/2/18.
//

#import "NSObject+FWJson.h"
#import <objc/message.h>

@implementation NSObject (FWJson)

#pragma mark 字典转模型
+ (instancetype)fw_objectWithJson:(NSDictionary *)dict
{
    id objct = [[self alloc] init];
    for (NSString *key in dict.allKeys) {
        NSString *methodName = [NSString stringWithFormat:@"set%@:", key.capitalizedString];
        SEL sel = sel_registerName(methodName.UTF8String);
        id value = [dict objectForKey:key];
        if (sel) {
            ((void (*)(id, SEL, id))objc_msgSend)(objct, sel, value);
        }
    }
    return objct;
}

#pragma mark 模型转字典
- (NSMutableDictionary *)fw_dictWithObjec
{
    NSMutableDictionary *dict = @{}.mutableCopy;
    
    /**
     这边没有写完整，其实还有很多细节需要处理，如：
     1、需要循环处理获取所有父类的成员变量；
     2、处理字典key与成员变量名字不相同的情况；
     3、还有模型里面嵌套模型；
     等等。。。
     */
    
    // 方案一
    unsigned int count;
    objc_property_t * properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        SEL sel = sel_registerName(name);
        if (sel) {
            id value = ((id (*)(id, SEL))objc_msgSend)(self, sel);
            if (value) {
                dict[propertyName] = value;
            } else {
                dict[propertyName] = @"test";
            }
        }
    }
    free(properties);
    
    // 方案二
//    Ivar *ivars = class_copyIvarList([self class], &count);
//    for (int i = 0; i < count; i++) {
//        Ivar ivar = ivars[i];
//        const char *name = ivar_getName(ivar);
//        NSString *ivarName = [NSString stringWithUTF8String:name];
//        id value = [self valueForKey:ivarName];
//        if (value) {
//            dict[[ivarName substringFromIndex:1]] = value;
//        }
//    }
//    free(ivars);
    
    return dict;
}

@end
