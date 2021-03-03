//
//  MemoryHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/4.
//

/**
 内存空间布局，地址由低到高依次为（可以参考截图）：
 （1）保留区；
 （2）代码区（_TEXT）：编译之后的代码；
 （3）数据段（_DATA）：字符串、已初始化的全局变量、静态变量等、未初始化的全局变量、静态变量等；
 （4）堆：通过malloc、alloc、calloc等动态分配的空间。分配的内存空间地址越来越大；
 （5）栈：函数调用开销，比如局部变量。分配的内存空间地址越来越小；
 （6）内核区；
 
 函数调用完毕：栈平衡（栈内存释放了）；
 NULL：表示空地址；
 nil：表示空指针；
 C语言的函数中：create、new、copy都会默认开辟堆空间（即：调用malloc）；
 
 拷贝的目的：产生一个副本对象，跟源对象互不影响（即：修改了源对象，不影响副本对象；修改了副本对象，不影响源对象）；
 iOS提供了2个拷贝方法：
 （1）copy：不可变拷贝，产生不可变副本；
 （2）mutableCopy：可变拷贝，产生可变副本；
 
 深拷贝和浅拷贝：
 （1）深拷贝：内容拷贝，产生新的对象；
 （2）浅拷贝：指针拷贝，没有产生新的对象；
 
 野指针错误（EXC_BAD_ACCESS）：指向僵尸对象（不可用内存）的指针；
 
 */

#import "MemoryHomeViewController.h"
#import "MMPropertyViewController.h"

@interface MemoryHomeViewController ()

@end


@implementation MemoryHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"MemoryManage";
    
    NSMutableArray *tmpArray = @[
        @"属性修饰符",
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
            tmpVC = [[MMPropertyViewController alloc] init];
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
