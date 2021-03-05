//
//  NetHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/3/4.
//

/**
 客户端网络请求过程：
 1、客户端请求dns服务器换回IP地址；
 2、TCP三次握手建立连接；
 3、发送http的head数据；
 4、发一段空行；
 5、发送http的body数据；
 
 服务器接收到我们数据：
 1、处理、封装http数据；
 2、发送http的head数据；
 3、发一段空行；
 4、发送http的body数据；
 */


/**
 只需了解的：
 
 广域网：跨区域的网络，如：因特网、城域网；
 局域网：内部网络；
 */

#import "NetHomeViewController.h"
#import "NetTestViewController.h"

@interface NetHomeViewController ()

@end


@implementation NetHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"网络";
    
    NSMutableArray *tmpArray = @[
        @{
            kFirstLevel : @"一、参考模型",
            kSecondLevel : @[
                    @"ISO参考模型：应用层、表示层、会话层、传输层、网络层、数据链路层、物理层；",
                    @"TCP/IP参考模型：应用层HTTP、传输层TCP/UDP、网络互连层（IP层）、网络接口层;",
            ]
        },
        @{
            kFirstLevel : @"二、协议",
            kSecondLevel : @[
                    @"TCP：传输控制协议（Transmission Control Protocol），是一种面向连接的、可靠的、基于字节流的传输层通信协议；",
                    @"UDP：用户数据报协议（User Datagram Protocol），为应用程序提供了一种无需建立连接就可以发送封装的IP数据包的方法；",
            ]
        },
        @{
            kFirstLevel : @"三、网络实践",
            kSecondLevel : @[
                    @"NSURLSession 实践",
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
                
            }
                break;
            case 1: {
                
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: {
                /**
                 TCP在传输层分段传输；
                 
                 TCP三次握手：
                 1、客户主动（active open）去connect服务器，并且发送SYN，假设序列号为J，服务器是被动打开(passive open)；
                 2、服务器在收到SYN后，它会发送一个SYN以及一个ACK（应答）给客户，ACK的序列号是 J+1表示是给SYN J的应答，新发送的SYN K，序列号是K；
                 3、客户在收到新SYN K, ACK J+1 后，也回应ACK K+1 以表示收到了，然后两边就可以开始数据发送数据了；
                 */
            }
                break;
            case 1: {
                /**
                 UDP在IP层（网络层）分片传输；
                 */
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0: {
                tmpVC = [[NetTestViewController alloc] init];
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
