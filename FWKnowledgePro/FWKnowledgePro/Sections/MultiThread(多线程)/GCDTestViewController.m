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
 
 GCD源码下载地址：https://github.com/apple/swift-corelibs-libdispatch
 
 1、队列：
 （1）串行队列：FIFO先进先出；
 （2）并发队列：
 （3）主列队：dispatch_get_main_queue，属于特殊的串行队列；
 （4）全局队列：dispatch_get_global_queue，属于特殊的并发队列；
 2、任务：block里面的代码块；
 3、同步：会阻塞当前线程，且不会开辟新线程；
 4、异步：不会阻塞当前线程；
 
 5、死锁
 6、GCD任务执行顺序
 7、栅栏函数：dispatch_barrier_async
 8、队列组：dispatch_group_async
 9、信号量：Dispatch Semaphore
 
 --------------------------------------------------------------------------------------------
 |    区别    |       手动创建的串行队列      |          并发队列        |          主队列         |
 --------------------------------------------------------------------------------------------
 | 同步(sync) | 没有开启新线程，串行执行任务    | 没有开启新线程，串行执行任务 |       死锁卡住不执行     |
 --------------------------------------------------------------------------------------------
 |异步(async) | 有开启新线程(1条)，串行执行任务 |  有开启新线程，并发执行任务  | 没有开启新线程，串行执行任务|
 --------------------------------------------------------------------------------------------
 
 11、执行
 （1）dispatch_sync：立马在当前线程执行任务，执行完毕才能往下执行；
 （2）dispatch_async：不会立马在当前线程执行任务；
 
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
        @"测试题1",
        @"测试题2",
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
        case 16: {
            [self test];
        }
            break;
        case 17: {
            [self test2];
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
    /**
     总结：使用”sync函数“往”当前“”串行“队列中添加任务，会卡住当前的串行队列（产生死锁）；
     */
    
    /**
     死锁一：分析
     1、单条队列的特点：FIFO（先进先出）；
     2、当前主线程中已经有一个方法（deallock）正在执行中；
     3、dispatch_sync表示block块中的任务需要立马执行，执行完毕才能往下执行；
     4、因此 deallock 在等待 block块代码执行完毕，block块代码 在等待 deallock 执行完毕，造成了相互等待；
     
     如果将dispatch_sync换成dispatch_async，就不会造成死锁了；
     */
    
    NSLog(@"执行任务1");
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"执行任务2");
    });
    NSLog(@"执行任务3");
    
    
    /**
     死锁二：分析
     1、单条队列的特点：FIFO（先进先出）；
     2、异步+串行执行时会生成一条子线程；
     3、当前子线程中已经有一个方法（block0）正在执行中；
     4、dispatch_sync表示block1块中的任务需要立马执行，执行完毕才能往下执行；
     5、因此 block0 在等待 block1 执行完毕，block1 在等待 block0 执行完毕，造成了相互等待；
     */
    dispatch_queue_t queue = dispatch_queue_create("com.xx.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{     // 假设这是block0
        NSLog(@"执行任务4");
        dispatch_sync(queue, ^{  // 假设这是block1
            NSLog(@"执行任务5 -- %@",[NSThread currentThread]);
        });
        NSLog(@"执行任务6");
    });
    
    
    /**
     如果将队列改成并发队列，这里是不会产生死锁的，因为并发队列可以同时从队列中拿出多个任务执行
     */
    dispatch_queue_t queue2 = dispatch_queue_create("com.xx.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue2, ^{     // 假设这是block0
        NSLog(@"执行任务4");
        dispatch_sync(queue2, ^{  // 假设这是block1
            NSLog(@"执行任务5 -- %@",[NSThread currentThread]);
        });
        NSLog(@"执行任务6");
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
    
    // 等前面的方法执行完毕后会执行这个
    dispatch_group_notify(group, queue, ^{
        // 回到主队列执行任务
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"异步任务全部执行完成通知");
        });
    });
    
    // 上面代码其实可以直接这样子写
    //    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    //        NSLog(@"异步任务全部执行完成通知");
    //    });
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
#pragma mark - 其它测试题目

#pragma mark 测试题1
- (void)test
{
    /**
     题目：打印结果是什么？
     
     答：打印结果是1、3
     因为：performSelector:withObject:afterDelay: 的本质是往RunLoop中添加定时器，子线程是默认没有启动RunLoop；
     */
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSLog(@"1");
        [self performSelector:@selector(otherTest) withObject:nil afterDelay:.0];
        NSLog(@"3");
    });
}

- (void)otherTest
{
    NSLog(@"2");
}

#pragma mark 测试题2
- (void)test2
{
    /**
     题目：打印结果是什么？
     
     答：程序会卡住。原因：往一个已经退出了的线程中发添加任务；
     */
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"1");
    }];
    [self performSelector:@selector(otherTest) onThread:thread withObject:nil waitUntilDone:YES];
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
