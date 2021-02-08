//
//  RTPerson2.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/1/27.
//

#import "RTPerson2.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation RTPerson2

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        for (NSString *key in dict.allKeys) {
            id value = dict[key];
            NSString *methodName = [NSString stringWithFormat:@"set%@:", key.capitalizedString];
            SEL sel = NSSelectorFromString(methodName);
            if (sel) {
                ((void (*)(id, SEL, id))objc_msgSend)(self, sel, value);
            }
        }
    }
    return self;
}

- (NSDictionary *)modelToDict
{
    unsigned int count = 0;
    
    // 方法一
    //    Ivar *ivars = class_copyIvarList([RTPerson2 class], &count);
    //    for (int i = 0; i < count; i++) {
    //        Ivar ivar = ivars[i];
    //        char const *name = ivar_getName(ivar);
    //        NSString *key = [NSString stringWithUTF8String:name];
    //        id value = [self valueForKey:key];
    //    }
    
    // 方法二
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    if (count != 0) {
        NSMutableDictionary *tmpDict = @{}.mutableCopy;
        for (int i = 0; i <count; i++) {
            const char *propertyName = property_getName(properties[i]);
            NSString *name = [NSString stringWithUTF8String:propertyName];
            SEL sel = NSSelectorFromString(name);
            if (sel) {
                id value = ((id (*)(id, SEL))objc_msgSend)(self, sel);
                if (value) {
                    tmpDict[name] = value;
                } else {
                    tmpDict[name] = @"test";
                }
            }
        }
        free(properties);
        return tmpDict;
    }
    
    free(properties);
    return nil;
}

@end
