//
//  FWDataBaseManager.m
//  FanweApp
//
//  Created by xfg on 2020/11/23.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "FWDataBaseManager.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "ClassTestModel.h"
#import "StudentTestModel.h"

// 默认数据库存放路径
#define kFWDBPath [[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/fw_db_file"]

// 数据库名称
static NSString *const kDBName = @"StudentDB";
// 班级表
static NSString *const kCLASSTABLEName = @"CLASSTABLE";
// 学生表
static NSString *const kSTUDENTTABLEName = @"STUDENTTABLE";


@interface FWDataBaseManager ()

@property(nonatomic, strong) FMDatabaseQueue *dbQueue;

@end


@implementation FWDataBaseManager

#pragma mark -
#pragma mark - 生命周期

static FWDataBaseManager *instance = nil;
static dispatch_once_t onceToken;
+ (FWDataBaseManager *)sharedInstance
{
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)releaseInstance
{
    onceToken = 0;
    [instance disconnectDB];
    instance = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self dbQueue];
    }
    return self;
}

#pragma mark 关闭数据库链接
- (void)disconnectDB
{
    self.dbQueue = nil;
}


#pragma mark -
#pragma mark - 创建表

#pragma mark 创建表
- (void)createTableIfNeed
{
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![self isTableOK:kCLASSTABLEName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE CLASSTABLE (id integer PRIMARY KEY autoincrement,"
            @"class_id text, name text, desc text)";
            [db executeUpdate:createTableSQL];
            
            NSString *createIndexSQL = @"CREATE unique INDEX idx_class_id ON STUDENTTABLE(class_id);";
            [db executeUpdate:createIndexSQL];
        }
        
        if (![self isTableOK:kSTUDENTTABLEName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE STUDENTTABLE (id integer PRIMARY KEY autoincrement,"
            @"user_id VARCHAR(255), class_id VARCHAR(255), name VARCHAR(255), age integer default '1', hobby VARCHAR(255))";
            [db executeUpdate:createTableSQL];
            
            NSString *createIndexSQL = @"CREATE unique INDEX idx_user_id ON STUDENTTABLE(user_id);";
            [db executeUpdate:createIndexSQL];
        } else if (![self isColumnExist:@"display_name" inTable:kSTUDENTTABLEName withDB:db]) {
            [db executeUpdate:@"ALTER TABLE STUDENTTABLE ADD COLUMN display_name VARCHAR(255)"];
        }
    }];
}

#pragma mark 判断某张表是否已经创建
- (BOOL)isTableOK:(NSString *)tableName withDB:(FMDatabase *)db
{
    BOOL isOK = NO;
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where "
                       @"type ='table' and name = ?",
                       tableName];
    while ([rs next]) {
        NSInteger count = [rs intForColumn:@"count"];
        if (0 == count) {
            isOK = NO;
        } else {
            isOK = YES;
        }
    }
    [rs close];
    return isOK;
}

#pragma mark 判断某张表中的某个字段是否存在
- (BOOL)isColumnExist:(NSString *)columnName inTable:(NSString *)tableName withDB:(FMDatabase *)db
{
    BOOL isExist = NO;
    NSString *columnQurerySql = [NSString stringWithFormat:@"SELECT %@ from %@", columnName, tableName];
    FMResultSet *rs = [db executeQuery:columnQurerySql];
    if ([rs next]) {
        isExist = YES;
    } else {
        isExist = NO;
    }
    [rs close];
    return isExist;
}


#pragma mark -
#pragma mark - 班级操作

#pragma mark 添加班级
- (void)addCls:(ClassTestModel *)cls
{
    NSString *sqlStr = @"SELECT * FROM CLASSTABLE";
    NSString *sqlStr2 = @"REPLACE INTO CLASSTABLE (class_id, name, desc) values (?, ?, ?)";
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSInteger classId = 10000;
        FMResultSet *rs = [db executeQuery:sqlStr];
        while ([rs next]) {
            NSInteger tmpId = [rs intForColumn:@"class_id"];
            classId = MAX(classId, tmpId);
        }
        classId ++;
        
        BOOL result = [db executeUpdate:sqlStr2, [NSString stringWithFormat:@"%ld", (long)classId], cls.name, cls.desc];
        if (result) {
            NSLog(@"添加班级成功");
        } else {
            NSLog(@"添加班级失败");
        }
    }];
}

#pragma mark 删除班级
- (void)deleteCls:(ClassTestModel *)cls
{
    NSString *sqlStr = @"DELETE FROM CLASSTABLE where class_id = ?";
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:sqlStr, cls.class_id];
        if (result) {
            NSLog(@"删除班级成功");
        } else {
            NSLog(@"删除班级失败");
        }
    }];
}

#pragma mark 更新班级
- (void)updateCls:(ClassTestModel *)cls
{
    NSString *sqlStr = @"UPDATE CLASSTABLE set name = ?, desc = ? where class_id = ?";
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:sqlStr, cls.name, cls.desc, cls.class_id];
        if (result) {
            NSLog(@"更新班级数据成功");
        } else {
            NSLog(@"更新班级数据失败");
        }
    }];
}

