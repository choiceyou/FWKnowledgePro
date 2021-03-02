//
//  OSUnfairLockDemo.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/3/1.
//

#import "OSUnfairLockDemo.h"
#import <os/lock.h>

API_AVAILABLE(ios(10.0))
@interface OSUnfairLockDemo ()
{
    os_unfair_lock _ticketLock;
    os_unfair_lock _moneyLock;
}

@end

@implementation OSUnfairLockDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (@available(iOS 10.0, *)) {
            _ticketLock = OS_UNFAIR_LOCK_INIT;
            _moneyLock = OS_UNFAIR_LOCK_INIT;
        }
    }
    return self;
}


#pragma mark -
#pragma mark - 线程同步演示：卖票

#pragma mark 卖票过程
- (void)saleTicket
{
    if (@available(iOS 10.0, *)) {
        os_unfair_lock_lock(&_ticketLock);
        
        [super saleTicket];
        
        os_unfair_lock_unlock(&_ticketLock);
    }
}


#pragma mark -
#pragma mark - 线程同步演示：存钱、取钱

#pragma mark 存钱
- (void)saveMoney
{
    if (@available(iOS 10.0, *)) {
        os_unfair_lock_lock(&_moneyLock);
        
        [super saveMoney];
        
        os_unfair_lock_unlock(&_moneyLock);
    }
}

#pragma mark 取钱
- (void)withDrawMoney
{
    if (@available(iOS 10.0, *)) {
        os_unfair_lock_lock(&_moneyLock);
        
        [super withDrawMoney];
        
        os_unfair_lock_unlock(&_moneyLock);
    }
}

@end
