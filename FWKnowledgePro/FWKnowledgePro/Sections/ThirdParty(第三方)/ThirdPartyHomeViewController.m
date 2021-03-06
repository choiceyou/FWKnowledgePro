//
//  ThirdPartyHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/3/5.
//

#import "ThirdPartyHomeViewController.h"
#import <SDWebImage/SDWebImage.h>

@interface ThirdPartyHomeViewController ()

@end


@implementation ThirdPartyHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"常用第三方";
    
    NSMutableArray *tmpArray = @[
        @{
            kFirstLevel : @"一、SDWebImage",
            kSecondLevel : @[
                    @"SDWebImageDownloaderConfig配置参数",
                    @"发生内存警告后，如何操作？",
                    @"缓存文件的名称如何处理？",
                    @"该框架进行缓存处理的方式？",
                    @"如何判断图片类型？"
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
                /**
                 SDWebImageDownloaderConfig配置参数：
                 maxConcurrentDownloads：最大并发数（默认：6）；
                 executionOrder：队列中任务处理的顺序（默认：FIFO）；
                 downloadTimeout：超时时间；
                 */
            }
                break;
            case 1: {
                /**
                 发生内存警告后，如何操作？
                 可以在AppDelegate中做清空缓存等操作
                 */
                [[SDWebImageManager sharedManager].imageCache clearWithCacheType:SDImageCacheTypeAll completion:nil];
                [[SDWebImageManager sharedManager] cancelAll];
            }
                break;
            case 2: {
                /**
                 缓存文件的名称如何处理？
                 拿到图片的URL路径，对该路径进行MD5加密；
                 */
            }
                break;
            case 3: {
                /**
                 该框架进行缓存处理的方式？
                 NSCache
                 */
            }
                break;
            case 4: {
                /**
                 如何判断图片类型？
                 匹配图片二进制数据的第一个字节
                 */
            }
                break;
            case 5: {
                
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
                
            default:
                break;
        }
    }
}

@end
