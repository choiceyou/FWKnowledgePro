//
//  HomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/11/23.
//

/**
 1、简单的demo；
 2、代码洁癖；
 */

#import "HomeViewController.h"
#import "MSAlgorithmViewController.h"
#import "BlockTestViewController.h"
#import "NSThreadTestViewController.h"
#import "GCDTestViewController.h"
#import "NSOperationTestViewController.h"
#import "RunLoopTestViewController.h"
#import "NetTestViewController.h"
#import "DataPersistenceViewController.h"
#import "DPHomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    
    NSMutableArray *tmpArray = @[
        @"UI相关：事件传递，图像显示，性能优化，离屏渲染",
        @"Objective_C语言特性相关问题",
        @"Runtime相关",
        @"算法相关",
        @"内存管理、自动释放池与循环引用",
        @"Block",
        @"多线程之NSThreed",
        @"多线程之GCD",
        @"多线程之NSOperation",
        @"RunLoop",
        @"网络相关",
        @"数据持久化",
        @"架构模式",
        @"设计模式",
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
            
        }
            break;
        case 1: {
            
        }
            break;
        case 2: {
            
        }
            break;
        case 3: {
            tmpVC = [[MSAlgorithmViewController alloc] init];
        }
            break;
        case 4: {
            
        }
            break;
        case 5: {
            tmpVC = [[BlockTestViewController alloc] init];
        }
            break;
        case 6: {
            tmpVC = [[NSThreadTestViewController alloc] init];
        }
            break;
        case 7: {
            tmpVC = [[GCDTestViewController alloc] init];
        }
            break;
        case 8: {
            tmpVC = [[NSOperationTestViewController alloc] init];
        }
            break;
        case 9: {
            tmpVC = [[RunLoopTestViewController alloc] init];
        }
            break;
        case 10: {
            tmpVC = [[NetTestViewController alloc] init];
        }
            break;
        case 11: {
            tmpVC = [[DataPersistenceViewController alloc] init];
        }
            break;
        case 12: {
            
        }
            break;
        case 13: {
            tmpVC = [[DPHomeViewController alloc] init];
        }
            
        default:
            break;
    }
    [self.navigationController pushViewController:tmpVC animated:YES];
}


@end
