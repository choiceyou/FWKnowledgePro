//
//  OSSpinLockDemo.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/2/20.
//

#import "OSSpinLockDemo.h"
#import <libkern/OSAtomic.h>

@interface OSSpinLockDemo ()
{
    // ios10后已经不建议使用
    OSSpinLock _lock;
    OSSpinLock _lock2;
}

@end


@implementation OSSpinLockDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lock = OS_SPINLOCK_INIT;
        _lock2 = OS_SPINLOCK_INIT;
    }
    return self;
}


#pragma mark -
#pragma mark - 线程同步演示：卖票

#pragma mark 卖票过程
- (void)saleTicket
{
    OSSpinLockLock(&_lock);
    
    [super saleTicket];
    
    OSSpinLockUnlock(&_lock);
}


#pragma mark -
#pragma mark - 线程同步演示：存钱、取钱

#pragma mark 存钱
- (void)saveMoney
{
    OSSpinLockLock(&_lock2);
    
    [super saveMoney];
    
    OSSpinLockUnlock(&_lock2);
}

#pragma mark 取钱
- (void)withDrawMoney
{
    OSSpinLockLock(&_lock2);
    
    [super withDrawMoney];
    
    OSSpinLockUnlock(&_lock2);
}

@end
