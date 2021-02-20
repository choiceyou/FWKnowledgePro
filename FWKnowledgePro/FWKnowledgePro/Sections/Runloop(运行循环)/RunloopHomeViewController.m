//
//  RunloopHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/1/29.
//

/**
 
 Runloop：运行循环（死循环）
 Runloop接收：事件（输入）源、定时器、观察者；
 
 Runloop的基本作用：
 1、保持程序的持续运行；
 2、处理APP的各种事件（如：触摸事件、定时器时间等）；
 3、节省CPU资源，提高程序性能（该做事时做事，该休息时休息）；
 
 应用范畴：
 1、定时器（Timer），perforSelector；
 2、GCD Async Main Queue，保证线程不退出，就保证了程序不退出；；
 3、事件响应（触摸、网络、时钟、远程控制、加速 等）、手势识别、界面刷新；
 4、网络请求；
 5、AutoreleasePool；
 等等
 
 iOS中有两套API来访问和使用Runloop：
 1、Foundation：NSRunLoop（NSRunLoop是对CFRunLoopRef的一层OC包装）；
 2、Core Foundation：CFRunLoopRef；
 
 mode：
 1、默认模式：NSDefaultRunLoopMode；
 2、UI模式：UITrackingRunLoopMode（优先级最高）；
 3、占位（或者叫标记，并不是Runloop真正的模式）：NSRunLoopCommonModes；
 4、程序初始化模式（平时用不到）；
 5、程序的内核模式（平时用不到）；
 
 关于Source（事件源），按照函数调用站分为两种：
 1、Source0：非系统内核事件；
 2、Source1：系统内核事件；
 
 RunLoop在实际开发中的应用：
 1、控制线程生命周期（线程保活）；
 2、解决NSTimer在滑动时停止工作的问题；
 3、监控应用卡顿；
 4、性能优化；
 
 RunLoop的休眠是调用了内核层面的API：mach_msg() 来实现的；
 
 */

#import "RunloopHomeViewController.h"
#import "FWThread.h"
#import "FWPermanentThread.h"

@interface RunloopHomeViewController ()
{
    CFRunLoopObserverRef _obsever;
    dispatch_source_t _gcdTimer;
}

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) FWThread *thread;
@property (nonatomic, assign, getter=isStopped) BOOL stopped;
@property (nonatomic, strong) FWPermanentThread *permanentThread;

@end


@implementation RunloopHomeViewController

- (void)dealloc
{
    NSLog(@"%s", __func__);
    
    if (_thread) {
        self.stopped = YES;
        [self performSelector:@selector(stopRunLoop) onThread:self.thread withObject:nil waitUntilDone:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_obsever) {
        // 移除RunLoop监听
        CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), _obsever, kCFRunLoopCommonModes);
        // 释放
        CFRelease(_obsever);
        _obsever = nil;
    }
    
    // 停止定时器
    if (_timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    // 停止GCD定时器
    if (_gcdTimer) {
        dispatch_source_cancel(_gcdTimer);
        _gcdTimer = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Runloop";
    
    NSMutableArray *tmpArray = @[
        @"RunLoop添加定时器",
        @"RunLoop添加监听器",
        @"开启常驻线程（线程保活）",
        @"停止常驻线程",
        @"开启封装好的常驻线程",
        @"停止封装好的常驻线程",
    ].mutableCopy;
    
    [self.titleArray addObjectsFromArray:tmpArray];
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeMethod) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            
            
            // 保证Runloop在不休眠
            [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(timeMethod2) userInfo:nil repeats:YES];
            
            // [self startGcdTimer];
        }
            break;
        case 1: {
            // 方案一
            // 1.获取当前线程的Runloop
            CFRunLoopRef runloop = CFRunLoopGetCurrent();
            // 2.创建观察者
            CFRunLoopObserverContext context = {
                0,
                (__bridge void *)self,
                &CFRetain,
                &CFRelease,
                NULL
            };
            _obsever = CFRunLoopObserverCreate(NULL, kCFRunLoopAllActivities, YES, 0, &callback, &context);
            // 3.添加观察者
            CFRunLoopAddObserver(runloop, _obsever, kCFRunLoopCommonModes);
            
            
            // 方案二
            //            CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, 0, YES, 1, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
            //
            //            });
            //            CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
            //            CFRelease(observer);
        }
            break;
        case 2: {
            [self performSelector:@selector(doSomeThing) onThread:self.thread withObject:nil waitUntilDone:NO];
            // waitUntilDone: 参数会影响接下来的调用
            NSLog(@"doSomeThing 下一步");
        }
            break;
        case 3: {
            if (_thread) {
                self.stopped = YES;
                [self performSelector:@selector(stopRunLoop) onThread:self.thread withObject:nil waitUntilDone:YES];
            }
        }
            break;
        case 4: {
            if (!self.permanentThread) {
                self.permanentThread = [[FWPermanentThread alloc] init];
                [self.permanentThread run];
            }
            
            __weak typeof(self) weakSelf = self;
            [self.permanentThread executeTarget:^{
                [weakSelf doSomeThing];
            }];
        }
            break;
        case 5: {
            [self.permanentThread stop];
            self.permanentThread = nil;
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark - Other

#pragma mark GCD定时器
- (void)startGcdTimer
{
    _gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(_gcdTimer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_gcdTimer, ^{
        NSLog(@"当前线程---：%@", [NSThread currentThread]);
    });
    dispatch_resume(_gcdTimer);
}

- (void)timeMethod
{
    static int i = 0;
    NSLog(@"i = %d, 当前线程：%@", i++, [NSThread currentThread]);
}

- (void)timeMethod2
{
    // 什么事情也不做
}

#pragma mark 调用方法：在子线程执行
- (void)doSomeThing
{
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
}

#pragma mark 停止RunLoop
- (void)stopRunLoop
{
    // 停止当前这一次的RunLoop
    CFRunLoopStop(CFRunLoopGetCurrent());
}

#pragma mark 监听RunLoop模式之间的切换
void callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    // RunloopHomeViewController *rlHomeVC = (__bridge RunloopHomeViewController *)info;
    
    // 演示模式之间的切换
    switch (activity) {
        case kCFRunLoopEntry: {
            // 获取当前RunLoop模式
            CFRunLoopMode mode = CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
            NSLog(@"CurrentMode = %@", mode);
            CFRelease(mode);
        }
            break;
        case kCFRunLoopExit: {
            // 获取当前RunLoop模式
            CFRunLoopMode mode = CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
            NSLog(@"CurrentMode = %@", mode);
            CFRelease(mode);
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark - GET/SET

#pragma mark 实现一条：常驻线程
- (FWThread *)thread
{
    if (!_thread) {
        __weak typeof(self) weakSelf = self;
        _thread = [[FWThread alloc] initWithBlock:^{
            // 线程保活
            NSLog(@"--begin：%@", [NSThread currentThread]);
            @autoreleasepool {
                [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
                // [[NSRunLoop currentRunLoop] run]; 这个方法无法停止，它专门用于创建一个永不销毁的线程
                while (weakSelf && !weakSelf.isStopped) {
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                }
            }
            NSLog(@"--end：看一下这边有执行吗？");
        }];
        [_thread start];
    }
    return _thread;
}

@end
