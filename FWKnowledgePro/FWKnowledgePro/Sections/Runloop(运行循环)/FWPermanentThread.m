//
//  FWPermanentThread.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/2/20.
//

#import "FWPermanentThread.h"

@interface FWPermanentThread ()

/// 内部线程（尽量不暴露出去，防止外部修改相关逻辑）
@property (nonatomic, strong) NSThread *innerThread;
/// 判断是否执行停止线程了
@property (nonatomic, assign, getter=isStopped) BOOL stopped;

@end


@implementation FWPermanentThread

- (void)dealloc
{
    NSLog(@"%s", __func__);
    
    [self stop];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        __weak typeof(self) weakSelf = self;
        self.innerThread = [[NSThread alloc] initWithBlock:^{
            // 方法一：使用OC-API实现
            [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
            while (weakSelf && !weakSelf.isStopped) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            
            // 方案二：使用C-API实现
            // CFRunLoopSourceContext context = {0};
            // CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
            // CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
            // CFRelease(source);
            //
            // // 1.0e10是一个很大的数字（源码中使用这个）
            // CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
        }];
    }
    return self;
}


#pragma mark -
#pragma mark - Public

#pragma mark 开始线程
- (void)run
{
    if (!self.innerThread) return;
    
    [self.innerThread start];
}

#pragma mark 执行任务
- (void)executeTarget:(void(^)(void))target
{
    if (!self.innerThread || !target) return;
    
    [self performSelector:@selector(execute:) onThread:self.innerThread withObject:target waitUntilDone:NO];
}

#pragma mark 停止任务
- (void)stop
{
    if (!self.innerThread) return;
    
    [self performSelector:@selector(stopRunLoop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}


#pragma mark -
#pragma mark - Private

- (void)stopRunLoop
{
    self.stopped = YES;
    // 停止当前这一次的Loop
    CFRunLoopStop(CFRunLoopGetCurrent());
    // 将innerThread的强引用置为空
    self.innerThread = nil;
}

- (void)execute:(void(^)(void))target
{
    !target ? : target();
}

@end
