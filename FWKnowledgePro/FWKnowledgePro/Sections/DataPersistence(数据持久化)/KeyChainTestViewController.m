//
//  KeyChainTestViewController.m
//  MSPro
//
//  Created by xfg on 2020/11/20.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "KeyChainTestViewController.h"

@interface KeyChainTestViewController ()

@end


@implementation KeyChainTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Keychain";
    
    NSMutableArray *tmpArray = @[
        @"增",
        @"查",
        @"改",
        @"删",
    ].mutableCopy;
    
    [self.titleArray addObjectsFromArray:tmpArray];
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            BOOL succeed = [self keychainSaveData:@"123456789" withAccountIdentifier:@"trigger" andServiceIdentifier:@"password"];
            BOOL succeed1 = [self keychainSaveData:@"987654321" withAccountIdentifier:@"trigger" andServiceIdentifier:@"account"];
            NSLog(@"%d",succeed);
            NSLog(@"%d",succeed1);
        }
            break;
        case 1: {
            NSLog(@"%@",(NSString *)[self keychainGetDataWithAccountIdentifier:@"trigger" andServiceIdentifier:@"account"]);
            NSLog(@"%@",(NSString *)[self keychainGetDataWithAccountIdentifier:@"trigger" andServiceIdentifier:@"password"]);
        }
            break;
        case 2: {
            [self keychainUpdataData:@"000000000" withAccountIdentifier:@"trigger" andServiceIdentifier:@"password"];
            NSLog(@"%@",(NSString *)[self keychainGetDataWithAccountIdentifier:@"trigger" andServiceIdentifier:@"password"]);
        }
            break;
        case 3: {
            [self keychainDeleteWithAccountIdentifier:@"trigger" andServiceIdentifier:@"account"];
            NSLog(@"%@",(NSString *)[self keychainGetDataWithAccountIdentifier:@"trigger" andServiceIdentifier:@"account"]);
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark - Private

- (NSMutableDictionary *)keychainDicWithAccountId:(NSString *)accountId andServiceId:(NSString *)serviceId
{
    // 构建一个存取条件,实质是一个字典
    NSString *classKey = (__bridge NSString *)kSecClass;
    // 指定服务类型是普通密码
    NSString *classValue = (__bridge NSString *)kSecClassGenericPassword;
    NSString *accessibleKey = (__bridge NSString *)kSecAttrAccessible;
    // 指定安全类型是任何时候都可以访问
    NSString *accessibleValue = (__bridge NSString *)kSecAttrAccessibleAlways;
    NSString *accountKey = (__bridge NSString *)kSecAttrAccount;
    // 指定服务的账户名 可以与服务名相同 账户名可以对应多个服务名
    NSString *accountValue = accountId;
    NSString *serviceKey = (__bridge NSString *)kSecAttrService;
    // 指定服务的名字 可以与服务账户名相同
    NSString *serviceValue = serviceId;
    NSDictionary *keychainItems = @{classKey      : classValue,
                                    accessibleKey : accessibleValue,
                                    accountKey    : accountValue,
                                    serviceKey    : serviceValue};
    return keychainItems.mutableCopy;
}

#pragma mark 增
- (BOOL)keychainSaveData:(id)aData withAccountIdentifier:(NSString *)accountId andServiceIdentifier:(NSString *)serviceId
{
    // 获取存储的数据的条件
    NSMutableDictionary *saveQueryDic = [self keychainDicWithAccountId:accountId andServiceId:serviceId];
    // 删除旧的数据
    SecItemDelete((CFDictionaryRef)saveQueryDic);
    // 设置新的数据
    NSError *error;
    [saveQueryDic setObject:[NSKeyedArchiver archivedDataWithRootObject:aData requiringSecureCoding:NO error:&error] forKey:(id)kSecValueData];
    // 添加数据
    OSStatus saveState = SecItemAdd((CFDictionaryRef)saveQueryDic, nil);
    // 释放对象
    saveQueryDic = nil ;
    // 判断是否存储成功
    if (saveState == errSecSuccess) {
        return YES;
    }
    return NO;
}

#pragma mark 查
- (id)keychainGetDataWithAccountIdentifier:(NSString *)accountId andServiceIdentifier:(NSString *)serviceId
{
    id idObject = nil ;
    // 通过标记获取数据查询条件
    NSMutableDictionary * readQueryDic = [self keychainDicWithAccountId:accountId andServiceId:serviceId];
    // 查询结果返回到 kSecValueData (此项必选)
    [readQueryDic setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    // 只返回搜索到的第一条数据 (此项必选)
    [readQueryDic setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    // 创建一个对象接受结果
    CFDataRef keyChainData = nil ;
    // 通过条件查询数据
    if (SecItemCopyMatching((CFDictionaryRef)readQueryDic , (CFTypeRef *)&keyChainData) == noErr){
        @try {
            //转换类型
            idObject = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)(keyChainData)];
        } @catch (NSException * exception){
            NSLog(@"Unarchive of search data where %@ failed of %@ ",serviceId,exception);
        }
    }
    if (keyChainData) {
        CFRelease(keyChainData);
    }
    readQueryDic = nil;
    // 返回数据
    return idObject ;
}

#pragma mark 改
- (BOOL)keychainUpdataData:(id)data withAccountIdentifier:(NSString *)accountId andServiceIdentifier:(NSString *)serviceId
{
    // 通过标记获取数据更新的条件
    NSMutableDictionary * updataQueryDic = [self keychainDicWithAccountId:accountId andServiceId:serviceId];
    // 创建更新数据字典
    NSMutableDictionary * newDic = @{}.mutableCopy;
    // 存储数据
    [newDic setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    // 获取存储的状态
    OSStatus  updataStatus = SecItemUpdate((CFDictionaryRef)updataQueryDic, (CFDictionaryRef)newDic);
    updataQueryDic = nil;
    newDic = nil;
    // 判断是否更新成功
    if (updataStatus == errSecSuccess) {
        return  YES ;
    }
    return NO;
}

#pragma mark 删
- (void)keychainDeleteWithAccountIdentifier:(NSString *)accountId andServiceIdentifier:(NSString *)serviceId
{
    // 获取删除数据的查询条件
    NSMutableDictionary * deleteQueryDic = [self keychainDicWithAccountId:accountId andServiceId:serviceId];
    // 删除指定条件的数据
    SecItemDelete((CFDictionaryRef)deleteQueryDic);
    deleteQueryDic = nil ;
}

@end
