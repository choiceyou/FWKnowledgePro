//
//  FWBaseLevelTableViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/3/4.
//

#import "FWBaseLevelTableViewController.h"

// 重用标识符
static NSString *const kCellIdentifier = @"kCellIdentifier";

NSString *const kFirstLevel = @"kFirstLevel";
NSString *const kSecondLevel = @"kSecondLevel";


@interface FWBaseLevelTableViewController ()

@end


@implementation FWBaseLevelTableViewController

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
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *tmpDict = [self.dataArray objectAtIndex:section];
    if (tmpDict && [tmpDict isKindOfClass:[NSDictionary class]]) {
        NSArray *tmpArray = [tmpDict objectForKey:kSecondLevel];
        return tmpArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *tmpDict = [self.dataArray objectAtIndex:indexPath.section];
    if (tmpDict && [tmpDict isKindOfClass:[NSDictionary class]]) {
        NSArray *tmpArray = [tmpDict objectForKey:kSecondLevel];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld、%@", indexPath.row, [tmpArray objectAtIndex:indexPath.row]];
        cell.textLabel.numberOfLines = 0;
    }
    
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *tmpDict = [self.dataArray objectAtIndex:section];
    if (tmpDict && [tmpDict isKindOfClass:[NSDictionary class]]) {
        return [tmpDict objectForKey:kFirstLevel];
    }
    return @"";
}


#pragma mark -
#pragma mark - GET/SET

- (NSMutableArray<NSDictionary *> *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

@end
