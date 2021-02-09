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

@property (nonatomic, copy) NSString *copMutStr;
@property (nonatomic, strong) NSString *strongMutStr;

@end


@implementation OCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"OC语言部分";
    
    NSMutableArray *tmpArray = @[
        @"OC对象的本质",
        @"OC对象的分类",
        @"属性修饰符",
        @"对象消息机制",
        @"响应者链",
        @"进程与线程的区别",
        @"同步与异步的区别",
        @"并行与并发的区别",
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
            // 参考：https://www.jianshu.com/p/14c5bbb95846
            
            /**
             atomic：原子属性：已经是最小的一个操作单位（内存的读写），不可再划分；
             
             一、什么情况使用 weak 关键字，相比 assign 有什么不同？
             
             什么情况使用 weak 关键字？
             1、在 ARC 中,在有可能出现循环引用的时候,往往要通过让其中一端使用 weak 来解决,比如: delegate 代理属性；
             2、自身已经对它进行一次强引用,没有必要再强引用一次,此时也会使用 weak,自定义 IBOutlet 控件属性一般也使用weak；当然，也可以使用strong；
             
             有什么不同？
             1、weak此特质表明该属性定义了一种“非拥有关系” (nonowning relationship)。为这种属性设置新值时，设置方法既不保留新值，也不释放旧值。此特质同assign类似， 然而在属性所指的对象遭到摧毁时，属性值也会清空(nil out)。 而 assign的“设置方法”只会执行针对“纯量类型” (scalar type，例如 CGFloat 或 NSlnteger 等)的简单赋值操作；
             2、assigin 可以用非 OC 对象,而 weak 必须用于 OC 对象；
             
             
             二、property 的本质是什么？ivar、getter、setter 是如何生成并添加到这个类中的？
             @property = ivar + getter + setter;
             自动合成
             
             */
            
            NSMutableString *str = [NSMutableString stringWithFormat:@"123"];
            self.copMutStr = str;
            self.strongMutStr = str;
            [str appendString:@"abc"];
            NSLog(@"打印结果=%@", self.copMutStr);
            NSLog(@"打印结果=%@", self.strongMutStr);
        }
            break;
        case 3: {
            
        }
            break;
        case 4: {
            /**
             响应者链
             
             手指触摸屏幕时系统检测到触摸（Touch）操作，此时，系统首先会找到响应者（UIResponder），将Touch以UIEvent的方式加入UIApplication事件队列中。UIApplication从事件队列中取出最前端的的触摸事件下发传递到UIWindow进行处理。UIWindow会通过 hitTest:withEvent: 方法寻找触摸点所在的视图。
             */
        }
            break;
        case 5: {
            /**
             进程与线程的区别
             
             定义：
             1、进程：进程是程序关于某个数据集合的一次运行活动，是系统进行资源分配和调度的一个独立单位。每个进程之间是相互独立的，每个进程均运行在其专用的且受保护的内存中；
             2、线程：线程是进程的一个实体，是CPU调度和分派的基本单位，是比进程更小的能够独立运行的基本单元。线程基本上自己不拥有系统资源，只拥有一点在运行中必不可少的资源。一个线程可以创建可以撤销另外一个线程。
             
             关系：
             1、一个线程只能属于一个进程；而一个进程可以有多个线程（也就是多线程），但是至少有一个线程；
             2、资源是分配给进程的，同一进程中的所有线程可以共享这些资源；
             3、线程在执行过程中需要同步，不同进程间的线程利用消息通讯的办法来实现同步；
             4、真正在处理器上面运行的是线程；
             
             区别：
             1、调度：线程作为调度和分配的基本单元，而进程是作为拥有资源的基本单元；
             2、并发性：进程之间可以并发执行，同一个进程的多个线程之间也可以并发执行；
             3、资源：进程是拥有资源的一个独立单位，线程不拥有系统资源，但是可以访问隶属于进程的资源；
             4、系统开销：创建和撤销进程的开销比较大，因为在创建或撤销进程的时候系统需要分配或者回收资源。
             5、进程有独立的地址空间，进程在崩溃之后在保护模式下不会对其它的进程产生影响；而线程只是一个进程中的不同的执行路径，它没有独立的地址空间，所以一个线程死掉就等于整个进程死掉。因此，多进程的程序要比多线程的程序健壮，但是在程序切换的时候耗费的资源比较大，效率比较低；
             
             进程的同步机制：
             原子操作、信号量机制、自旋锁、分布式系统等；
             
             进程死锁的原因：造成进程死锁是由于资源竞争以及进程推进顺序非法。
             
             产生死锁的四个必要条件：
             （1）互斥：一个资源每次只能被一个进程使用；
             （2）请求与保持：一个进程因请求资源而阻塞时，对已获得的资源保持不放；
             （3）不剥夺：进程已获得的资源，在未使用完之前，不能强行剥夺；
             （4）循环等待：若干进程之前形成一种头尾相接的循环等待资源关系。
             
             死锁的处理策略：鸵鸟策略、预防策略、检测与解除死锁；
             
             */
        }
            break;
        case 6: {
            /**
             同步与异步的区别
             
             异步与同步是相对的，同步就是顺序执行，执行完一个在执行下一个，需要等待、协调。异步就是彼此独立，在执行某件事情的过程中可以继续做的另外一件事情。线程是实现异步的一种方法。异步是调用方法的主线程不需要同步等待另一线程的完成，从而可以让主线程赶其它的事情。
             异步和多线程并不是一个同等关系，异步是最终目的，多线程只是我们实现异步的一种手段。异步是当一个调用请求发送给被调用者，而调用者不用等待其结果的返回而可以做其它的事情。实现异步可以采用多线程技术或者交给另外的进程来处理。
             */
        }
            break;
        case 7: {
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
        case 8: {
            tmpVC = [[BlockTestViewController alloc] init];
        }
            break;
        case 9: {
            tmpVC = [[KVOHomeViewController alloc] init];
        }
            break;
        case 10: {
            tmpVC = [[KVCHomeViewController alloc] init];
        }
            break;
        case 11: {
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
