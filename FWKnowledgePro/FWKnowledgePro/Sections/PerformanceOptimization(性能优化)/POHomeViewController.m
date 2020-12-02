//
//  POHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/12/1.
//  参考：https://www.jianshu.com/p/fe566ec32d28

#import "POHomeViewController.h"

@interface POHomeViewController ()

@end

@implementation POHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"性能优化";
    
    NSMutableArray *tmpArray = @[
        @"卡顿优化",
        @"耗电优化",
        @"启动优化",
        @"安装包瘦身",
    ].mutableCopy;
    
    [self.titleArray addObjectsFromArray:tmpArray];
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     CPU（Central Processing Unit，中央处理器）
     GPU（Graphics Processing Unit，图形处理器）
     FPS（Frames Per Second，每秒传输帧数）
     
     显示信息的过程：CPU 计算数据 -> GPU 进行渲染 -> 屏幕发出垂直同步信号(Vertical Synchronization) -> 成像
     
     */
    
    UIViewController *tmpVC = nil;
    switch (indexPath.row) {
        case 0: {
            /**
             卡顿优化：
             CPU层面：
             1、耗时操作放入子线程，如：文本的尺寸计算、绘制，图片的解码、绘制等；
             2、控制线程的最大并发数量；
             3、尽量采用轻量级的对量，如：不用处理是的UI控件可以考虑使用CALayer；
             4、不要频繁的调用UIView的相关属性，如：frame、bounds、transform等；
             5、尽量提前计算好布局，在有需要的时候一次性调整对应的属性（可以考虑缓存）；
             6、Autolayout会比直接设置frame消耗更多的CPU资源；
             7、图片的size和UIImageView的size尽量保持一致；
             GPU层面：
             1、尽量避免短时间内大量图片的显示；
             2、GPU能处理的最大纹理尺寸是4096*4096，超过这个尺寸就会暂用CPU资源，所以纹理尽量不超过这个尺寸；
             3、尽量较少透视图的数量和层次；
             4、减少透明的视图（alpha<1）；
             5、尽量避免离屏渲染；
             
             离屏渲染：
             On-Screen Rendering：当前屏幕渲染，在当前屏幕缓冲区进行渲染操作；
             Off-Screen Rendering：离屏渲染，在当前屏幕缓冲区外开辟新的缓冲区进行渲染操作；
             
             离屏渲染消耗性能的原因：离屏渲染的整个过程，需要多次切换上下文环境
             
             哪些操作会触发离屏渲染：
             光栅化，layer.shouldRasterize = YES
             遮罩，layer.mask
             圆角，同时设置 layer.masksToBounds = YES，layer.cornerRadius > 0，可以用 CoreGraphics 绘制裁剪圆角
             阴影，如果设置了 layer.shadowPath 不会产生离屏渲染
             */
        }
            break;
        case 1: {
            /**
             耗电的主要来源为：
             CPU处理
             网络请求
             定位
             图像渲染
             
             优化思路：
             1、尽可能降低 CPU、GPU 功耗；
             2、少用定时器；
             3、优化 I/O 操作；
             （1）尽量不要频繁写入小数据，最好一次性批量写入；
             （2）读写大量重要数据时，可以用 dispatch_io，它提供了基于 GCD 的异步操作文件的 API，使用该 API 会优化磁盘访问；
             （3）数据量大时，用数据库管理数据；
             4、网络优化
             （1）减少、压缩网络数据（JSON 比 XML 文件性能更高）；
             （2）若多次网络请求结果相同，尽量使用缓存；
             （3）使用断点续传，否则网络不稳定时可能多次传输相同的内容；
             （4）网络不可用时，不进行网络请求；
             （5）让用户可以取消长时间运行或者速度很慢的网络操作，设置合适的超时时间；
             （6）批量传输，如下载视频，不要传输很小的数据包，直接下载整个文件或者大块下载，然后慢慢展示；
             5、定位优化
             （1）如果只是需要快速确定用户位置，用 CLLocationManager 的 requestLocation （2）方法定位，定位完成后，定位硬件会自动断电；
             （3）若不是导航应用，尽量不要实时更新位置，并为完毕就关掉定位服务；
             （4）尽量降低定位精度，如不要使用精度最高的 KCLLocationAccuracyBest；
             （5）需要后台定位时，尽量设置 pausesLocationUpdatesAutomatically 为 YES，若用户不怎么移动的时候，系统会自暂停位置更新；
             */
        }
            break;
        case 2: {
            /**
             App 的启动分为两种：冷启动（Cold Launch） 和热启动（Warm Launch）
             
             App 启动的优化主要是针对冷启动的优化，通过添加环境变量可以打印出 App 的启动时间分析：Edit Scheme -> Run -> Arguments -> Environment Variables 添加 DYLD_PRINT_STATISTICS_DETAILS 设置为 1。
             */
        }
            break;
        case 3: {
            
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
