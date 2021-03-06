//
//  HomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2019/11/23.
//

#import "HomeViewController.h"
#import "FKHomeViewController.h"
#import "MSAlgorithmViewController.h"
#import "NetHomeViewController.h"
#import "DataPersistenceViewController.h"
#import "DPHomeViewController.h"
#import "MultiThreadHomeViewController.h"
#import "POHomeViewController.h"
#import "OCHomeViewController.h"
#import "RuntimeHomeViewController.h"
#import "RunloopHomeViewController.h"
#import "MemoryHomeViewController.h"
#import "PTHomeViewController.h"
#import "AnimationHomeViewController.h"
#import "BasicHomeViewController.h"
#import "ThirdPartyHomeViewController.h"

/**
 公共：
 1、编译生成cpp文件：xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc main.m -o main-arm64.cpp
 2、GNUstep是GNU计划的项目之一，它将Cocoa的OC库重新实现了一遍（不是苹果官方源码，但还是具有一定的参考价值），源码地址：http://www.gnustep.org/resources/downloads.php
 
 
 ======================
 推荐：
 
 数据结构与算法：
 （1）《数据结构》-- 严蔚敏；
 （2）《大话数据结构与算法》；

 网络：
 《HTTP权威指南》
 《TCP/IP详解卷1：协议》

 架构与设计模式：
 （1）https://github.com/skyming/Trip-to-iOS-Design-Patterns
 （2）https://design-patterns.readthedocs.io/zh_CN/latest/
 */

/**
 一、临时
 1、内存管理；
 2、面向对象：
 （1）三大特性：封装、继承、多态；
 （2）重写、重载；
 3、进程：
 4、网络：TCP、UDP、socket；
 5、数据持久化：数据库、SQL；
 6、编程思想：函数式编程、响应式编程、链式编程；
 7、UML；
 
 二、长期
 1、Swift；
 2、算法；
 3、RAC；
 */

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    
    NSMutableArray *tmpArray = @[
        @"基础知识",
        @"语法部分（底层）",
        @"数据持久化",
        @"进程和线程",
        @"网络相关",
        @"Runtime（运行时）",
        @"Runloop（运行循环）",
        @"内存管理",
        @"动画",
        @"性能优化",
        @"设计模式",
        @"架构模式",
        @"编程思想",
        @"算法",
        @"第三方",
    ].mutableCopy;
    
    [self.titleArray addObjectsFromArray:tmpArray];
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *tmpVC = nil;
    switch (indexPath.row) {
        case 0: {
            // 基础知识
            tmpVC = [[BasicHomeViewController alloc] init];
        }
            break;
        case 1: {
            // 语法部分（底层）
            tmpVC = [[OCHomeViewController alloc] init];
        }
            break;
        case 2: {
            // 数据持久化
            tmpVC = [[DataPersistenceViewController alloc] init];
        }
            break;
        case 3: {
            // 进程和线程
            tmpVC = [[MultiThreadHomeViewController alloc] init];
        }
            break;
        case 4: {
            // 网络相关
            tmpVC = [[NetHomeViewController alloc] init];
        }
            break;
        case 5: {
            // Runtime（运行时）
            tmpVC = [[RuntimeHomeViewController alloc] init];
        }
            break;
        case 6: {
            // Runloop（运行循环）
            tmpVC =  [[RunloopHomeViewController alloc] init];
        }
            break;
        case 7: {
            // 内存管理
            tmpVC = [[MemoryHomeViewController alloc] init];
        }
            break;
        case 8: {
            // 动画
            tmpVC = [[AnimationHomeViewController alloc] init];
        }
            break;
        case 9: {
            // 性能优化
            tmpVC = [[POHomeViewController alloc] init];
        }
            break;
        case 10: {
            // 设计模式
            tmpVC = [[DPHomeViewController alloc] init];
        }
            break;
        case 11: {
            // 架构模式
            tmpVC = [[FKHomeViewController alloc] init];
        }
            break;
        case 12: {
            // 编程思想
            tmpVC = [[PTHomeViewController alloc] init];
        }
            break;
        case 13: {
            // 算法
            tmpVC = [[MSAlgorithmViewController alloc] init];
        }
            break;
        case 14: {
            // 第三方
            tmpVC = [[ThirdPartyHomeViewController alloc] init];
        }
            break;
            
        default:
            break;
    }
    if (tmpVC) {
        [self.navigationController pushViewController:tmpVC animated:YES];
    }
}

@end
