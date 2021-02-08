//
//  RunloopHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/1/29.
//

/**
 OC对象本质上就是结构体指针
 
 Runloop：运行循环（死循环）
 死循环的目的：
 1、保证线程不退出，就保证了程序不退出；
 2、负责监听事件：触摸、网络、时钟、远程控制、加速 等等事件；
 3、渲染UI；
 
 Runloop接收：事件（输入）源、定时器、观察者；
 
 mode：
 1、默认模式：NSDefaultRunLoopMode；
 2、UI模式：UITrackingRunLoopMode（优先级最高）；
 3、占位模式（并不是Runloop真正的模式）：NSRunLoopCommonModes；
 4、程序初始化模式（平时用不到）；
 5、程序的内核模式（平时用不到）；
 
 关于Source（事件源），按照函数调用站分为两种：
 1、Source0：非系统内核事件；
 2、Source1：系统内核事件；
 */

#import "RunloopHomeViewController.h"

@interface RunloopHomeViewController ()

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation RunloopHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Runloop";
    
    NSMutableArray *tmpArray = @[
        
    ].mutableCopy;
    
    [self.titleArray addObjectsFromArray:tmpArray];
    
    //    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeMethod) userInfo:nil repeats:YES];
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    //    [self gcdTimer];
    
    [self addCFRunloopObserver];
    // 保证Runloop在不休眠
    [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark -
#pragma mark - Other

- (void)timeMethod
{
    static int i = 0;
    NSLog(@"i = %d, 当前线程：%@", i++, [NSThread currentThread]);
}

#pragma mark GCD定时器
- (void)gcdTimer
{
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        NSLog(@"当前线程---：%@", [NSThread currentThread]);
    });
    dispatch_resume(self.timer);
}

- (void)addCFRunloopObserver
{
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
    CFRunLoopObserverRef obsever = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &callback, &context);
    // 3.添加观察者
    CFRunLoopAddObserver(runloop, obsever, kCFRunLoopDefaultMode);
    // 4.释放
    CFRelease(obsever);
}

void callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    RunloopHomeViewController *rlHomeVC = (__bridge RunloopHomeViewController *)info;
    NSLog(@"来了 -- %@", rlHomeVC);
}

- (void)timerMethod
{
    
}

@end
