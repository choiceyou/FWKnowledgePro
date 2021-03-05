//
//  OCHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2019/12/2.
//

#import "OCHomeViewController.h"
#import "BlockTestViewController.h"
#import "OCObjectSortViewController.h"
#import "OCObjectSortViewController.h"
#import "KVOHomeViewController.h"
#import "KVCHomeViewController.h"
#import "CategoryHomeViewController.h"

@interface OCHomeViewController ()

@end


@implementation OCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"OC语法部分";
    
    NSMutableArray *tmpArray = @[
        @"OC对象的本质：结构体指针；",
        @"OC对象的分类",
        @"对象消息机制",
        @"响应者链",
        @"Block",
        @"KVO",
        @"KVC",
        @"Category",
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
            tmpVC = [[OCObjectSortViewController alloc] init];
        }
            break;
        case 2: {
            
        }
            break;
        case 3: {
            /**
             响应者链
             
             手指触摸屏幕时系统检测到触摸（Touch）操作，此时，系统首先会找到响应者（UIResponder），将Touch以UIEvent的方式加入UIApplication事件队列中。UIApplication从事件队列中取出最前端的的触摸事件下发传递到UIWindow进行处理。UIWindow会通过 hitTest:withEvent: 方法寻找触摸点所在的视图。
             */
        }
            break;
        case 4: {
            tmpVC = [[BlockTestViewController alloc] init];
        }
            break;
        case 5: {
            tmpVC = [[KVOHomeViewController alloc] init];
        }
            break;
        case 6: {
            tmpVC = [[KVCHomeViewController alloc] init];
        }
            break;
        case 7: {
            tmpVC = [CategoryHomeViewController new];
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
