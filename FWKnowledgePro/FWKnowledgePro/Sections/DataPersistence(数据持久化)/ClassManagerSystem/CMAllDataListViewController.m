//
//  CMAllDataListViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/11/25.
//

#import "CMAllDataListViewController.h"
#import "FWDataBaseManager.h"
#import "ClassTestModel.h"
#import "StudentTestModel.h"

// 重用标识符
static NSString *const kCellIdentifier = @"kCellIdentifier";


@interface CMAllDataListViewController ()

/// 数据源
@property (nonatomic, strong) NSMutableArray<ClassTestModel *> *dataArray;

@end


@implementation CMAllDataListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"全校学生列表";
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
    ClassTestModel *ctModel = [self.dataArray objectAtIndex:section];
    return ctModel.studentArray.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ClassTestModel *ctModel = [self.dataArray objectAtIndex:section];
    return ctModel.name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    ClassTestModel *ctModel = [self.dataArray objectAtIndex:indexPath.section];
    StudentTestModel *stModel = [ctModel.studentArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld、%@ - %@", indexPath.row, stModel.name, stModel.hobby];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        ClassTestModel *ctModel = [self.dataArray objectAtIndex:indexPath.section];
        StudentTestModel *stModel = [ctModel.studentArray objectAtIndex:indexPath.row];
        [FWDataBaseInstance deleteStudent:stModel cls:ctModel];
        [ctModel.studentArray removeObject:stModel];
        [self.tableView reloadData];
        completionHandler (YES);
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}


#pragma mark -
#pragma mark - GET/SET

- (NSMutableArray<ClassTestModel *> *)dataArray
{
    if (!_dataArray) {
        _dataArray = [FWDataBaseInstance requestAllData];
    }
    return _dataArray;
}

@end