#pragma mark 获取所有班级
- (NSMutableArray<ClassTestModel *> *)requestAllClasses
{
    NSMutableArray<ClassTestModel *> *tmpArray = @[].mutableCopy;
    NSString *sqlStr = @"SELECT * FROM CLASSTABLE";
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sqlStr];
        while ([rs next]) {
            ClassTestModel *ctModel = [[ClassTestModel alloc] init];
            ctModel.class_id = [rs stringForColumn:@"class_id"];
            ctModel.name = [rs stringForColumn:@"name"];
            ctModel.desc = [rs stringForColumn:@"desc"];
            [tmpArray addObject:ctModel];
        }
    }];
    return tmpArray;
}

#pragma mark 获取所有班级+学生
- (NSMutableArray<ClassTestModel *> *)requestAllData
{
    NSMutableArray<ClassTestModel *> *tmpArray = @[].mutableCopy;
    NSString *sqlStr = @"SELECT * FROM CLASSTABLE";
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sqlStr];
        while ([rs next]) {
            ClassTestModel *ctModel = [[ClassTestModel alloc] init];
            ctModel.class_id = [rs stringForColumn:@"class_id"];
            ctModel.name = [rs stringForColumn:@"name"];
            ctModel.desc = [rs stringForColumn:@"desc"];
            [tmpArray addObject:ctModel];
        }
    }];
    for (ClassTestModel *ctModel in tmpArray) {
        ctModel.studentArray = [self requestAllStudentFromClass:ctModel];
    }
    
    return tmpArray;
}


#pragma mark -
#pragma mark - 学生操作

#pragma mark 添加某个学生到对应的班级
- (void)addStudent:(StudentTestModel *)student cls:(ClassTestModel *)cls
{
    NSString *sqlStr = @"SELECT * FROM STUDENTTABLE";
    NSString *sqlStr2 = @"REPLACE INTO STUDENTTABLE (user_id, class_id, name, age, hobby) values (?, ?, ?, ?, ?)";
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSInteger userId = 1000;
        FMResultSet *rs = [db executeQuery:sqlStr];
        while ([rs next]) {
            NSInteger tmpId = [rs intForColumn:@"user_id"];
            userId = MAX(userId, tmpId);
        }
        userId ++;
        
        student.name = [NSString stringWithFormat:@"学生_%ld号", (long)userId];
        student.hobby = [NSString stringWithFormat:@"爱好_%ld号活动", (long)arc4random_uniform(100)+1];
        
        BOOL result = [db executeUpdate:sqlStr2, [NSString stringWithFormat:@"%ld", (long)userId], cls.class_id, student.name, [NSString stringWithFormat:@"%ld", (long)student.age], student.hobby];
        if (result) {
            NSLog(@"添加学生成功");
        } else {
            NSLog(@"添加学生失败");
        }
    }];
}

#pragma mark 删除某个班级的某个学生
- (void)deleteStudent:(StudentTestModel *)student cls:(ClassTestModel *)cls
{
    NSString *sqlStr = @"DELETE FROM STUDENTTABLE where user_id = ? and class_id = ?";
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:sqlStr, student.ID, cls.class_id];
        if (result) {
            NSLog(@"删除学生成功");
        } else {
            NSLog(@"删除学生失败");
        }
    }];
}

#pragma mark 获取某个班级的所有学生
- (NSMutableArray<StudentTestModel *> *)requestAllStudentFromClass:(ClassTestModel *)cls
{
    NSMutableArray<StudentTestModel *> *tmpArray = @[].mutableCopy;
    NSString *sqlStr = @"SELECT * FROM STUDENTTABLE where class_id = ?";
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sqlStr, cls.class_id];
        while ([rs next]) {
            StudentTestModel *stModel = [[StudentTestModel alloc] init];
            stModel.ID = [rs stringForColumn:@"user_id"];
            stModel.classId = [rs stringForColumn:@"class_id"];
            stModel.name = [rs stringForColumn:@"name"];
            stModel.age= [rs intForColumn:@"age"];
            stModel.hobby = [rs stringForColumn:@"hobby"];
            [tmpArray addObject:stModel];
        }
    }];
    return tmpArray;
}

#pragma mark 删除某个班级的所有学生
- (void)deleteAllStudentFromClass:(ClassTestModel *)cls
{
    NSString *sqlStr = @"DELETE FROM STUDENTTABLE where class_id = ?";
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeUpdate:sqlStr, cls.class_id];
        if (result) {
            NSLog(@"删除%@的所有学生成功", cls.name);
        } else {
            NSLog(@"删除%@的所有学生失败", cls.name);
        }
    }];
}


#pragma mark -
#pragma mark - GET/SET

- (FMDatabaseQueue *)dbQueue
{
    if (!_dbQueue) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:kFWDBPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:kFWDBPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *tmpStr = [NSString stringWithFormat:@"/%@.db", kDBName];
        NSString *dbPath = [kFWDBPath stringByAppendingString:tmpStr];
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        if (_dbQueue) {
            [self createTableIfNeed];
        }
    }
    return _dbQueue;
}

@end
