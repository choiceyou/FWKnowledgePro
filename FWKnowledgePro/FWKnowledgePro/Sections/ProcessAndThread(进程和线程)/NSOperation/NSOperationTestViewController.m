//
//  NSOperationTestViewController.m
//  MSPro
//
//  Created by xfg on 2020/6/30.
//  Copyright © 2020 xfg. All rights reserved.
//  参考1（主要）：https://www.jianshu.com/p/4b1d77054b35
//  参考2：https://juejin.im/post/5e134999e51d454103545922

#import "NSOperationTestViewController.h"
#import "FWOperation.h"

@interface NSOperationTestViewController ()

/// 火车票剩余数量
@property (nonatomic, assign) NSUInteger ticketSurplusCount;
@property (nonatomic, strong) NSLock *lock;
/// 队列
@property (nonatomic, strong) NSOperationQueue *currntQueue;

@end


@implementation NSOperationTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"NSOperation";
    
    NSMutableArray *tmpArray = @[
        @{
            kFirstLevel : @"一、知识点",
            kSecondLevel : @[
                    @"NSOperation和NSOperationQueue实现多线程的具体步骤",
                    @"NSOperation的优点",
                    @"NSOperation的两种队列：主队列（串行队列）",
                    @"NSOperation的两种队列：非主队列（自定义队列，同时具备了串行、并发的功能）",
            ]
        },
        @{
            kFirstLevel : @"二、实践",
            kSecondLevel : @[
                    @"使用子类NSInvocationOperation",
                    @"使用子类NSBlockOperation",
                    @"使用自定义Operation",
                    @"使用 addOperation: 将操作加入到操作队列中",
                    @"使用 addOperationWithBlock: 将操作加入到操作队列中",
                    @"使用 addDependency: 操作依赖",
                    @"线程间通讯",
                    @"队列：暂停队列中的任务",
                    @"队列：继续执行队列中的任务",
                    @"队列：取消队列中的任务",
                    @"麦火车票演示",
            ]
        },
    ].mutableCopy;
    
    [self.dataArray addObjectsFromArray:tmpArray];
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                /**
                 NSOperation和NSOperationQueue实现多线程的具体步骤：
                 1、现将需要执行的操作封装到一个NSOperation对象中；
                 2、然后将NSOperation对象添加到NSOperationQueue中；
                 3、系统会自动将NSOperationQueue中的NSOperation取出来；
                 4、将取出来的NSOperation封装的操作放到一条新线程中执行；
                 */
            }
                break;
            case 1: {
                /**
                 NSOperationQueue的优点：
                 1、可添加完成的代码块，在操作完成后执行；
                 2、可以添加任务依赖，方便控制执行顺序；
                 3、可以设定操作执行的优先级；
                 4、任务执行状态控制:isReady,isExecuting,isFinished,isCancelled；
                 5、可以设置最大并发量；
                 6、可以很方便的取消一个操作的执行；
                 */
            }
                break;
            case 2: {
                /**
                 获取主队列：[NSOperationQueue mainQueue];
                 
                 主队列为串行队列
                 */
            }
                break;
            case 3: {
                /**
                 获取非主队列（自定义队列）：[[NSOperationQueue alloc] init];
                
                 同时具备了串行、并发的功能，默认情况下是并发队列。具体情况如下：
                 maxConcurrentOperationCount参数的值，决定了该队列是什么队列。
                 （1）maxConcurrentOperationCount 默认值为-1（特殊意义：不限制），即表示该队列为并发队列；
                 （2）如果 maxConcurrentOperationCount 值为0，不会执行任务；
                 （3）如果 maxConcurrentOperationCount 值为1，即表示该队列为串行队列；
                 （4）如果 maxConcurrentOperationCount 值为大于1，即表示该队列为并发队列；
                 */
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: {
                [self useInvocationOperation];
            }
                break;
            case 1: {
                [self useBlockOperation];
            }
                break;
            case 2: {
                [self useCustomOperation];
            }
                break;
            case 3: {
                [self addOperationToQueue];
            }
                break;
            case 4: {
                [self addOperationWithBlockToQueue];
            }
                break;
            case 5: {
                [self addDependency];
            }
                break;
            case 6: {
                [self communication];
            }
                break;
            case 7: {
                [self suspendQueue];
            }
                break;
            case 8: {
                [self resumeQueue];
            }
                break;
            case 9: {
                [self cancelQueue];
            }
                break;
            case 10: {
                /**
                 场景：总共有50张火车票，有两个售卖火车票的窗口，一个是北京火车票售卖窗口，另一个是上海火车票售卖窗口。两个窗口同时售卖火车票，卖完为止。
                 */
                self.lock = [[NSLock alloc] init];
                for (int i = 0; i < 100; i++) {
                    [self initTicketStatus];
                }
            }
                break;
                
            default:
                break;
        }
    }
}


#pragma mark -
#pragma mark - 实践

