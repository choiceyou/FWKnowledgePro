//
//  CMClassStudentViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/11/24.
//

#import "CMClassStudentViewController.h"
#import "FWDataBaseManager.h"
#import "ClassTestModel.h"
#import "StudentTestModel.h"

// 重用标识符
static NSString *const kCellIdentifier = @"kCellIdentifier";


@interface CMClassStudentViewController ()

/// 数据源
@property (nonatomic, strong) NSMutableArray<StudentTestModel *> *dataArray;

@end


@implementation CMClassStudentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"学生列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addData)];
    
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
    
    StudentTestModel *stModel = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld、%@ - %@", indexPath.row, stModel.name, stModel.hobby];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        StudentTestModel *stModel = [self.dataArray objectAtIndex:indexPath.row];
        [FWDataBaseInstance deleteStudent:stModel cls:self.ctModel];
        [self.dataArray removeObject:stModel];
        [self.tableView reloadData];
        completionHandler (YES);
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}


#pragma mark -
#pragma mark - Action

#pragma mark 添加数据到数据库
- (void)addData
{
    StudentTestModel *stModel = [[StudentTestModel alloc] init];
    stModel.classId = self.ctModel.class_id;
    stModel.age = arc4random_uniform(100) + 1;
    
    [FWDataBaseInstance addStudent:stModel cls:self.ctModel];
    self.dataArray = [FWDataBaseInstance requestAllStudentFromClass:self.ctModel];
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark - GET/SET

- (NSMutableArray<StudentTestModel *> *)dataArray
{
    if (!_dataArray) {
        _dataArray = [FWDataBaseInstance requestAllStudentFromClass:self.ctModel];
    }
    return _dataArray;
}

@end
