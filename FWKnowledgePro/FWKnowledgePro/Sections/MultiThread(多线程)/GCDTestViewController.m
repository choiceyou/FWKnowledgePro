//
//  GCDTestViewController.m
//  MSPro
//
//  Created by xfg on 2020/6/29.
//  Copyright © 2020 xfg. All rights reserved.
//  参考（主要）：https://www.jianshu.com/p/2d57c72016c6
//  参考：https://www.jianshu.com/p/caeebd30a6d2


/**
 GCD：Grand Centeral Dispatch（有人翻译：牛逼的中枢调度器）
 线程安全概念：如果一个数据被多个线程读写，出现的结果是可预见的，那么它就是线程安全的
 
 1、队列：
 （1）串行队列：FIFO先进先出；
 （2）并发队列：
 （3）主列队：dispatch_get_main_queue，属于串行队列；
 （4）全局队列：dispatch_get_global_queue，属于并发队列；
 2、任务：block里面的代码块；
 3、同步：会阻塞当前线程，且不会开辟新线程；
 4、异步：不会阻塞当前线程；
 
 5、死锁
 6、GCD任务执行顺序
 7、栅栏函数：dispatch_barrier_async
 8、队列组：dispatch_group_async
 9、信号量：Dispatch Semaphore
 10、锁的机制：确保只有一条线程在读写数据；锁的作用：保护线程安全；
 （1）semaphore 属于自旋锁：某个线程正在执行我们锁定的代码，那么其他线程就会进入死循环等待；
 （2）synchronized 属于互斥锁：某个线程正在执行我们锁定的代码，那么其他线程就会进入休眠；
 
 --------------------------------------------------------------------------------------------
 |    区别    |          串行队列           |          并发队列        |          主队列         |
 --------------------------------------------------------------------------------------------
 | 同步(sync) | 没有开启新线程，串行执行任务    | 没有开启新线程，串行执行任务 |       死锁卡住不执行     |
 --------------------------------------------------------------------------------------------
 |异步(async) | 有开启新线程(1条)，串行执行任务 |  有开启新线程，并发执行任务  | 没有开启新线程，串行执行任务|
 --------------------------------------------------------------------------------------------
 
 */


#import "GCDTestViewController.h"

@interface GCDTestViewController ()
{
    dispatch_semaphore_t _semaphore;
}

/// 火车票剩余张数
@property (nonatomic, assign) NSUInteger ticketSurplusCount;
/// GCD定时器
@property (nonatomic, strong) dispatch_source_t timer;

@end


@implementation GCDTestViewController

// 使用dispatch_once创建单例
static GCDTestViewController *_instance;

+ (GCDTestViewController *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[GCDTestViewController alloc] init];
    });
    return _instance;
}

