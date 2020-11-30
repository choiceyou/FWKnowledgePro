//
//  CDHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/11/25.
//

#import "CDHomeViewController.h"
#import <CoreData/CoreData.h>
#import "Student2+CoreDataClass.h"

// 默认数据库存放路径
#define kFWDBPath2 [[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/fw_db_file"]
// 重用标识符
static NSString *const kCellIdentifier = @"kCellIdentifier";


/*
 谓词的条件指令
 1.比较运算符 > 、< 、== 、>= 、<= 、!=
 例：@"number >= 99"
 
 2.范围运算符：IN 、BETWEEN
 例：@"number BETWEEN {1,5}"
 @"address IN {'shanghai','nanjing'}"
 
 3.字符串本身:SELF
 例：@"SELF == 'APPLE'"
 
 4.字符串相关：BEGINSWITH、ENDSWITH、CONTAINS
 例：  @"name CONTAIN[cd] 'ang'"  // 包含某个字符串
 @"name BEGINSWITH[c] 'sh'"     // 以某个字符串开头
 @"name ENDSWITH[d] 'ang'"      // 以某个字符串结束
 
 5.通配符：LIKE
 例：@"name LIKE[cd] '*er*'"   // *代表通配符,Like也接受[cd].
 @"name LIKE[cd] '???er*'"
 
 *注*: 星号 "*" : 代表0个或多个字符
 问号 "?" : 代表一个字符
 
 6.正则表达式：MATCHES
 例：NSString *regex = @"^A.+e$"; //以A开头，e结尾
 @"name MATCHES %@",regex
 
 注:[c]*不区分大小写 , [d]不区分发音符号即没有重音符号, [cd]既不区分大小写，也不区分发音符号。
 
 7. 合计操作
 ANY，SOME：指定下列表达式中的任意元素。比如，ANY children.age < 18。
 ALL：指定下列表达式中的所有元素。比如，ALL children.age < 18。
 NONE：指定下列表达式中没有的元素。比如，NONE children.age < 18。它在逻辑上等于NOT (ANY ...)。
 IN：等于SQL的IN操作，左边的表达必须出现在右边指定的集合中。比如，name IN { 'Ben', 'Melissa', 'Nick' }。
 
 提示:
 1. 谓词中的匹配指令关键字通常使用大写字母
 2. 谓词中可以使用格式字符串
 3. 如果通过对象的key
 path指定匹配条件，需要使用%K
 
 */


@interface CDHomeViewController ()

/// 上下文
@property (nonatomic, strong) NSManagedObjectContext *managedContext;
/// 数据源
@property (nonatomic, strong) NSMutableArray<Student2 *> *dataArray;

@end


@implementation CDHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"CoreData 测试";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertData)];
    
    self.tableView.estimatedRowHeight = 44.f;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    
    // 查询所有数据的请求
    [self requestAllData];
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
    
    Student2 *stModel = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld、%@ - %@ - %ld - %@", indexPath.row, stModel.name, stModel.sex, (long)stModel.age, stModel.hobby];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        Student2 *stModel = [self.dataArray objectAtIndex:indexPath.row];
        [self deleteData:stModel];
        [self.dataArray removeObject:stModel];
        [self.tableView reloadData];
        completionHandler (YES);
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];

    UIContextualAction *updateRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"update" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        Student2 *stModel = [self.dataArray objectAtIndex:indexPath.row];
        stModel.age = arc4random()%20;
        stModel.sex = arc4random()%2 == 0 ?  @"女" : @"男" ;
        stModel.hobby = [NSString stringWithFormat:@"爱好：%ld", (long)arc4random_uniform(1000)];
        [self updateData:stModel];
        [self.tableView reloadData];
        completionHandler (YES);
    }];
    updateRowAction.backgroundColor = [UIColor blackColor];

    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction, updateRowAction]];
    return config;
}


#pragma mark -
#pragma mark - Action

#pragma mark 查询所有学生数据
- (void)requestAllData
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student2"];
    NSArray *resArray = [self.managedContext executeFetchRequest:request error:nil];
    self.dataArray = resArray.mutableCopy;
    [self.tableView reloadData];
}

