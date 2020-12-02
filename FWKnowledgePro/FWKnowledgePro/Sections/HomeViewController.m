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
#import "NetTestViewController.h"
#import "DataPersistenceViewController.h"
#import "DPHomeViewController.h"
#import "MultiThreadHomeViewController.h"
#import "POHomeViewController.h"
#import "OCHomeViewController.h"

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
        @"Runtime",
        @"性能优化",
        @"算法",
        @"内存管理、自动释放池与循环引用",
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
            
        }
            break;
        case 7: {
            tmpVC = [[POHomeViewController alloc] init];
        }
            break;
        case 8: {
            tmpVC = [[MSAlgorithmViewController alloc] init];
        }
            break;
        case 9: {
            
        }
            
        default:
            break;
    }
    if (tmpVC) {
        [self.navigationController pushViewController:tmpVC animated:YES];
    }
}

@end
