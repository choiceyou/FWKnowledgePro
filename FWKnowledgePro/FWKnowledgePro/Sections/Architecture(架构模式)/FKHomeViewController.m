//
//  FKHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import "FKHomeViewController.h"
#import "MVCViewController.h"
#import "MVVMViewController.h"
#import "MVPViewController.h"
#import "LayeredViewController.h"

@interface FKHomeViewController ()

@end

@implementation FKHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"架构模式";
    
    NSMutableArray *tmpArray = @[
        @"MVC（界面层架构）",
        @"MVP（界面层架构）",
        @"MVVM（界面层架构）",
        @"分层架构：三层架构 ==》界面层、业务层、数据层",
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
            tmpVC = [[MVCViewController alloc] init];
        }
            break;
        case 1: {
            tmpVC = [[MVPViewController alloc] init];
        }
            break;
        case 2: {
            tmpVC = [[MVVMViewController alloc] init];
        }
            break;
        case 3: {
            tmpVC = [[LayeredViewController alloc] init];
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
