//
//  NSOperationTestViewController.m
//  MSPro
//
//  Created by xfg on 2020/6/30.
//  Copyright © 2020 xfg. All rights reserved.
//  参考1（主要）：https://www.jianshu.com/p/4b1d77054b35
//  参考2：https://juejin.im/post/5e134999e51d454103545922


/**
 一、NSOperationQueue的优点
 1、可添加完成的代码块，在操作完成后执行；
 2、可以添加任务依赖，方便控制执行顺序；
 3、可以设定操作执行的优先级；
 4、任务执行状态控制:isReady,isExecuting,isFinished,isCancelled；
 5、可以设置最大并发量；
 6、可以很方便的取消一个操作的执行；
 
 二、创建队列
 1、主队列：[NSOperationQueue mainQueue];
 2、自定义队列：[[NSOperationQueue alloc] init]
 
 */

#import "NSOperationTestViewController.h"

@interface NSOperationTestViewController ()

/// 火车票剩余数量
@property (nonatomic, assign) NSUInteger ticketSurplusCount;
@property (nonatomic, strong) NSLock *lock;

@end


@implementation NSOperationTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"NSOperation";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test];
}

- (void)test
{
//    [self useInvocationOperation];
//    [self useBlockOperation];
//    [self addOperationToQueue];
//    [self addOperationWithBlockToQueue];
//    [self addDependency];
//    [self communication];
    
    /**
     场景：总共有50张火车票，有两个售卖火车票的窗口，一个是北京火车票售卖窗口，另一个是上海火车票售卖窗口。两个窗口同时售卖火车票，卖完为止。
     */
    self.lock = [[NSLock alloc] init];
    for (int i = 0; i < 100; i++) {
        [self initTicketStatus];
    }
}


#pragma mark -
#pragma mark - 实践

#pragma mark 使用子类NSInvocationOperation
- (void)useInvocationOperation
{
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    [operation start];
}

#pragma mark 使用子类NSBlockOperation
- (void)useBlockOperation
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [self task2:1];
    }];
    
    // 2.添加额外的操作
    [operation addExecutionBlock:^{
        [self task2:2];
    }];
    [operation start];
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
    
    [queue addOperation:op1];
    [queue addOperation:op2];
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
    
    // 添加依赖：op2执行完毕后才会执行op1
    [op1 addDependency:op2];
    
    [queue addOperation:op1];
    [queue addOperation:op2];
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

@end
