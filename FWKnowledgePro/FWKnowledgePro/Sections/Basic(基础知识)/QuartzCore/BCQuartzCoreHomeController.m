//
//  BCQuartzCoreHomeController.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/4/9.
//

#import "BCQuartzCoreHomeController.h"
#import "BCClockViewController.h"

@interface BCQuartzCoreHomeController ()

@end


@implementation BCQuartzCoreHomeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"QuartzCore";
    
    NSMutableArray *tmpArray = @[
        @{
            kFirstLevel : @"一、CALayer",
            kSecondLevel : @[
                    @"Position、AnchorPoint",
                    @"CATransform3D",
                    @"隐式动画",
                    @"综合应用：时钟的实现",
            ]
        },
        @{
            kFirstLevel : @"二、核心动画",
            kSecondLevel : @[
                    @"CABasicAnimation（基础动画，继承自：CAPropetyAnimation --> CAAnimation）",
                    @"CAKeyFrameAnimation（关键帧动画，继承自：CAPropetyAnimation --> CAAnimation）",
                    @"CAAnimationGroup（动画组，继承自：CAAnimation）",
                    @"CATransition（主要用于转场动画，继承自：CAAnimation）",
            ]
        },
    ].mutableCopy;
    
    [self.dataArray addObjectsFromArray:tmpArray];
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
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
                BCClockViewController *tmpVC = [[BCClockViewController alloc] init];
                [self.navigationController pushViewController:tmpVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
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
                
            }
                break;
            case 4: {
                
            }
                break;
            case 5: {
                
            }
                break;
            case 6: {
                
            }
                break;
                
            default:
                break;
        }
    }
}

@end
