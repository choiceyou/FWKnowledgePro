//
//  HomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2019/11/23.
//

/**
 1、简单的demo；
 2、代码洁癖；
 */

#import "HomeViewController.h"
#import "FKHomeViewController.h"
#import "MSAlgorithmViewController.h"
#import "NetTestViewController.h"
#import "DataPersistenceViewController.h"
#import "DPHomeViewController.h"
#import "MultiThreadHomeViewController.h"
#import "POHomeViewController.h"
#import "OCHomeViewController.h"
#import "RuntimeHomeViewController.h"
#import "RunloopHomeViewController.h"
#import "MemoryHomeViewController.h"
#import "PTHomeViewController.h"
#import <malloc/malloc.h>
#import <objc/runtime.h>

/**
 公共：
 1、编译生成cpp文件：xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc main.m -o main-arm64.cpp
 */

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    
    NSMutableArray *tmpArray = @[
        @"架构模式",
        @"设计模式",
        @"OC语言部分",
        @"数据持久化",
        @"多线程",
        @"网络相关",
        @"Runtime（运行时）",
        @"Runloop（运行循环）",
        @"性能优化",
        @"算法",
        @"动画",
        @"内存管理、自动释放池与循环引用",
        @"编程思想",
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
            tmpVC = [[FKHomeViewController alloc] init];
        }
            break;
        case 1: {
            tmpVC = [[DPHomeViewController alloc] init];
        }
            break;
        case 2: {
            tmpVC = [[OCHomeViewController alloc] init];
        }
            break;
        case 3: {
            tmpVC = [[DataPersistenceViewController alloc] init];
        }
            break;
        case 4: {
            tmpVC = [[MultiThreadHomeViewController alloc] init];
        }
            break;
        case 5: {
            tmpVC = [[NetTestViewController alloc] init];
        }
            break;
        case 6: {
            tmpVC = [[RuntimeHomeViewController alloc] init];
        }
            break;
        case 7: {
            tmpVC =  [[RunloopHomeViewController alloc] init];
        }
            break;
        case 8: {
            tmpVC = [[POHomeViewController alloc] init];
        }
            break;
        case 9: {
            tmpVC = [[MSAlgorithmViewController alloc] init];
        }
            break;
        case 10: {
            
        }
            break;
        case 11: {
            tmpVC = [[MemoryHomeViewController alloc] init];
        }
            break;
        case 12: {
            tmpVC = [PTHomeViewController new];
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
