//
//  Singleton.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/11/26.
//

#import "Singleton.h"

@implementation Singleton

static Singleton *_instance = nil;
static dispatch_once_t onceToken;

// 方法一
+ (Singleton *)sharedInstance
{
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

// 方法二
//+ (Singleton *)sharedInstance
//{
//    @synchronized (self) {
//        if (!_instance) {
//            _instance = [[self alloc] init];
//        }
//        return _instance;
//    }
//}


#pragma mark 释放单例
+ (void)releaseInstance
{
    onceToken = 0;
    _instance = nil;
}

@end
