//
//  CMHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/11/24.
//

#import "CMHomeViewController.h"
#import "FWDataBaseManager.h"
#import "ClassTestModel.h"
#import "StudentTestModel.h"
#import "CMClassStudentViewController.h"
#import "CMAllDataListViewController.h"

// 重用标识符
static NSString *const kCellIdentifier = @"kCellIdentifier";


@interface CMHomeViewController ()

/// 数据源
@property (nonatomic, strong) NSMutableArray<ClassTestModel *> *dataArray;

@end


@implementation CMHomeViewController

- (void)dealloc
{
    [FWDataBaseManager releaseInstance];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"班级列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addData)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(showAllData)];
    self.navigationItem.rightBarButtonItems = @[item1, item2];
    
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    ClassTestModel *ctModel = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld、%@ - %@", indexPath.row, ctModel.name, ctModel.desc];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        ClassTestModel *ctModel = [self.dataArray objectAtIndex:indexPath.row];
        [FWDataBaseInstance deleteCls:ctModel];
        [FWDataBaseInstance deleteAllStudentFromClass:ctModel];
        [self.dataArray removeObject:ctModel];
        [self.tableView reloadData];
        completionHandler (YES);
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    
    UIContextualAction *updateRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"update" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        ClassTestModel *ctModel = [self.dataArray objectAtIndex:indexPath.row];
        ctModel.desc = [NSString stringWithFormat:@"班级幸运数：%ld", (long)arc4random_uniform(1000)];
        [FWDataBaseInstance updateCls:ctModel];
        [self.tableView reloadData];
        completionHandler (YES);
    }];
    updateRowAction.backgroundColor = [UIColor blackColor];
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction, updateRowAction]];
    return config;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassTestModel *ctModel = [self.dataArray objectAtIndex:indexPath.row];
    CMClassStudentViewController *tmpVC = [[CMClassStudentViewController alloc] init];
    tmpVC.ctModel = ctModel;
    [self.navigationController pushViewController:tmpVC animated:YES];
}


#pragma mark -
#pragma mark - Action

#pragma mark 添加数据到数据库
- (void)addData
{
    NSInteger gradeRandomNum  = arc4random_uniform(9) + 1;
    NSInteger classRandomNum  = arc4random_uniform(9) + 1;
    
    ClassTestModel *ctModel = [[ClassTestModel alloc] init];
    ctModel.name = [NSString stringWithFormat:@"%ld年%ld班", (long)gradeRandomNum, (long)classRandomNum];
    ctModel.desc = [NSString stringWithFormat:@"班级幸运数：%ld", (long)arc4random_uniform(1000)];
    
    [FWDataBaseInstance addCls:ctModel];
    self.dataArray = [FWDataBaseInstance requestAllClasses];
    [self.tableView reloadData];
}

#pragma mark 显示所有班级学生数据
- (void)showAllData
{
    CMAllDataListViewController *tmpVC = [[CMAllDataListViewController alloc] init];
    [self.navigationController pushViewController:tmpVC animated:YES];
}


#pragma mark -
#pragma mark - GET/SET

- (NSMutableArray<ClassTestModel *> *)dataArray
{
    if (!_dataArray) {
        _dataArray = [FWDataBaseInstance requestAllClasses];
    }
    return _dataArray;
}

@end
