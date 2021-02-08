//
//  OCObjectSortViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/8.
//

#import "OCObjectSortViewController.h"

@interface OCObjectSortViewController ()

@end

@implementation OCObjectSortViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *tmpArray = @[
        @"instance对象（实例对象）",
        @"class对象（类对象）",
        @"meta-class对象（元类对象）",
    ].mutableCopy;
    
    [self.titleArray addObjectsFromArray:tmpArray];
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
