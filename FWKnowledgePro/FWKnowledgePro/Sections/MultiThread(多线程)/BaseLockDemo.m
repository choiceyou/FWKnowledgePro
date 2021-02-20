//
//  BaseLockDemo.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/2/20.
//

#import "BaseLockDemo.h"

@interface BaseLockDemo ()

@property (nonatomic, assign) int money;
@property (nonatomic, assign) int ticketsCount;

@end


@implementation BaseLockDemo

#pragma mark -
#pragma mark - 线程同步演示：卖票

#pragma mark 卖票演示
- (void)ticketTest
{
    self.ticketsCount = 15;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self saleTicket];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self saleTicket];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self saleTicket];
        }
    });
}

#pragma mark 卖票过程
- (void)saleTicket
{
    int oldTicketCount = self.ticketsCount;
    sleep(.5);
    oldTicketCount--;
    self.ticketsCount = oldTicketCount;
    
    NSLog(@"还剩%d张票 - %@", oldTicketCount, [NSThread currentThread]);
}


#pragma mark -
#pragma mark - 线程同步演示：存钱、取钱

#pragma mark 存钱、取钱演示
- (void)moneyTest
{
    self.money = 100;
    dispatch_queue_t queue = dispatch_queue_create("com.xx.saveMoney", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("com.xx.drawMoney", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self saveMoney];
        }
    });
    
    dispatch_async(queue2, ^{
        for (int i = 0; i < 10; i++) {
            [self withDrawMoney];
        }
    });
}

#pragma mark 存钱
- (void)saveMoney
{
    int oldMoney = self.money;
    sleep(.5);
    oldMoney += 50;
    self.money = oldMoney;
    
    NSLog(@"存50，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

#pragma mark 取钱
- (void)withDrawMoney
{
    int oldMoney = self.money;
    sleep(.5);
    oldMoney -= 20;
    self.money = oldMoney;
    
    NSLog(@"取20，还剩%d元 - %@", oldMoney, [NSThread currentThread]);
}

@end
