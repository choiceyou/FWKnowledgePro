//
//  NSObject+Singleton.m
//  FWKnowledgePro
//
//  Created by xfg on 2019/11/26.
//

#import "NSObject+Singleton.h"

@implementation NSObject (Singleton)

static NSMutableDictionary *singletonDict;
id instance;

+ (instancetype)sharedInstance
{
    @synchronized (self) {
        if (!singletonDict) {
            singletonDict = @{}.mutableCopy;
        }
        NSString *className = NSStringFromClass([self class]);
        if (className) {
            // 查找字典中该类的对象,使用类名去进行查找，可以确保一个类只被存储一次
            instance = singletonDict[className];
            if (!instance) {
                // 实例化，并存储
                instance = [[self.class alloc] init];
                [singletonDict setObject:instance forKey:className];
            }
        } else {
            // 没有获取类名，所以确保sharedInstance是一个类方法，用类进行调用
        }
        return instance;
    }
}

+ (void)releaseInstance
{
    NSString *className = NSStringFromClass([self class]);
    if (className) {
        // 查找字典中该类的对象,使用类名去进行查找
        instance = singletonDict[className];
        if (instance) {
            [singletonDict removeObjectForKey:className];
        }
    }
}

@end
