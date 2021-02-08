//
//  KVOHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/8.
//

/**
 KVO（Key-Value Observing），俗称“键值监听”，可以用于监听某个对象属性值的变化；
 
 */

#import "KVOHomeViewController.h"

@interface KVOHomeViewController ()

@end

@implementation KVOHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
