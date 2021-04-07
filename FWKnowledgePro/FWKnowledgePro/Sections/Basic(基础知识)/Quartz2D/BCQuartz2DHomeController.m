//
//  BCQuartz2DHomeController.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/4/6.
//

#import "BCQuartz2DHomeController.h"
#import <Masonry/Masonry.h>
#import "BCGestureLockViewController.h"
#import "BCDrawingBoardViewController.h"

@interface BCQuartz2DHomeController ()

/// 临时显示图片
@property (nonatomic, weak) UIImageView *showImgView;

@end

@implementation BCQuartz2DHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Quartz2D";
    
    NSMutableArray *tmpArray = @[
        @{
            kFirstLevel : @"一、使用",
            kSecondLevel : @[
                    @"线条绘制",
                    @"饼图",
                    @"图形上下文",
                    @"图片添加水印",
                    @"图片裁剪",
                    @"手势解锁",
                    @"画板",
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
                
            }
                break;
            case 4: {
                if (_showImgView) {
                    [self.showImgView removeFromSuperview];
                } else {
                    // 1、加载图片
                    UIImage *image = [UIImage imageNamed:@"参考模型"];
                    // 2、开启图形上线文
                    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
                    // 3、绘制路径
                    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
                    [clipPath addClip];
                    // 4、把图片绘制到上下文当中
                    [image drawAtPoint:CGPointZero];
                    // 5、从图形上下文中获取一张新的图片
                    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
                    // 6、关闭图形上线文
                    UIGraphicsEndImageContext();
                    
                    self.showImgView.image = newImg;
                }
            }
                break;
            case 5: {
                BCGestureLockViewController *tmpVC = [[BCGestureLockViewController alloc] init];
                [self.navigationController pushViewController:tmpVC animated:YES];
            }
                break;
            case 6: {
                BCDrawingBoardViewController *tmpVC = [[BCDrawingBoardViewController alloc] init];
                [self.navigationController pushViewController:tmpVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}


#pragma mark -
#pragma mark - GET/SET

- (UIImageView *)showImgView
{
    if (!_showImgView) {
        CGFloat tmpW = [UIScreen mainScreen].bounds.size.width / 2;
        UIImageView *tmpImgView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - tmpW, 0, tmpW, tmpW)];
        [self.view addSubview:tmpImgView];
        
        _showImgView = tmpImgView;
    }
    return _showImgView;
}

@end
