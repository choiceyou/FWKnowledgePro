//
//  BasicHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/2/25.
//

#import <Foundation/Foundation.h>
#import "BasicHomeViewController.h"
#import "BCScatteredHomeController.h"
#import "BCQuartz2DHomeController.h"
#import "BCQuartzCoreHomeController.h"

@interface BasicHomeViewController ()

@end


@implementation BasicHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"基础知识";
    
    NSMutableArray *tmpArray = @[
        @{
            kFirstLevel : @"一、零散知识",
            kSecondLevel : @[
                    @"零散知识点",
            ]
        },
        @{
            kFirstLevel : @"二、Quartz2D",
            kSecondLevel : @[
                    @"Quartz2D库相关",
            ]
        },
        @{
            kFirstLevel : @"三、QuartzCore",
            kSecondLevel : @[
                    @"QuartzCore库相关",
            ]
        },
    ].mutableCopy;
    
    [self.dataArray addObjectsFromArray:tmpArray];
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *tmpVC = nil;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                tmpVC = [[BCScatteredHomeController alloc] init];
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: {
                tmpVC = [[BCQuartz2DHomeController alloc] init];
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0: {
                tmpVC = [[BCQuartzCoreHomeController alloc] init];
            }
                break;
                
            default:
                break;
        }
    }
    
    if (tmpVC) {
        [self.navigationController pushViewController:tmpVC animated:YES];
    }
}

@end
