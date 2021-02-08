//
//  MemoryHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/4.
//

/**
 函数调用完毕：栈平衡（栈内存释放了）；
 NULL：表示空地址；
 nil：表示空指针；
 C语言的函数中：create、new、copy都会默认开辟堆空间（即：调用malloc）；
 堆：低地址往高地址走； 
 栈：高地址往低地址走；
 */

#import "MemoryHomeViewController.h"

@interface MemoryHomeViewController ()

@end


@implementation MemoryHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"MemoryManage";
    
    NSMutableArray *tmpArray = @[
        
    ].mutableCopy;
    
    [self.titleArray addObjectsFromArray:tmpArray];
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