// 题外篇：单例创建方法二
//+ (GCDTestViewController *)sharedInstance2
//{
//    @synchronized (self) {
//        if (!_instance) {
//            _instance = [[GCDTestViewController alloc] init];
//        }
//    }
//    return _instance;
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"GCD";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *tmpArray = @[
        @"串行队列 + 同步执行（没有开启新线程，串行执行任务）",
        @"串行队列 + 异步执行（有开启新线程(1条)，串行执行任务）",
        @"并发队列 + 同步执行（没有开启新线程，串行执行任务）",
        @"并发队列 + 异步执行（有开启新线程，并发执行任务）",
        @"主队列 + 同步执行（造成死锁现象）",
        @"主队列 + 异步执行（没有开启新线程，串行执行任务）",
        @"死锁",
        @"线程间通讯",
        @"栅栏方法：dispatch_barrier_sync（会阻塞当前线程）、dispatch_barrier_async(不会阻塞当前线程)",
        @"dispatch_apply（相当于for循环）",
        @"队列组：dispatch_group",
        @"队列组：dispatchGroupWait",
        @"队列组：dispatch_group_enter、dispatch_group_leave",
        @"semaphore 线程同步",
        @"模拟各地异步售卖火车票",
        @"GCD定时器",
    ].mutableCopy;
    
    [self.titleArray addObjectsFromArray:tmpArray];
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            // 串行队列 + 同步执行（没有开启新线程，串行执行任务）
            [self serialSync];
        }
            break;
        case 1: {
            // 串行队列 + 异步执行（有开启新线程(1条)，串行执行任务）
            [self serialAsync];
        }
            break;
        case 2: {
            // 并发队列 + 同步执行（没有开启新线程，串行执行任务）
            [self concurrentSync];
        }
            break;
        case 3: {
            // 并发队列 + 异步执行（有开启新线程，并发执行任务）
            [self concurrentAsync];
        }
            break;
        case 4: {
            // 主队列 + 同步执行（造成死锁现象）
            [self mainQueueSync];
        }
            break;
        case 5: {
            // 主队列 + 异步执行（没有开启新线程，串行执行任务）
            [self mainQueueAsync];
        }
            break;
        case 6: {
            // 死锁
            [self deallock];
        }
            break;
        case 7: {
            // 线程间通讯
            [self threedCommunication];
        }
            break;
        case 8: {
            // 栅栏方法：dispatch_barrier_sync（会阻塞当前线程）、dispatch_barrier_async(不会阻塞当前线程)
            [self barrier];
        }
            break;
        case 9: {
            // dispatch_apply（相当于for循环）
            [self dispatchApply];
        }
            break;
        case 10: {
            // 队列组：dispatch_group
            [self dispatchGroup];
        }
            break;
        case 11: {
            // 队列组：dispatchGroupWait
            [self dispatchGroupWait];
        }
            break;
        case 12: {
            // 队列组：dispatch_group_enter、dispatch_group_leave
            [self groupEnterAndLeave];
        }
            break;
        case 13: {
            // semaphore 线程同步
            [self semaphoreSync];
        }
            break;
        case 14: {
            // 模拟各地异步售卖火车票
            [self initTicketStatus];
        }
            break;
        case 15: {
            [self gcdTimer];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark - 组合实践

#pragma mark 串行队列 + 同步执行（没有开启新线程，串行执行任务）
- (void)serialSync
{
    NSLog(@"serialSync--------Begin");
    dispatch_queue_t queue = dispatch_queue_create("com.xx.serialSync", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        [self task:1 taskCount:1];
    });
    
    dispatch_sync(queue, ^{
        [self task:2 taskCount:1];
    });
    
    dispatch_sync(queue, ^{
        [self task:3 taskCount:1];
    });
    NSLog(@"serialSync--------End");
}

#pragma mark 串行队列 + 异步执行（有开启新线程(1条)，串行执行任务）
- (void)serialAsync
{
    NSLog(@"serialAsync--------Begin");
    dispatch_queue_t queue = dispatch_queue_create("com.xx.serialAsync", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [self task:1 taskCount:1];
    });
    
    dispatch_async(queue, ^{
        [self task:2 taskCount:1];
    });
    
    dispatch_async(queue, ^{
        [self task:3 taskCount:1];
    });
    NSLog(@"serialAsync--------End");
}

#pragma mark 并发队列 + 同步执行（没有开启新线程，串行执行任务）
- (void)concurrentSync
{
    NSLog(@"concurrentSync--------Begin");
    dispatch_queue_t queue = dispatch_queue_create("com.xx.concurrentSync", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        [self task:1 taskCount:1];
    });
    
    dispatch_sync(queue, ^{
        [self task:2 taskCount:1];
    });
    
    dispatch_sync(queue, ^{
        [self task:3 taskCount:1];
    });
    NSLog(@"concurrentSync--------End");
}

#pragma mark 并发队列 + 异步执行（有开启新线程，并发执行任务）
- (void)concurrentAsync
{
    NSLog(@"concurrentAsync--------Begin");
    dispatch_queue_t queue = dispatch_queue_create("com.xx.concurrentAsync", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [self task:1 taskCount:1];
    });
    
    dispatch_async(queue, ^{
        [self task:2 taskCount:1];
    });
    
    dispatch_async(queue, ^{
        [self task:3 taskCount:1];
    });
    NSLog(@"concurrentAsync--------End");
}

#pragma mark 主队列 + 同步执行（造成死锁现象）
- (void)mainQueueSync
{
    NSLog(@"mianQueueSync--------Begin");
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self task:1 taskCount:1];
    });
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self task:2 taskCount:1];
    });
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self task:3 taskCount:1];
    });
    NSLog(@"mianQueueSync--------End");
}

#pragma mark 主队列 + 异步执行（没有开启新线程，串行执行任务）
- (void)mainQueueAsync
{
    NSLog(@"mainQueueAsync--------Begin");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self task:1 taskCount:1];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self task:2 taskCount:1];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self task:3 taskCount:1];
    });
    NSLog(@"mainQueueAsync--------End");
}


#pragma mark -
#pragma mark - 其它实践

