//
//  FWBaseTableViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2019/11/23.
//  

#import "FWBaseTableViewController.h"

// 重用标识符
static NSString *const kCellIdentifier = @"kCellIdentifier";


@interface FWBaseTableViewController ()

@end


@implementation FWBaseTableViewController

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.estimatedRowHeight = 44.f;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    NSString *tmpTitle = [NSString stringWithFormat:@"%ld、", indexPath.row];
    tmpTitle = [tmpTitle stringByAppendingString:[self.titleArray objectAtIndex:indexPath.row]];
    cell.textLabel.text = tmpTitle;
    cell.textLabel.numberOfLines = 0;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


#pragma mark -
#pragma mark - GET/SET

- (NSMutableArray<NSString *> *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[].mutableCopy;
    }
    return _titleArray;
}

@end
