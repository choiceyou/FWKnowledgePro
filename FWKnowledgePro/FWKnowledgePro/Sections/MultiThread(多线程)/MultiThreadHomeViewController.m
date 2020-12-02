//
//  MultiThreadHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/12/1.
//

#import "MultiThreadHomeViewController.h"
#import "NSThreadTestViewController.h"
#import "NSOperationTestViewController.h"
#import "GCDTestViewController.h"
#import "RunLoopTestViewController.h"

@interface MultiThreadHomeViewController ()

@end


@implementation MultiThreadHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"多线程";
    
    NSMutableArray *tmpArray = @[
        @"NSThread",
        @"NSOperation",
        @"GCD",
        @"RunLoop"
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
            tmpVC = [[NSOperationTestViewController alloc] init];
        }
            break;
        case 2: {
            tmpVC = [[GCDTestViewController alloc] init];
        }
            break;
        case 3: {
            tmpVC = [[RunLoopTestViewController alloc] init];
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
