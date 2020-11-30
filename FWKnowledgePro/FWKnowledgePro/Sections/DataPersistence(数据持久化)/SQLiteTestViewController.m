//
//  SQLiteTestViewController.m
//  MSPro
//
//  Created by xfg on 2020/11/20.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "SQLiteTestViewController.h"
#import <sqlite3.h>
#import "StudentTestModel.h"

@interface SQLiteTestViewController () {
    sqlite3 *dbPoint;
}

@end


@implementation SQLiteTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Sqlite3";
    
    NSMutableArray *tmpArray = @[
        @"打开数据库",
        @"创建表",
        @"增",
        @"查",
        @"改",
        @"删"
    ].mutableCopy;
    
    [self.titleArray addObjectsFromArray:tmpArray];
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            [self openDB];
        }
            break;
        case 1: {
            [self createTable];
        }
            break;
        case 2: {
            StudentTestModel *stu = [[StudentTestModel alloc] init];
            stu.name = @"王五";
            stu.age = 10;
            stu.hobby = @"打篮球";
            [self insetStudent:stu];
            
            StudentTestModel *stu2 = [[StudentTestModel alloc] init];
            stu2.name = @"赵六";
            stu2.age = 12;
            stu2.hobby = @"打排球";
            [self insetStudent:stu2];
        }
            break;
        case 3: {
            NSMutableArray *tmpArray = [self selectAllStudent];
            NSLog(@"=======查询所有学生数据结果:%@", tmpArray);
        }
            break;
        case 4: {
            StudentTestModel *stu = [[StudentTestModel alloc] init];
            stu.name = @"王五";
            stu.age = 11;
            stu.hobby = @"打羽毛球";
            [self updateStudent:stu];
        }
            break;
        case 5: {
            StudentTestModel *stu = [[StudentTestModel alloc] init];
            stu.name = @"王五";
            [self deleteStudent:stu];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark - Piravate

#pragma mark 打开数据库
- (void)openDB
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *studentDBPath = [documentPath stringByAppendingString:@"/Student.sqlite"];
    
    int result = sqlite3_open([studentDBPath UTF8String], &dbPoint);
    if (result == SQLITE_OK) {
        NSLog(@"打开数据库成功");
        NSLog(@"%@", studentDBPath);
    } else {
        NSLog(@"打开数据库失败");
    }
}

#pragma mark 创建表
- (void)createTable
{
    // primary key：主键，可以唯一的标识一条数据，一般是证书
    // autoincrement：自增
    // if not exits：如果没有表才会创建，防止重复创建表覆盖之前的数据
    NSString *sqlStr = @"create table if not exists stu (number integer primary key autoincrement, name text, age integer, hobby text)";
    int result = sqlite3_exec(dbPoint, [sqlStr UTF8String], nil, nil, nil);
    if (result == SQLITE_OK) {
        NSLog(@"创建学生表成功");
    } else {
        NSLog(@"创建学生表失败");
    }
}

#pragma mark 插入学生数据
- (void)insetStudent:(StudentTestModel *)stu
{
    NSString *sqlStr = [NSString stringWithFormat:@"insert into stu (name, age, hobby) values ('%@', '%lu', '%@')", stu.name, stu.age, stu.hobby];
    int result = sqlite3_exec(dbPoint, [sqlStr UTF8String], nil, nil, nil);
    if (result == SQLITE_OK) {
        NSLog(@"插入学生数据成功");
    } else {
        NSLog(@"插入学生数据失败");
    }
}

#pragma mark 查询所有学生信息
- (NSMutableArray<StudentTestModel *> *)selectAllStudent
{
    NSMutableArray<StudentTestModel *> *stuList = @[].mutableCopy;
    
    NSString *sqlStr = @"select * from stu";
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare(dbPoint, [sqlStr UTF8String], -1, &stmt, nil);
    if (result == SQLITE_OK) {
        // 开始遍历查询数据库的每一行数据
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            // 让跟随指针进行遍历查询，如果没有行，则停止循环
            // 满足条件，则逐列的读取内容
            // 第二个参数表示当前这列数据在表的第几列
            const unsigned char *name = sqlite3_column_text(stmt, 1);
            int age = sqlite3_column_int(stmt, 2);
            const unsigned char *hobby = sqlite3_column_text(stmt, 3);
            NSString *stuName = [NSString stringWithUTF8String:(const char *)name];
            NSInteger stuAge = age;
            NSString *stuHobby = [NSString stringWithUTF8String:(const char *)hobby];
            
            StudentTestModel *tmpStu = [[StudentTestModel alloc] init];
            tmpStu.name = stuName;
            tmpStu.age = stuAge;
            tmpStu.hobby = stuHobby;
            
            [stuList addObject:tmpStu];
        }
        NSLog(@"查询所有学生数据成功");
    } else {
        NSLog(@"查询所有学生数据失败");
    }
    
    return stuList;
}

#pragma mark 更新学生数据
- (void)updateStudent:(StudentTestModel *)stu
{
    NSString *sqlStr = [NSString stringWithFormat:@"update stu set age = '%lu', hobby = '%@' where name = '%@'", stu.age, stu.hobby, stu.name];
    int result = sqlite3_exec(dbPoint, [sqlStr UTF8String], nil, nil, nil);
    if (result == SQLITE_OK) {
        NSLog(@"更新学生数据成功");
    } else {
        NSLog(@"更新学生数据失败");
    }
}

#pragma mark 删除某个同学
- (void)deleteStudent:(StudentTestModel *)stu
{
    NSString *sqlStr = [NSString stringWithFormat:@"delete from stu where name = '%@'", stu.name];
    int result = sqlite3_exec(dbPoint, [sqlStr UTF8String], nil, nil, nil);
    if (result == SQLITE_OK) {
        NSLog(@"删除学生数据成功");
    } else {
        NSLog(@"删除学生数据失败");
    }
}

@end
