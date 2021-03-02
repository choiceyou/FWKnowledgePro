//
//  BasicHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/2/25.
//

/**
 const：可以修饰右侧的常量或者指针；
 
 static：
 （1）修饰局部变量（被static修饰的变量的生命周期与APP相同）；
    a.被static修饰的局部变量只会分配一次内存；
    b.被static修饰的局部变量，在程序一运行起来就会分配内存；
 （2）
 */

#import "BasicHomeViewController.h"

@interface BasicHomeViewController ()

@end

@implementation BasicHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"基础知识";
    
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
