//
//  GCDTestViewController.m
//  MSPro
//
//  Created by xfg on 2020/6/29.
//  Copyright © 2020 xfg. All rights reserved.
//  参考（主要）：https://www.jianshu.com/p/2d57c72016c6
//  参考：https://www.jianshu.com/p/caeebd30a6d2

#import "GCDTestViewController.h"

@interface GCDTestViewController ()
{
    dispatch_semaphore_t _semaphore;
}

/// 火车票剩余张数
@property (nonatomic, assign) NSUInteger ticketSurplusCount;

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
    
    /**
     一、死锁
     二、GCD任务执行顺序
     三、dispatch_barrier_async(栅栏函数)
     四、dispatch_group_async
     五、Dispatch Semaphore
     
     --------------------------------------------------------------------------------------------
     |  区别      |       并发队列           |        串行队列             |          主队列         |
     --------------------------------------------------------------------------------------------
     |同步（sync） |没有开启新线程，串行执行任务  |   没有开启新线程，串行执行任务  |       死锁卡住不执行     |
     --------------------------------------------------------------------------------------------
     |异步（async）|  有开启新线程，并发执行任务  |有开启新线程（1条），串行执行任务 |没有开启新线程，串行执行任务|
     --------------------------------------------------------------------------------------------
     
     */
    
    [self test];
}

- (void)test
{
//    [self deallock];
//    [self syncConcurrent];
//    [self asyncConcurrent];
//    [self syncSerial];
//    [self asyncSerial];
//    [self syncMainQueue];
//    [self asyncMainQueue];
//    [self threedCommunication];
//    [self barrier];
//    [self dispatchApply];
//    [self dispatchGroup];
//    [self dispatchGroupWait];
//    [self groupEnterAndLeave];
//    [self semaphoreSync];
    [self initTicketStatus];
}


#pragma mark -
#pragma mark - 实践

#pragma mark 死锁
- (void)deallock
{
    //    dispatch_sync(dispatch_get_main_queue(), ^{
    //        NSLog(@"deallock");
    //    });
    
    //    dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
    //    dispatch_async(queue, ^{    // 异步执行 + 串行队列
    //        dispatch_sync(queue, ^{  // 同步执行 + 当前串行队列
    //            // 追加任务 1
    //            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
    //            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
    //        });
    //    });
}

#pragma mark 同步执行 + 并行队列
- (void)syncConcurrent
{
    NSLog(@"syncConcurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("syncConcurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        [self task:1];
    });
    
    dispatch_sync(queue, ^{
        [self task:2];
    });
    
    NSLog(@"syncConcurrent---end");
}

#pragma mark 异步执行 + 并行队列
- (void)asyncConcurrent
{
    NSLog(@"asyncConcurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("asyncConcurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [self task:1];
    });
    
    dispatch_async(queue, ^{
        [self task:2];
    });
    
    NSLog(@"asyncConcurrent---end");
}

#pragma mark 同步执行 + 串行队列
- (void)syncSerial
{
    NSLog(@"syncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("syncSerial", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        [self task:1];
    });
    
    dispatch_sync(queue, ^{
        [self task:2];
    });
    
    NSLog(@"syncSerial---end");
}

#pragma mark 异步执行 + 串行队列
- (void)asyncSerial
{
    NSLog(@"asyncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("asyncSerial", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [self task:1];
    });
    
    dispatch_async(queue, ^{
        [self task:2];
    });
    
    NSLog(@"asyncSerial---end");
}

#pragma mark 同步执行 + 主队列 (造成死锁现象)
- (void)syncMainQueue
{
    NSLog(@"syncMainQueue---begin");
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self task:1];
    });
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self task:2];
    });
    
    NSLog(@"syncMainQueue---end");
}

#pragma mark 异步执行 + 主队列
- (void)asyncMainQueue
{
    NSLog(@"asyncMainQueue---begin");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self task:1];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self task:2];
    });
    
    NSLog(@"asyncMainQueue---end");
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

#pragma mark 栅栏方法 dispatch_barrier_sync
- (void)barrier
{
    dispatch_queue_t queue = dispatch_queue_create("barrierTest", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        [self task:1 taskCount:3];
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"执行栅栏方法");
    });
    
    dispatch_async(queue, ^{
        [self task:2 taskCount:4];
    });
}

#pragma mark dispatch_apply
- (void)dispatchApply
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"dispatchApply---begin");
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"===== count：%zu 当前线程：%@", index, [NSThread currentThread]);
    });
    NSLog(@"dispatchApply---end");
}

#pragma mark 队列组 dispatch_group
- (void)dispatchGroup
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("dispatchGroup", DISPATCH_QUEUE_CONCURRENT);
    
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

- (void)dispatchGroupWait
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("dispatchGroup", DISPATCH_QUEUE_CONCURRENT);
    
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

#pragma mark 队列组 dispatch_group_enter、dispatch_group_leave
- (void)groupEnterAndLeave
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("dispatchGroup", DISPATCH_QUEUE_CONCURRENT);
    
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
    
    dispatch_queue_t queue = dispatch_queue_create("semaphoreSync", DISPATCH_QUEUE_CONCURRENT);
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

#pragma mark 各地异步售卖火车票
- (void)initTicketStatus
{
    self.ticketSurplusCount = 50;
    _semaphore = dispatch_semaphore_create(1);
    
    dispatch_queue_t queue1 = dispatch_queue_create("fuzhou", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue1, ^{
        [self saleTicket];
    });
    
    dispatch_queue_t queue2 = dispatch_queue_create("xiamen", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue2, ^{
        [self saleTicket];
    });
    
    //    应用层、表示层、会话层、传输层、网络层、数据链路层、物理层
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