#pragma mark 添加数据到数据库
- (void)insertData
{
    // 1.根据Entity名称和NSManagedObjectContext获取一个新的继承于NSManagedObject的子类Student
    Student2 *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student2" inManagedObjectContext:self.managedContext];

    NSInteger userId = 1000;
    for (Student2 *student in self.dataArray) {
        userId = MAX(userId, student.user_id);
    }
    userId ++;
    
    // 2.根据表Student中的键值，给NSManagedObject对象赋值
    student.user_id = userId;
    student.name = [NSString stringWithFormat:@"Mr-%ld", (long)userId];
    student.age = arc4random()%20;
    student.sex = arc4random()%2 == 0 ?  @"女" : @"男" ;
    student.hobby = [NSString stringWithFormat:@"爱好：%ld", (long)arc4random_uniform(1000)];
    
    // 3.保存插入的数据
    NSError *error = nil;
    if ([self.managedContext save:&error]) {
        NSLog(@"新增学生数据成功");
        [self requestAllData];
    } else {
        NSLog(@"新增学生数据失败");
    }
}

#pragma mark 删除某个学生数据
- (void)deleteData:(Student2 *)student
{
    // 创建删除请求
    NSFetchRequest *deleRequest = [NSFetchRequest fetchRequestWithEntityName:@"Student2"];
    // 删除条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"user_id = %d", student.user_id];
    deleRequest.predicate = pre;
    
    // 返回需要删除的对象数组
    NSArray *deleArray = [self.managedContext executeFetchRequest:deleRequest error:nil];
    
    // 从数据库中删除
    for (Student2 *stu in deleArray) {
        [self.managedContext deleteObject:stu];
    }
    
    NSError *error = nil;
    // 保存
    if ([self.managedContext save:&error]) {
        NSLog(@"删除后，保存学生数据成功");
        [self requestAllData];
    } else {
        NSLog(@"删除后，保存学生数据失败");
    }
}

#pragma mark 更新某个学生数据
- (void)updateData:(Student2 *)student
{
    // 创建查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student2"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"user_id = %ld", student.user_id];
    request.predicate = pre;
    // 发送请求
    NSArray *resArray = [self.managedContext executeFetchRequest:request error:nil];
    // 修改
    Student2 *stu = [resArray firstObject];
    stu.name = student.name;
    stu.age = student.age;
    stu.sex = student.sex;
    stu.hobby = student.hobby;
    
    // 保存
    NSError *error = nil;
    if ([self.managedContext save:&error]) {
        NSLog(@"修改后，保存学生数据成功");
        [self requestAllData];
    } else {
        NSLog(@"修改后，保存学生数据失败");
    }
}


#pragma mark -
#pragma mark - GET/SET

- (NSManagedObjectContext *)managedContext
{
    if (!_managedContext) {
        // 1、创建模型对象
        // 获取模型路径
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        // 根据模型文件创建模型对象
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        // 2、创建持久化存储助理：数据库
        // 利用模型对象创建助理对象
        NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        // 数据库的名称和路径
        if (![[NSFileManager defaultManager] fileExistsAtPath:kFWDBPath2]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:kFWDBPath2 withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *sqlPath = [kFWDBPath2 stringByAppendingPathComponent:@"StudentCoreData.sqlite"];
        NSLog(@"数据库 path = %@", sqlPath);
        NSURL *sqlUrl = [NSURL fileURLWithPath:sqlPath];
        NSError *error = nil;
        // 设置数据库相关信息 添加一个持久化存储库并设置存储类型和路径，NSSQLiteStoreType：SQLite作为存储库
        [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlUrl options:nil error:&error];
        if (error) {
            NSLog(@"添加数据库失败:%@",error);
        } else {
            NSLog(@"添加数据库成功");
        }
        
        // 3、创建上下文 保存信息 操作数据库
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        // 关联持久化助理
        context.persistentStoreCoordinator = store;
        _managedContext = context;
    }
    return _managedContext;
}

- (NSMutableArray<Student2 *> *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

@end
