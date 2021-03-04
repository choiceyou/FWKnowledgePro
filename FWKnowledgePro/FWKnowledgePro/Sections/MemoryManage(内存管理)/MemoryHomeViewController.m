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
 
 几个概念：
 1、僵尸对象：所占用内存已经被回收的对象，僵尸对象不能再使用（引用计数为0）；
 2、野指针：指向僵尸对象（不可用内存）的指针，给野指针发送消息会报错（EXC_BAD_ACCESS）；
 3、空指针：没有指向任何东西的指针（存储的东西是nil、NULL、0之类的），给空指针发送消息不会报错；
 
 基本数据类型是不需要管理内存的
 
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
        @"autoreleasepool",
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