#pragma mark 死锁
- (void)deallock
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"deallock");
    });
    
    dispatch_queue_t queue = dispatch_queue_create("com.xx.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{    // 异步执行 + 串行队列
        dispatch_sync(queue, ^{  // 同步执行 + 当前串行队列
            // 追加任务 1
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        });
    });
}

#pragma mark 线程间通讯
- (void)threedCommunication
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        [self task:11];
        dispatch_async(mainQueue, ^{
            NSLog(@"刷新UI");
        });
    });
}

#pragma mark 栅栏方法：dispatch_barrier_sync（会阻塞当前线程）、dispatch_barrier_async(不会阻塞当前线程)
- (void)barrier
{
    NSLog(@"barrier--------Begin");
    dispatch_queue_t queue = dispatch_queue_create("com.xx.barrierTest", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        [self task:1 taskCount:3];
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"执行栅栏方法");
    });
    
    dispatch_async(queue, ^{
        [self task:2 taskCount:4];
    });
    
    NSLog(@"barrier--------End");
}

#pragma mark dispatch_apply（相当于for循环）
- (void)dispatchApply
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"dispatchApply---begin");
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"===== count：%zu 当前线程：%@", index, [NSThread currentThread]);
    });
    NSLog(@"dispatchApply---end");
}

#pragma mark 队列组：dispatch_group
- (void)dispatchGroup
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.xx.dispatchGroup", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_async(group, queue, ^{
        [self task:1 taskCount:2];
    });
    
    dispatch_group_async(group, queue, ^{
        [self task:2 taskCount:3];
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"异步任务全部执行完成通知");
    });
}

#pragma mark 队列组：dispatchGroupWait
- (void)dispatchGroupWait
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.xx.dispatchGroupWait", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_async(group, queue, ^{
        [self task:1 taskCount:2];
    });
    
    dispatch_group_async(group, queue, ^{
        [self task:2 taskCount:3];
    });
    
    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"打印看一下");
}

#pragma mark 队列组：dispatch_group_enter、dispatch_group_leave
- (void)groupEnterAndLeave
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.xx.groupEnterAndLeave", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self task:1 taskCount:2];
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [self task:2 taskCount:3];
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"异步任务全部执行完成通知");
    });
}

#pragma mark semaphore 线程同步
- (void)semaphoreSync
{
    NSLog(@"semaphoreSync---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("com.xx.semaphoreSync", DISPATCH_QUEUE_CONCURRENT);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block int number = 0;
    dispatch_async(queue, ^{
        [self task:22 taskCount:5];
        number = 100;
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    NSLog(@"number = %d", number);
    NSLog(@"semaphoreSync---end");
}

#pragma mark 模拟各地异步售卖火车票
- (void)initTicketStatus
{
    self.ticketSurplusCount = 50;
    _semaphore = dispatch_semaphore_create(1);
    
    dispatch_queue_t queue1 = dispatch_queue_create("com.xx.fuzhou", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue1, ^{
        [self saleTicket];
    });
    
    dispatch_queue_t queue2 = dispatch_queue_create("com.xx.xiamen", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue2, ^{
        [self saleTicket];
    });
}

#pragma mark 模拟火车票售卖
- (void)saleTicket
{
    while (1) {
        // 信号量-1（信号总量小于 0 时就会一直等待，阻塞所在线程），相当于加锁
        dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        
        if (self.ticketSurplusCount > 0) {
            self.ticketSurplusCount --;
            NSLog(@"===== ticketSurplusCount：%ld 当前线程：%@", self.ticketSurplusCount, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.3];
        } else {
            NSLog(@"火车票已售完");
            // 信号量+1，相当于解锁
            dispatch_semaphore_signal(_semaphore);
            break;
        }
        
        // 信号量+1，相当于解锁
        dispatch_semaphore_signal(_semaphore);
    }
}

#pragma mark GCD定时器
- (void)gcdTimer
{
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        NSLog(@"-----%@", [NSThread currentThread]);
    });
    
    dispatch_resume(self.timer);
}


#pragma mark -
#pragma mark - Other

- (void)task:(int)tag
{
    [self task:tag taskCount:2];
}

- (void)task:(int)tag taskCount:(int)taskCount
{
    for (int i = 0; i < taskCount; i++) {
        [NSThread sleepForTimeInterval:1]; // 模拟耗时操作
        NSLog(@"===== tag：%d 当前线程：%@", tag, [NSThread currentThread]); // 打印当前线程
    }
}

@end
