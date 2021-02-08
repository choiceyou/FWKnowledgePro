//
//  HMSingleton.m
//  FWKnowledgePro
//
//  Created by xfg on 2019/11/26.
//

#import "HMSingleton.h"

@implementation HMSingleton

static id _instance;

/// 当类加载到OC运行时环境中（内存），就会调用一次（一个类只会加载1次）
+ (void)load
{
    _instance = [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (!_instance) {
        _instance = [super allocWithZone:zone];
    }
    return _instance;
}

+ (HMSingleton *)sharedInstance
{
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

@end
