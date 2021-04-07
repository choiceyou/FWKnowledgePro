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
 
 
 一些概念：
 1、URL（Uniform Resource Locator）：统一资源定位符。基本格式 = 协议://主机地址/路径；
 2、协议：不同的协议，代表着不同的资源查找或传输方式；
 3、主机地址：存放资源的主机（服务器）的IP地址（域名）；
 4、路径：资源在主机（服务器）中的具体位置；
 
 二、端口号：每个应用程序有很多服务，每一个服务对应着一个端口号；
 1、计算机里面：49151以上的端口号都可以自己修改；
 2、49151以下的是系统固定的端口（跟硬件相关，比如：80端口：为HTTP服务；443端口：为HTTPS服务，339端口：为远程协助服务）；
 
 
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
                    @"IP：网络之间互连的协议（Internet Protocol），网络层协议。IP只为主机提供一种无连接、不可靠的、尽力而为的数据包传输服务；",
                    @"TCP：传输控制协议（Transmission Control Protocol），传输层协议。是一种面向连接的、可靠的、基于字节流的传输层通信协议；",
                    @"UDP：用户数据报协议（User Datagram Protocol），传输层协议。为应用程序提供了一种无需建立连接就可以发送封装的IP数据包的方法；",
            ]
        },
        @{
            kFirstLevel : @"三、URL中常见的协议",
            kSecondLevel : @[
                    @"HTTP：超文本传输协议（Hypertext Transfer Protocol），应用层协议；",
                    @"HTTPS：（Hypertext Transfer Protocol over SecureSocket Layer）以安全为目标的 HTTP 通道，在HTTP的基础上通过传输加密和身份认证保证了传输过程的安全性；",
                    @"file：访问的是本地计算机上的资源，格式为：file://",
                    @"FTP：访问的是共享主机的文件资源，格式为：ftp://",
                    @"mailto：访问的是电子右键地址，格式为：mailto:",
            ]
        },
        @{
            kFirstLevel : @"四、HTTP请求方法（总计有9种）：每种请求方法规定了客户和服务器之间不同的信息交换方式",
            kSecondLevel : @[
                    @"GET：请求指定页面的信息，并返回实体主体（幂等）；",
                    @"POST：向指定资源提交数据进行处理请求，数据存在请求体（非幂等）；",
                    @"HEAD：类似GET，但不返回具体内容，用于获取报头（幂等）；",
                    @"PUT：完整替换更新指定资源数据，没有就新增（幂等）；",
                    @"DELETE：删除指定资源的数据（幂等）；",
                    @"PATCH：部分更新指定资源的数据（非幂等）；",
                    @"OPTIONS：允许客户端查看服务器的支持的http请求方法；",
                    @"CONNECT：预留给能将连接改为管道的代理服务器；",
                    @"TRACE：追踪服务器收到的请求，用于测试或诊断；",
            ]
        },
        @{
            kFirstLevel : @"五、网络实践",
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
                 IP主要包含三方面内容：IP编址方案、分组封装格式、分组转发规则。
                 */
            }
                break;
            case 1: {
                /**
                 TCP在传输层分段传输；
                 
                 TCP三次握手：
                 1、客户主动（active open）去connect服务器，并且发送SYN，假设序列号为J，服务器是被动打开(passive open)；
                 2、服务器在收到SYN后，它会发送一个SYN以及一个ACK（应答）给客户，ACK的序列号是 J+1表示是给SYN J的应答，新发送的SYN K，序列号是K；
                 3、客户在收到新SYN K, ACK J+1 后，也回应ACK K+1 以表示收到了，然后两边就可以开始数据发送数据了；
                 */
                
                /**
                 一、TCP的三次握手四次挥手：
                 TCP是一种面向连接的、可靠的、基于字节流的传输层通信协议，在发送数据前，通信双方必须在彼此间建立一条连接。所谓的“连接”，其实是客户端和服务端保存的一份关于对方的信息，如ip地址、端口号等。

                 TCP可以看成是一种字节流，它会处理IP层或以下的层的丢包、重复以及错误问题。在连接的建立过程中，双方需要交换一些连接的参数。这些参数可以放在TCP头部。

                 一个TCP连接由一个4元组构成，分别是两个IP地址和两个端口号。一个TCP连接通常分为三个阶段：连接、数据传输、退出（关闭）。通过三次握手建立一个链接，通过四次挥手来关闭一个连接。

                 当一个连接被建立或被终止时，交换的报文段只包含TCP头部，而没有数据。

                 二、常见面试题：
                 1、为什么TCP连接的时候是3次？2次不可以吗？
                 答：因为需要考虑连接时丢包的问题，如果只握手2次，第二次握手时如果服务端发给客户端的确认报文段丢失，此时服务端已经准备好了收发数(可以理解服务端已经连接成功)据，而客户端一直没收到服务端的确认报文，所以客户端就不知道服务端是否已经准备好了(可以理解为客户端未连接成功)，这种情况下客户端不会给服务端发数据，也会忽略服务端发过来的数据。
                 如果是三次握手，即便发生丢包也不会有问题，比如如果第三次握手客户端发的确认ack报文丢失，服务端在一段时间内没有收到确认ack报文的话就会重新进行第二次握手，也就是服务端会重发SYN报文段，客户端收到重发的报文段后会再次给服务端发送确认ack报文。

                 2、为什么TCP连接的时候是3次，关闭的时候却是4次？
                 答：因为只有在客户端和服务端都没有数据要发送的时候才能断开TCP。而客户端发出FIN报文时只能保证客户端没有数据发了，服务端还有没有数据发客户端是不知道的。而服务端收到客户端的FIN报文后只能先回复客户端一个确认报文来告诉客户端我服务端已经收到你的FIN报文了，但我服务端还有一些数据没发完，等这些数据发完了服务端才能给客户端发FIN报文(所以不能一次性将确认报文和FIN报文发给客户端，就是这里多出来了一次)。

                 3、为什么客户端发出第四次挥手的确认报文后要等2MSL的时间才能释放TCP连接？
                 答：这里同样是要考虑丢包的问题，如果第四次挥手的报文丢失，服务端没收到确认ack报文就会重发第三次挥手的报文，这样报文一去一回最长时间就是2MSL，所以需要等这么长时间来确认服务端确实已经收到了。

                 4、如果已经建立了连接，但是客户端突然出现故障了怎么办？
                 答：TCP设有一个保活计时器，客户端如果出现故障，服务器不能一直等下去，白白浪费资源。服务器每收到一次客户端的请求后都会重新复位这个计时器，时间通常是设置为2小时，若两小时还没有收到客户端的任何数据，服务器就会发送一个探测报文段，以后每隔75秒钟发送一次。若一连发送10个探测报文仍然没反应，服务器就认为客户端出了故障，接着就关闭连接。
                 */
            }
                break;
            case 2: {
                /**
                 UDP在IP层（网络层）分片传输；
                 
                 二、概念： （1）UDP是一个非连接的协议，传输数据之前源端和终端不建立连接，当它想传送时就简单地去抓取来自应用程序的数据，并尽可能快地把它扔到网络上。在发送端，UDP传送数据的速度仅仅是受应用程序生成数据的速度、计算机的能力和传输带宽的限制；在接收端，UDP把每个消息段放在队列中，应用程序每次从队列中读一个消息段；
                 （2）由于传输数据不建立连接，因此也就不需要维护连接状态，包括收发状态等，因此一台服务机可同时向多个客户机传输相同的消息；
                 （3）UDP信息包的标题很短，只有8个字节，相对于TCP的20个字节信息包的额外开销很小；
                 （4）吞吐量不受拥挤控制算法的调节，只受应用软件生成数据的速率、传输带宽、源端和终端主机性能的限制；
                 （5）UDP使用尽最大努力交付，即不保证可靠交付，因此主机不需要维持复杂的链接状态表（这里面有许多参数）；
                 （6）UDP是面向报文的。发送方的UDP对应用程序交下来的报文，在添加首部后就向下交付给IP层。既不拆分，也不合并，而是保留这些报文的边界，因此，应用程序需要选择合适的报文大小。
                 */
                
                /**
                 三、TCP、UDP适用场景：

                 两种协议都是传输层协议，为应用层提供信息载体。

                 TCP协议是基于连接的可靠协议，有流量控制和差错控制，也正因为有可靠性的保证和控制手段，所以传输效率比UDP低；UDP协议是基于无连接的不可靠协议，没有控制手段，仅仅是将数据发送给对方，因此效率比TCP要高。

                 基于上述特性，不难得到结论，TCP协议适用于对效率要求相对低，但对准确性要求相对高的场景下，或者是有一种连接概念的场景下；而UDP协议适用于对效率要求相对高，对准确性要求相对低的场景。

                 使用场景：
                 （1）TCP一般用于文件传输（FTP HTTP 对数据准确性要求高，速度可以相对慢），发送或接收邮件（POP IMAP SMTP 对数据准确性要求高，非紧急应用），远程登录（TELNET SSH 对数据准确性有一定要求，有连接的概念）等等；
                 （2）UDP一般用于即时通信（QQ聊天 对数据准确性和丢包要求比较低，但速度必须快），在线视频（RTSP 速度一定要快，保证视频连续，但是偶尔花了一个图像帧，人们还是能接受的），网络语音电话（VoIP 语音数据包一般比较小，需要高速发送，偶尔断音或串音也没有问题）等等。作为知识的扩展，可以再说一些其他应用。比如，TCP可以用于网络数据库，分布式高精度计算系统的数据传输；UDP可以用于服务系统内部之间的数据传输，因为数据可能比较多，内部系统局域网内的丢包错包率又很低，即便丢包，顶多是操作无效，这种情况下，UDP经常被使用。
                 */
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0: {
                
            }
                break;
            case 1: {
                /**
                 一、HTTPS概念：
                 它用来在计算机网络上的两个端系统之间进行安全的交换信息(secure communication)，它相当于在HTTP的基础上加了一个Secure安全的词眼，那么我们可以给出一个HTTPS的定义：HTTPS是一个在计算机世界里专门在两点之间安全的传输文字、图片、音频、视频等超文本数据的约定和规范。在HTTPS中，使用传输层安全性(TLS)或安全套接字层(SSL)对通信协议进行加密。也就是 HTTP + SSL(TLS) = HTTPS。
                 TLS(Transport Layer Security) 是 SSL(Secure Socket Layer) 的后续版本，它们是用于在互联网两台计算机之间用于身份验证和加密的一种协议。TLS1.2常用。
                 
                 二、HTTPS 协议提供了三个关键的指标：
                 （1）加密(Encryption)， HTTPS 通过对数据加密来使其免受窃听者对数据的监听，这就意味着当用户在浏览网站时，没有人能够监听他和网站之间的信息交换，或者跟踪用户的活动，访问记录等，从而窃取用户信息；
                 （2）数据一致性(Data integrity)，数据在传输的过程中不会被窃听者所修改，用户发送的数据会完整的传输到服务端，保证用户发的是什么，服务器接收的就是什么；
                 （3）身份认证(Authentication)，是指确认对方的真实身份，也就是证明你是你（可以比作人脸识别），它可以防止中间人攻击并建立用户信任。
                 */
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
    } else if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0: {
                /**
                 GET与POST请求的区别？
                （1）GET参数放在地址栏中，POST参数放在请求主体中；
                （2）GET请求只发送一次TCP数据包（只发请求头），POST要发送两次TCP数据包（发请求头和请求体）；
                （3）GET请求能保存链接，但POST不行；
                （4）GET请求浏览器自动缓存，POST缓存要手动设置，所以GET请求刷新或后退不浪费资源，但POST会重新请求；
                （5）GET请求只支持URL编码，但POST支持多种编码；
                 */
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 4) {
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
