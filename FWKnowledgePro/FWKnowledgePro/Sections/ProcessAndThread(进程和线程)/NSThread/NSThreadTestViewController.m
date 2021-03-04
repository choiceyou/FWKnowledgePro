//
//  NSThreadTestViewController.m
//  MSPro
//
//  Created by xfg on 2020/7/1.
//  Copyright © 2020 xfg. All rights reserved.
//  参考：https://www.jianshu.com/p/cbaeea5368b1

#import "NSThreadTestViewController.h"

@interface NSThreadTestViewController ()

@property (nonatomic, strong) NSThread *thread;

@end


@implementation NSThreadTestViewController

- (void)dealloc
{
    if (_thread) {
        [_thread cancel];
        _thread = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"NSThread";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test];
}

- (void)test
{
    //    [self createThread];
    [self permanentThread];
}


#pragma mark -
#pragma mark - 实践

- (void)createThread
{
    //    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(task1) object:nil];
    //    thread.name = @"test";
    //    [thread start];
    
    [NSThread detachNewThreadSelector:@selector(task1) toTarget:self withObject:nil];
}

#pragma mark 常驻线程
- (void)permanentThread
{
    // 创建线程，并调用run1方法执行任务
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    self.thread.name = @"test11";
    // 开启线程
    [self.thread start];
}

- (void)run
{
    @autoreleasepool {
        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    }
}


#pragma mark -
#pragma mark - Other

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self performSelector:@selector(task1) onThread:self.thread withObject:nil waitUntilDone:NO];
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
