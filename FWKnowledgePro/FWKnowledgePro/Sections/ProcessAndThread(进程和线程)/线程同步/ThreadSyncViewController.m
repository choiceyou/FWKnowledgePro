//
//  ThreadSyncViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/2/20.
//

/**
 锁的机制：确保只有一条线程在读写数据；锁的作用：保护线程安全；
 （1）semaphore 属于自旋锁：某个线程正在执行我们锁定的代码，那么其他线程就会进入死循环等待；
 （2）synchronized 属于互斥锁：某个线程正在执行我们锁定的代码，那么其他线程就会进入休眠；
 
 递归锁：允许同一个线程对一把锁进行重复加锁；
 
 
 */

#import "ThreadSyncViewController.h"
#import "OSSpinLockDemo.h"

@interface ThreadSyncViewController ()

@property (nonatomic, strong) OSSpinLockDemo *spinLockDemo;

@end


@implementation ThreadSyncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"iOS中线程同步方案";
    
    NSMutableArray *tmpArray = @[
        @"OSSpinLock（自旋锁） - 卖票",
        @"OSSpinLock（自旋锁） - 存钱、取钱",
    ].mutableCopy;
    
    [self.titleArray addObjectsFromArray:tmpArray];
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            [self.spinLockDemo ticketTest];
        }
            break;
        case 1: {
            [self.spinLockDemo moneyTest];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark - GET/SET

- (OSSpinLockDemo *)spinLockDemo
{
    if (!_spinLockDemo) {
        _spinLockDemo = [[OSSpinLockDemo alloc] init];
    }
    return _spinLockDemo;
}

@end
