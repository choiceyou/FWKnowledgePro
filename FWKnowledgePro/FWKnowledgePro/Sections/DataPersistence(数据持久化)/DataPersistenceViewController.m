//
//  DataPersistenceViewController.m
//  MSPro
//
//  Created by xfg on 2019/11/19.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "DataPersistenceViewController.h"
#import "UserTestModel.h"
#import "KeyChainTestViewController.h"
#import "SQLiteTestViewController.h"
#import "FMDBTestViewController.h"
#import "CMHomeViewController.h"
#import "CDHomeViewController.h"
#import "NSCacheTestViewController.h"

@interface DataPersistenceViewController ()

@end


@implementation DataPersistenceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"数据持久化";
    
    NSMutableArray *tmpArray = @[
        @"获取沙盒常用路径",
        @"归档（序列化）",
        @"解归档（反序列化）",
        @"NSUserDefaults",
        @"文件存储",
        @"Keychain",
        @"Sqlite3（数据库）",
        @"FMDB（数据库）",
        @"FMDB实践（学生管理）",
        @"Core Data",
        @"YYCache",
        @"NSCache（官方缓存类）",
    ].mutableCopy;
    
    [self.titleArray addObjectsFromArray:tmpArray];
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *tmpVC = nil;
    switch (indexPath.row) {
        case 0: {
            // 获取沙盒主目录路径
            NSString *homeDirectory = NSHomeDirectory();
            NSLog(@"homeDirectory：%@", homeDirectory);
            // 获取Documents目录路径
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            NSLog(@"documentPath：%@", documentPath);
            // 获取Cache目录路径
            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSLog(@"cachePath：%@", cachePath);
            // 获取Tmp目录路径
            NSString *tmpPath = NSTemporaryDirectory();
            NSLog(@"tmpPath：%@", tmpPath);
            
            // 创建沙盒文件
            NSString *imagePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/fw_data/image/"];
            NSFileManager *fileManeger = [NSFileManager defaultManager];
            if (![fileManeger fileExistsAtPath:imagePath]) {
                [fileManeger createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
            break;
        case 1: {
            // UserTestModel实现了NSCoding协议
            UserTestModel *tmpUser = [[UserTestModel alloc] init];
            tmpUser.name = @"张三";
            tmpUser.age = 26;
            tmpUser.sex = 1;
            
            // 归档（序列化）
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filePath = [documentPath stringByAppendingString:@"/user.plist"];
            
            NSData *data;
            if (@available(iOS 11.0, *)) {
                data = [NSKeyedArchiver archivedDataWithRootObject:tmpUser requiringSecureCoding:YES error:nil];
            } else {
                data = [NSKeyedArchiver archivedDataWithRootObject:tmpUser];
            }
            [data writeToFile:filePath atomically:NO];
        }
            break;
        case 2: {
            // 解归档（反序列化）
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filePath = [documentPath stringByAppendingString:@"/user.plist"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                NSData *data = [NSData dataWithContentsOfFile:filePath];
                NSError *error;
                if (@available(iOS 11.0, *)) {
                    UserTestModel *testModel = [NSKeyedUnarchiver unarchivedObjectOfClass:[UserTestModel class] fromData:data error:&error];
                    NSLog(@"====:%@", testModel);
                } else {
                    // Fallback on earlier versions
                }
            }
        }
            break;
        case 3: {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            // 保存
            [userDefaults setObject:@"李四" forKey:@"name"];
            [userDefaults setInteger:12 forKey:@"age"];
            [userDefaults setInteger:0 forKey:@"sex"];
            UIImage *image = [UIImage imageNamed:@"test"];
            NSData *imageData = UIImageJPEGRepresentation(image, 100);
            [userDefaults setObject:imageData forKey:@"imageData"];
            // 同步
            [userDefaults synchronize];
            
            // 读取
            NSString *name = [userDefaults objectForKey:@"name"];
            NSLog(@"====name:%@", name);
            NSUInteger age = [userDefaults integerForKey:@"age"];
            NSLog(@"====age:%lu", (unsigned long)age);
            NSUInteger sex = [userDefaults integerForKey:@"sex"];
            NSLog(@"====sex:%lu", (unsigned long)sex);
            NSData *data = [userDefaults dataForKey:@"imageData"];
            UIImage *image2 = [UIImage imageWithData:data];
            NSLog(@"====image2:%@", image2);
        }
            break;
        case 4: {
            // 存
            NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            NSString *languagePath = [document stringByAppendingString:@"/language.plist"];
            NSMutableArray *array = @[@"Objective-C", @"Swift", @"Java", @"Python"].mutableCopy;
            [array writeToFile:languagePath atomically:YES];
            
            // 取
            NSMutableArray *array2 = [NSMutableArray arrayWithContentsOfFile:languagePath];
            NSLog(@"=====array2:%@", array2);
        }
            break;
        case 5: {
            tmpVC = [[KeyChainTestViewController alloc] init];
        }
            break;
        case 6: {
            tmpVC = [[SQLiteTestViewController alloc] init];
        }
            break;
        case 7: {
            tmpVC = [[FMDBTestViewController alloc] init];
        }
            break;
        case 8: {
            tmpVC = [[CMHomeViewController alloc] init];
        }
            break;
        case 9: {
            tmpVC = [[CDHomeViewController alloc] init];
        }
            break;
        case 10: {
            
        }
            break;
        case 11: {
            tmpVC = [[NSCacheTestViewController alloc] init];
        }
            break;
            
        default:
            break;
    }
    if (tmpVC) {
        [self.navigationController pushViewController:tmpVC animated:YES];
    }
}

@end
