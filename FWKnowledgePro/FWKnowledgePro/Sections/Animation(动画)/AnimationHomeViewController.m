//
//  AnimationHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/2/24.
//

/**
 
 */

#import "AnimationHomeViewController.h"

@interface AnimationHomeViewController ()

/// 子视图
@property (nonatomic, strong) CALayer *subLayer;

@end


@implementation AnimationHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Animation";
    
    NSMutableArray *tmpArray = @[
        @"CALayer",
        @"CABasicAnimation（继承动画，继承自：CAPropetyAnimation）",
        @"CAKeyFrameAnimation（关键帧动画，继承自：CAPropetyAnimation）",
        @"CAAnimationGroup（动画组）",
        @"CATransition（主要用于转场动画）",
    ].mutableCopy;
    
    [self.titleArray addObjectsFromArray:tmpArray];
    
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.position = CGPointMake(UIScreen.mainScreen.bounds.size.width - 100, 50);
    layer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:layer];
    self.subLayer = layer;
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            // 形变属性（含隐式动画）
            
            // 平移
            self.subLayer.transform = CATransform3DMakeTranslation(50, 50, 0);
            // 缩放
            //            self.subLayer.transform = CATransform3DMakeScale(0.5, 1.0, 1.0);
            //            // 旋转
            //            self.subLayer.transform = CATransform3DMakeRotation(M_PI_4, 0, 0, 1);
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
            
        default:
            break;
    }
}

@end
