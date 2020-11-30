//
//  FWDataBaseManager.h
//  FanweApp
//
//  Created by xfg on 2020/11/23.
//  Copyright © 2020 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FWDataBaseManager;
@class ClassTestModel;
@class StudentTestModel;

NS_ASSUME_NONNULL_BEGIN

#define FWDataBaseInstance [FWDataBaseManager sharedInstance]

@interface FWDataBaseManager : NSObject

#pragma mark -
#pragma mark - 生命周期

/// 单例模式
+ (FWDataBaseManager *)sharedInstance;

/// 释放当前单例
+ (void)releaseInstance;

/// 关闭数据库链接
- (void)disconnectDB;


#pragma mark -
#pragma mark - 班级操作

/// 添加班级
/// @param cls 班级
- (void)addCls:(ClassTestModel *)cls;

/// 删除班级
/// @param cls 班级
- (void)deleteCls:(ClassTestModel *)cls;

/// 更新班级
/// @param cls 班级
- (void)updateCls:(ClassTestModel *)cls;

/// 获取所有班级
- (NSMutableArray<ClassTestModel *> *)requestAllClasses;

/// 获取所有班级+学生
- (NSMutableArray<ClassTestModel *> *)requestAllData;


#pragma mark -
#pragma mark - 学生操作

/// 添加某个学生到对应的班级
/// @param student 学生
/// @param cls 班级
- (void)addStudent:(StudentTestModel *)student cls:(ClassTestModel *)cls;

/// 删除某个班级的某个学生
/// @param student 学生
/// @param cls 班级
- (void)deleteStudent:(StudentTestModel *)student cls:(ClassTestModel *)cls;

/// 获取某个班级的所有学生
/// @param cls 班级
- (NSMutableArray<StudentTestModel *> *)requestAllStudentFromClass:(ClassTestModel *)cls;

/// 删除某个班级的所有学生
/// @param cls 班级
- (void)deleteAllStudentFromClass:(ClassTestModel *)cls;

@end

NS_ASSUME_NONNULL_END
