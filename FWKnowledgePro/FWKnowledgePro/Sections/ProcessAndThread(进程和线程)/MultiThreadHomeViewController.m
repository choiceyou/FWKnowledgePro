//
//  MultiThreadHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2019/12/1.
//

/**
 产生死锁的四个必要条件：
 （1）互斥：一个资源每次只能被一个进程使用；
 （2）请求与保持：一个进程因请求资源而阻塞时，对已获得的资源保持不放；
 （3）不剥夺：进程已获得的资源，在未使用完之前，不能强行剥夺；
 （4）循环等待：若干进程之前形成一种头尾相接的循环等待资源关系。
 
 死锁的处理策略：鸵鸟策略、预防策略、检测与解除死锁；
 */

#import "MultiThreadHomeViewController.h"
#import "NSThreadTestViewController.h"
#import "NSOperationTestViewController.h"
#import "GCDTestViewController.h"
#import "ThreadSyncViewController.h"
#import "FWBaseWebViewController.h"

@interface MultiThreadHomeViewController ()

@end


@implementation MultiThreadHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"进程与线程";
    
    NSMutableArray *tmpArray = @[
        @{
            kFirstLevel : @"一、进程与线程",
            kSecondLevel : @[
                    @"进程：进程是程序关于某个数据集合的一次运行活动，是系统进行资源分配和调度的一个独立单位。每个进程之间是相互独立的，每个进程均运行在其专用的且受保护的内存中；",
                    @"线程：线程是进程的一个实体，是CPU调度和分派的基本单位，是比进程更小的能够独立运行的基本单元。线程基本上自己不拥有系统资源，只拥有一点在运行中必不可少的资源。一个线程可以创建可以撤销另外一个线程",
                    @"进程与线程的关系",
                    @"进程与线程的区别",
            ]
        },
        @{
            kFirstLevel : @"二、进程",
            kSecondLevel : @[
                    @"三个基本状态 - 就绪状态",
                    @"三个基本状态 - 执行状态",
                    @"三个基本状态 - 睡眠状态（阻塞状态）",
            ]
        },
        @{
            kFirstLevel : @"三、线程",
            kSecondLevel : @[
                    @"NSThread（使用更加面向对象）",
                    @"GCD（充分利用设备的多核）",
                    @"NSOperation（基于GCD，比GCD多了一些简单实用的功能；使用更加面向对象）",
                    @"iOS中线程同步方案（买票、存钱示例）",
                    @"线程：同步与异步的区别",
                    @"线程：并行与并发的区别",
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
                /**
                 参考：就绪状态
                 
                 进程：进程是独立运行、独立分配资源和独立接受调度的基本单位；
                 
                 一个APP中可以有多个进程，如：开启Mac版QQ后，通过活动监视器查看QQ进程情况，可以发现有一个QQ进程，还有一个QQ jietu plugin 进程；
                 
                 进程的同步机制：
                 原子操作、信号量机制、自旋锁、分布式系统等；
                 
                 进程死锁的原因：造成进程死锁是由于资源竞争以及进程推进顺序非法。
                 
                 多线程与多进程的对比：
                 1、进程之间不能共享内存，线程可以；
                 2、系统创建进程的时候要为其分配系统资源，而创建线程则只需要很小一部分，因此多线程比多进程来的更加容易；
                 3、多线程可以充分利用处理器（双核或者多核），但是当线程数量达到上限的时候，性能就不在提升了；
                 4、多线程的进程，只要一个线程崩溃了就会导致进程崩溃。如果是主线程崩溃会导致程序崩溃；
                 5、多线程需要控制线程之间的同步，而多进程则需要控制和主进程之间的交互；
                 6、如果两个进程之间要相互传输大量的数据，会相当影响性能，多进程适合小数据量传输，密集运算；
                 */
            }
                break;
            case 1: {
                
            }
                break;
            case 2: {
                /**
                 进程与线程的关系：
                 1、一个线程只能属于一个进程；而一个进程可以有多个线程（也就是多线程），但是至少有一个线程；
                 2、资源是分配给进程的，同一进程中的所有线程可以共享这些资源；
                 3、线程在执行过程中需要同步，不同进程间的线程利用消息通讯的办法来实现同步；
                 4、真正在处理器上面运行的是线程；
                 */
            }
                break;
            case 3: {
                /**
                 进程与线程的区别：
                 1、调度：线程作为调度和分配的基本单元，而进程是作为拥有资源的基本单元；
                 2、并发性：进程之间可以并发执行，同一个进程的多个线程之间也可以并发执行；
                 3、资源：进程是拥有资源的一个独立单位，线程不拥有系统资源，但是可以访问隶属于进程的资源；
                 4、系统开销：创建和撤销进程的开销比较大，因为在创建或撤销进程的时候系统需要分配或者回收资源。
                 5、进程有独立的地址空间，进程在崩溃之后在保护模式下不会对其它的进程产生影响；而线程只是一个进程中的不同的执行路径，它没有独立的地址空间，所以一个线程死掉就等于整个进程死掉。因此，多进程的程序要比多线程的程序健壮，但是在程序切换的时候耗费的资源比较大，效率比较低；
                 */
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0: {
                NSString *str = @"当进已分配到除CPU外的所有必要资源后，只要再获得CPU，便可立即执行，进程这时的状态称为就绪状态。在系统中处于就绪状态的进程往往会有多个，通常将这些进程存入一个队列中，称为就绪队列。";
                tmpVC = [FWBaseWebViewController webVCWithContent:str title:@"进程 - 就绪状态"];
            }
                break;
            case 1: {
                /**
                 执行状态：
                 进程已获得CPU，其程序正在执行。
                 */
            }
                break;
            case 2: {
                /**
                 睡眠状态（阻塞状态）：
                 正在执行的进程由于某些事件暂时无法继续执行，便放弃CPU占用转入暂停。阻塞状态的进程也会排入队列中，现代操作系统会根据阻塞原因的不同将处于阻塞状态的进程排入多个队列。导致阻塞的事件有：请求I/O，申请缓冲空间。
                 */
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0: {
                tmpVC = [[NSThreadTestViewController alloc] init];
            }
                break;
            case 1: {
                tmpVC = [[GCDTestViewController alloc] init];
            }
                break;
            case 2: {
                tmpVC = [[NSOperationTestViewController alloc] init];
            }
                break;
            case 3: {
                tmpVC = [[ThreadSyncViewController alloc] init];
            }
                break;
            case 4: {
                /**
                 同步与异步的区别
                 
                 异步与同步是相对的，同步就是顺序执行，执行完一个在执行下一个，需要等待、协调。异步就是彼此独立，在执行某件事情的过程中可以继续做的另外一件事情。线程是实现异步的一种方法。异步是调用方法的主线程不需要同步等待另一线程的完成，从而可以让主线程赶其它的事情。
                 异步和多线程并不是一个同等关系，异步是最终目的，多线程只是我们实现异步的一种手段。异步是当一个调用请求发送给被调用者，而调用者不用等待其结果的返回而可以做其它的事情。实现异步可以采用多线程技术或者交给另外的进程来处理。
                 */
            }
                break;
            case 5: {
                /**
                 并行与并发的区别
                 
                 并发性（Concurrence）：指两个或两个以上的事情或活动在同一时间间隔内发生。
                 并行性（Parallelism）：指两个或两个以上的事情或活动在同一时刻发生。在多核程序环境下，并行性使得多个程序可以同一时刻在不同CPU上同时执行。
                 区别：一个处理器同时处理多个任务和多个处理器或者是多核的处理器同时处理多个不同的任务。
                 前者是逻辑上的同时发生（simultaneous），而后者是物理上的同时发生。
                 两者的联系：并行的事件或活动一定是并发的，但反之并发的事件或活动未必是并行的。并行性是并发性的特例，而并发性是并行性的扩展。
                 */
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
