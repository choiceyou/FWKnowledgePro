//
//  BlockTestViewController.m
//  MSPro
//
//  Created by xfg on 2020/6/29.
//  Copyright © 2020 xfg. All rights reserved.
//  参考：https://juejin.im/post/5e13126b6fb9a04811666925

#import "BlockTestViewController.h"

typedef NSInteger(^MSTestBlock)(NSInteger num);
typedef void(^MSTestBlock2)(NSInteger num);


@interface BlockTestViewController ()

@property (nonatomic, assign) NSInteger num;

@end


@implementation BlockTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Block";
    self.view.backgroundColor = [UIColor whiteColor];
    
    /**
     一、什么是Block？
     Block是将函数及其执行上下文封装起来的对象。
     
     二、Block变量截获
     1、局部变量截获：值截获;
     2、局部静态变量截获：指针截获;
     3、全局变量，静态全局变量截获：不截获，直接取值;
     
     三、Block的几种形式
     1、栈Block(_NSConcreteStackBlock)：使用外部变量并且未进行copy操作的block是栈block，存储在栈(stack)区。
     2、堆Block(_NSConcreteMallocBlock)：对栈block进行copy操作，就是堆block，存储在堆(heap)区。
     3、全局Block(_NSConcreteGlobalBlock)：不使用外部变量的block是全局block（对全局block进行copy，仍是全局block），存储在已初始化数据(.data)区。
     */
    
    self.num = 3;
    [self test];
}

- (void)test
{
    __block NSInteger num2 = 1;
    //    static NSInteger num = 3;
    __weak typeof(self) weakSelf = self;
    MSTestBlock testBlock = ^NSInteger(NSInteger num) {
        num2 ++;
        return num * weakSelf.num;
    };
    self.num = 1;
    NSInteger result = testBlock(2);
    NSLog(@"=======result:%ld", result);
    
    
    //    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
    //
    //    void(^block)(void) = ^{
    //
    //        NSLog(@"%@",arr);//局部变量
    //
    //        [arr addObject:@"4"];
    //    };
    //
    //    [arr addObject:@"3"];
    //
    //    arr = nil;
    //
    //    block();
    //
    //    NSLog(@"==:%@",arr);
    
    
    NSLog(@"%@",[^{
        NSLog(@"%ld", self.num);
    } class]);
}

@end
