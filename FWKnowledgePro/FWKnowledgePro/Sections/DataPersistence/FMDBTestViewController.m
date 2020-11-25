//
//  FMDBTestViewController.m
//  MSPro
//
//  Created by xfg on 2020/11/20.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "FMDBTestViewController.h"
#import "StudentTestModel.h"
#import <FMDB.h>

@interface FMDBTestViewController ()

@property (nonatomic, strong) FMDatabase *fmdb;

@end


@implementation FMDBTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"FMDB";
    
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
            [self insertClasss:@"一年一班"];
            [self insertClasss:@"一年二班"];
            [self insertClasss:@"一年三班"];
            
            StudentTestModel *stu = [[StudentTestModel alloc] init];
            stu.classId = @"2";
            stu.name = @"王五";
            stu.age = 10;
            stu.hobby = @"打篮球";
            [self insetStudent:stu];
            
            StudentTestModel *stu2 = [[StudentTestModel alloc] init];
            stu.classId = @"3";
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
    if (!self.fmdb) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *studentDBPath = [documentPath stringByAppendingString:@"/Student2.db"];
        NSLog(@"%@", studentDBPath);
        self.fmdb = [FMDatabase databaseWithPath:studentDBPath];
    }
    if ([self.fmdb open]) {
        NSLog(@"打开数据库成功");
    } else {
        NSLog(@"打开数据库失败");
    }
}

#pragma mark 关闭数据库
- (void)closeDB
{
    [self.fmdb close];
}

#pragma mark 创建表
- (void)createTable
{
    [self openDB];
    
    // 创建学生表
    NSString *sqlStr = @"create table if not exists stu (id integer primary key autoincrement, cId integer, name text, age integer, hobby text)";
    BOOL result = [self.fmdb executeUpdate:sqlStr];
    if (result) {
        NSLog(@"创建学生表成功");
    } else {
        NSLog(@"创建学生表失败");
    }
    
    // 创建班级表
    NSString *sqlStr2 = @"create table if not exists cls (id integer primary key autoincrement, name text)";
    BOOL result2 = [self.fmdb executeUpdate:sqlStr2];
    if (result2) {
        NSLog(@"创建班级表成功");
    } else {
        NSLog(@"创建班级表失败");
    }
    
    [self closeDB];
}

#pragma mark 插入班级数据
- (void)insertClasss:(NSString *)className
{
    [self openDB];
    
    NSString *sqlStr = @"insert into cls (name) values (?)";
    BOOL result = [self.fmdb executeUpdate:sqlStr, className];
    if (result) {
        NSLog(@"插入班级数据成功");
    } else {
        NSLog(@"插入班级数据失败");
    }
    
    [self closeDB];
}

#pragma mark 插入学生数据
- (void)insetStudent:(StudentTestModel *)stu
{
    [self openDB];
    
    NSString *sqlStr = [NSString stringWithFormat:@"insert into stu (cId, name, age, hobby) values ('%lu', '%@', '%lu', '%@')", stu.classId, stu.name, stu.age, stu.hobby];
    BOOL result = [self.fmdb executeUpdate:sqlStr];
    if (result) {
        NSLog(@"插入学生数据成功");
    } else {
        NSLog(@"插入学生数据失败");
    }
    
    [self closeDB];
}

#pragma mark 查询所有学生信息
- (NSMutableArray<StudentTestModel *> *)selectAllStudent
{
    [self openDB];
    
    NSMutableArray<StudentTestModel *> *stuList = @[].mutableCopy;
    NSString *sqlStr = @"select * from stu";
    FMResultSet *resultSet = [self.fmdb executeQuery:sqlStr];
    while ([resultSet next]) {
        StudentTestModel *tmpStu = [[StudentTestModel alloc] init];
        tmpStu.name = [resultSet stringForColumn:@"name"];
        tmpStu.age = [resultSet intForColumn:@"age"];
        tmpStu.hobby = [resultSet stringForColumn:@"hobby"];
        [stuList addObject:tmpStu];
    }
    
    [self closeDB];
    
    return stuList;
}

#pragma mark 更新学生数据
- (void)updateStudent:(StudentTestModel *)stu
{
    [self openDB];
    
    NSString *sqlStr = [NSString stringWithFormat:@"update stu set age = '%lu', hobby = '%@' where name = '%@'", stu.age, stu.hobby, stu.name];
    BOOL result = [self.fmdb executeUpdate:sqlStr];
    if (result) {
        NSLog(@"更新学生数据成功");
    } else {
        NSLog(@"更新学生数据失败");
    }
    
    [self closeDB];
}

#pragma mark 删除某个同学
- (void)deleteStudent:(StudentTestModel *)stu
{
    [self openDB];
    
    NSString *sqlStr = [NSString stringWithFormat:@"delete from stu where name = '%@'", stu.name];
    BOOL result = [self.fmdb executeUpdate:sqlStr];
    if (result) {
        NSLog(@"删除学生数据成功");
    } else {
        NSLog(@"删除学生数据失败");
    }
    
    [self closeDB];
}

@end
