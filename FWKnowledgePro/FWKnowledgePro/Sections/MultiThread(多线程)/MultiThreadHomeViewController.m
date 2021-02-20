//
//  MultiThreadHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2019/12/1.
//

#import "MultiThreadHomeViewController.h"
#import "NSThreadTestViewController.h"
#import "NSOperationTestViewController.h"
#import "GCDTestViewController.h"
#import "ThreadSyncViewController.h"

@interface MultiThreadHomeViewController ()

@end


@implementation MultiThreadHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"多线程";
    
    NSMutableArray *tmpArray = @[
        @"NSThread（使用更加面向对象）",
        @"GCD（充分利用设备的多核）",
        @"NSOperation（基于GCD，比GCD多了一些简单实用的功能；使用更加面向对象）",
        @"iOS中线程同步方案",
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
            tmpVC = [[NSThreadTestViewController alloc] init];
        }
            break;
        case 1: {
            tmpVC = [[GCDTestViewController alloc] init];
        }
            break;
        case 2: {
            tmpVC = [[NSOperationTestViewController alloc] init];
        }
            break;
        case 3: {
            tmpVC = [[ThreadSyncViewController alloc] init];
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
