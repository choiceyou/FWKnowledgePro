//
//  RunLoopTestViewController.m
//  MSPro
//
//  Created by xfg on 2020/7/1.
//  Copyright © 2020 xfg. All rights reserved.
//  参考：https://www.jianshu.com/p/d260d18dd551

#import "RunLoopTestViewController.h"

@interface RunLoopTestViewController ()

@end


@implementation RunLoopTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"RunLoop";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test];
}

- (void)test
{
    // 创建观察者
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"监听到RunLoop发生改变---%zd",activity);
    });

    // 添加观察者到当前RunLoop中
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);

    // 释放observer，最后添加完需要释放掉
    CFRelease(observer);
}

@end
