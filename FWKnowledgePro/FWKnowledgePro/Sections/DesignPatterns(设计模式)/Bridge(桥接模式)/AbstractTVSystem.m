//
//  AbstractTVSystem.m
//  FWKnowledgePro
//
//  Created by xfg on 2019/12/1.
//

#import "AbstractTVSystem.h"

@implementation AbstractTVSystem

- (instancetype)initWith:(id<AbstractTVProtocol>)system;
{
    self = [super init];
    if (self) {
        _tvSystem = system;
    }
    return self;
}

- (void)onOff
{
    // 抽象方法
}

- (void)nextChannel
{
    // 抽象方法
}

- (void)preChannel
{
    // 抽象方法
}

@end
