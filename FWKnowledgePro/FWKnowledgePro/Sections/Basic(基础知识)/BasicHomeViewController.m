//
//  BasicHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/2/25.
//

#import "BasicHomeViewController.h"

@interface BasicHomeViewController ()

@end


@implementation BasicHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"基础知识";
    
    NSMutableArray *tmpArray = @[
        @{
            kFirstLevel : @"一、沙盒",
            kSecondLevel : @[
                    @"Documents",
                    @"Library",
                    @"tmp",
                    @"SystemData",
            ]
        },
        @{
            kFirstLevel : @"一、几个修饰关键字",
            kSecondLevel : @[
                    @"static",
                    @"const",
                    @"extern",
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
                 Documents：
                 1、使用该目录主要是存储用户的相关数据，这个目录下的文件可以通过文件共享提供给用户，因此这个目录下最好只存储app希望公开给用户的数据信息；
                 2、这个目录的内容会被itunes或者icould进行备份；
                 */
            }
                break;
            case 1: {
                /**
                 Library：
                 1、主要是存储与用户数据无关的数据（一般是不想共享给用户的数据）。app也可以在这个目录下创建自己的目录；
                    a. preferences：偏好设置。保存账号等信息；
                    b. caches：保存缓存文件；
                 2、一般图片的缓存，数据缓存都可以放在这个caches子目录下；
                 3、系统提供的数据存储nsuserdefault生成的plist文件，是放在preference目录下的；
                 4、需要注意的是：itunes和icloud会备份除了caches文件夹外的其他内容；
                 */
            }
                break;
            case 2: {
                /**
                 tmp：
                 1、存放一些临时文件。这个目录下的数据在app不运行的时候都可能会被清除，因此对于可能还需要用到的数据，需要及早备份，如果不需要可以直接清理掉；
                 2、这个目录下的内容不会被itunes或者是icould备份；
                 */
            }
                break;
            case 3: {
                
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: {
                /**
                 static：
                 （1）修饰局部变量（被static修饰的变量的生命周期与APP相同）；
                    a.被static修饰的局部变量只会分配一次内存；
                    b.被static修饰的局部变量，在程序一运行起来就会分配内存；
                 （2）
                 */
            }
                break;
            case 1: {
                /**
                 const：可以修饰右侧的常量或者指针；
                 */
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