#pragma mark 使用子类NSInvocationOperation
- (void)useInvocationOperation
{
    /**
     注意：这边只会在主线程中添加任务，因为，需要实现多线程的话需要配合队列；
     */
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    [operation start];
}

#pragma mark 使用子类NSBlockOperation
- (void)useBlockOperation
{
    /**
     如果一个操作中的任务数量大于1，那么有可能会开启子线程，并发执行任务
     */
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [self task2:1];
    }];
    
    // 2.添加额外的操作
    [operation addExecutionBlock:^{
        [self task2:2];
    }];
    
    [operation addExecutionBlock:^{
        [self task2:3];
    }];
    
    [operation start];
}

#pragma mark 使用自定义Operation
- (void)useCustomOperation
{
    FWOperation *op1 = [[FWOperation alloc] init];
    FWOperation *op2 = [[FWOperation alloc] init];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:op1];
    [queue addOperation:op2];
}

#pragma mark 使用 addOperation: 将操作加入到操作队列中
- (void)addOperationToQueue
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    // 设置op1的优先级
    op1.queuePriority = NSOperationQueuePriorityLow;
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [self task2:2];
    }];
    
    [queue addOperation:op1]; // 内部已经调用了NSOperation的start方法
    [queue addOperation:op2]; // 内部已经调用了NSOperation的start方法
    
    // 某个任务执行完毕回调
    op1.completionBlock = ^{
        NSLog(@"任务1执行完毕 - %@", [NSThread currentThread]);
    };
    
    op2.completionBlock = ^{
        NSLog(@"任务2执行完毕 - %@", [NSThread currentThread]);
    };
}

#pragma mark 使用 addOperationWithBlock: 将操作加入到操作队列中
- (void)addOperationWithBlockToQueue
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // maxConcurrentOperationCount 默认值为：-1
    // 1：则表示当前队列为串行队列
    queue.maxConcurrentOperationCount = 1;
    // 大于1：则表示当前队列为并行队列
    //    queue.maxConcurrentOperationCount = 2;
    
    [queue addOperationWithBlock:^{
        [self task2:1];
    }];
    
    [queue addOperationWithBlock:^{
        [self task2:2];
    }];
}

#pragma mark 使用 addDependency: 操作依赖
- (void)addDependency
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [self task2:2];
    }];
    
    // 添加依赖：op2执行完毕后才会执行op1。可以跨队列依赖
    [op1 addDependency:op2];
    
    [queue addOperation:op1];
    [queue addOperation:op2];
}

#pragma mark 暂停队列中的任务
- (void)suspendQueue
{
    [self currntQueue];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.currntQueue setSuspended:YES];
    });
}

#pragma mark 继续执行队列中的任务
- (void)resumeQueue
{
    self.currntQueue.suspended = NO;
}

#pragma mark 取消队列中的任务
- (void)cancelQueue
{
    [self.currntQueue cancelAllOperations];
}

#pragma mark 线程间通讯
- (void)communication
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [queue addOperationWithBlock:^{
        // 模拟耗时操作
        [self task2:22];
        
        // 回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"回到线程：%@", [NSThread currentThread]);
        }];
    }];
}


#pragma mark -
#pragma mark - 卖火车票实践

#pragma mark 初始化火车票数量、卖票窗口(非线程安全)、并开始卖票
- (void)initTicketStatus
{
    NSLog(@"当前线程---%@", [NSThread currentThread]);
    
    self.ticketSurplusCount = 50;
    
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
    queue1.maxConcurrentOperationCount = 1;
    [queue1 addOperationWithBlock:^{
        [self saleTicket];
    }];
    
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
    queue2.maxConcurrentOperationCount = 1;
    [queue2 addOperationWithBlock:^{
        [self saleTicket];
    }];
}

- (void)saleTicket
{
    [self.lock lock];
    if (self.ticketSurplusCount > 0) {
        self.ticketSurplusCount --;
        NSLog(@"当前线程：%@，剩余火车票张数：%ld", [NSThread currentThread], self.ticketSurplusCount);
    } else {
        NSLog(@"火车票已经售完！");
    }
    [self.lock unlock];
}


#pragma mark -
#pragma mark - 其它

- (void)task1
{
    [self task2:1];
}

- (void)task2:(int)tag
{
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:1]; // 模拟耗时操作
        NSLog(@"%d---%@", tag, [NSThread currentThread]); // 打印当前线程
    }
}


#pragma mark -
#pragma mark - GET/SET

- (NSOperationQueue *)currntQueue
{
    if (!_currntQueue) {
        _currntQueue = [[NSOperationQueue alloc] init];
        
        NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
        
        NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
            for (int i = 1; i < 1000; i++) {
                NSLog(@"%d---%@", i, [NSThread currentThread]);
            }
        }];
        
        [_currntQueue addOperation:op1];
        [_currntQueue addOperation:op2];
        [_currntQueue addOperationWithBlock:^{
            for (int i = 1; i < 1000; i++) {
                NSLog(@"%d---%@", i, [NSThread currentThread]);
            }
        }];
    }
    return _currntQueue;
}

@end
