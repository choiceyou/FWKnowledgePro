//
//  MSAlgorithmViewController.m
//  MSPro
//
//  Created by xfg on 2020/6/15.
//  Copyright © 2020 xfg. All rights reserved.
//  参考：https://juejin.im/post/5e12dffff265da5d57542c74

/**
 加密算法：
 1、对称加密算法：“明文”通过“秘钥”加密后变成“密文”，“密文”通过“秘钥”解密变成“明文”。如：AES、DES、3DES等等；
 2、非对称加密算法：公钥加密，私钥解密；私钥加密，公钥解密。如：RSA、SHA1、SHA256\512等等；
 
 散列（哈希）算法，如：MD5
 1、不可逆；
 2、不同的数据加密后的结果都是定长的；
 3、数据指纹（只是数据的一部分）；
 
 散列碰撞：不同的数据得到了同样的哈希值；
 */

#import "MSAlgorithmViewController.h"

@implementation MSAlgorithmViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"算法";
    
    NSMutableArray *tmpArray = @[
        @"选择排序",
        @"冒泡算法",
        @"快速排序",
        @"二分法查找",
        @"字符串逆序输出",
    ].mutableCopy;
    
    [self.titleArray addObjectsFromArray:tmpArray];
}


#pragma mark -
#pragma mark - Action

#pragma mark 交换数组元素
- (void)swapArrayElement:(NSMutableArray *)array index1:(int)index1 index2:(int)index2
{
    id object = array[index1];
    array[index1] = array[index2];
    array[index2] = object;
}

#pragma mark 选择排序
- (void)selectSort:(BOOL)isAsc
{
    NSMutableArray *tmpArray = @[@5, @3, @9, @4, @6, @8, @1, @7, @2].mutableCopy;
    for (int i = 0; i < tmpArray.count; i++) {
        int tmpIndex = i;
        int tmpIndex2 = i;
        for (int j = i + 1; j < tmpArray.count; j++) {
            int tmp1 = [tmpArray[j] intValue];
            int tmp2 = [tmpArray[tmpIndex2] intValue];
            if ((isAsc && tmp1 < tmp2) || (!isAsc && tmp1 > tmp2)) {
                tmpIndex2 = j;
            }
        }
        int tmp1 = [tmpArray[tmpIndex2] intValue];
        int tmp2 = [tmpArray[tmpIndex] intValue];
        if ((isAsc && tmp1 < tmp2) || (!isAsc && tmp1 > tmp2)) {
            [self swapArrayElement:tmpArray index1:tmpIndex index2:tmpIndex2];
        }
    }
    
    NSLog(@"=======选择排序结果（%@）:%@", isAsc ? @"升序" : @"降序", tmpArray);
}

#pragma mark 冒泡排序
- (void)bubbleSort:(BOOL)isAsc
{
    NSMutableArray *tmpArray = @[@5, @3, @9, @4, @6, @8, @1, @7, @2].mutableCopy;
    for (int i = 0; i < tmpArray.count; i++) {
        int tmpIndex = i + 1;
        for (int j = 0; j < tmpArray.count - tmpIndex; j++) {
            int tmp1 = [tmpArray[j] intValue];
            int tmp2 = [tmpArray[j+1] intValue];
            if ((isAsc && tmp1 > tmp2) || (!isAsc && tmp1 < tmp2)) {
                [self swapArrayElement:tmpArray index1:j index2:j+1];
            }
        }
    }
    
    NSLog(@"=======冒泡排序结果（%@）:%@", isAsc ? @"升序" : @"降序", tmpArray);
}

#pragma mark 快速排序（这边使用到递归）
- (void)quickSort:(NSMutableArray *)array low:(int)low high:(int)high isAsc:(BOOL)isAsc
{
    if (low >= high) {
        return;
    }

    int i = low;
    int j = high;
    id refObject = array[i];
    
    while (i < j) {
        while (i < j && ((isAsc && [array[j] intValue] >= [refObject intValue]) || (!isAsc && [array[j] intValue] <= [refObject intValue]))) {
            j--;
        }
        if (i == j) {
            break;
        }
        array[i++] = array[j];
        
        while (i < j && ((isAsc && [array[i] intValue] <= [refObject intValue]) || (!isAsc && [array[i] intValue] >= [refObject intValue]))) {
            i++;
        }
        if (i == j) {
            break;
        }
        array[j--] = array[i];
    }
    array[i] = refObject;
    [self quickSort:array low:low high:i-1 isAsc:isAsc];
    [self quickSort:array low:i+1 high:high isAsc:isAsc];
}

#pragma mark 字符串逆序输出
- (void)reverseString:(NSString *)string
{
    NSMutableString *tmpStr = [NSMutableString stringWithString:string];
    for (int i = 0; i < floorf(tmpStr.length/2); i++) {
        [tmpStr replaceCharactersInRange:NSMakeRange(i, 1) withString:[string substringWithRange:NSMakeRange(string.length - i - 1, 1)]];
        [tmpStr replaceCharactersInRange:NSMakeRange(string.length - i - 1, 1) withString:[string substringWithRange:NSMakeRange(i, 1)]];
    }
    NSLog(@"=======字符串逆序输出结果:%@", tmpStr);
    NSLog(@"=======string指针地址:%p，string指针指向的对象内存地址:%p", &string, string);
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            [self selectSort:YES];
        }
            break;
        case 1: {
            [self bubbleSort:NO];
        }
            break;
        case 2: {
            NSMutableArray *tmpArray = @[@5, @3, @9, @4, @6, @8, @1, @7, @2].mutableCopy;
            BOOL isAsc = NO;
            [self quickSort:tmpArray low:0 high:[[NSString stringWithFormat:@"%ld", tmpArray.count-1] intValue] isAsc:isAsc];
            NSLog(@"=======快速排序结果（%@）:%@", isAsc ? @"升序" : @"降序", tmpArray);
        }
            break;
        case 3: {
            
        }
            break;
        case 4: {
            NSString *string = @"Hello Word!!!";
            [self reverseString:string];
            NSLog(@"=======string指针地址:%p，string指针指向的对象内存地址:%p", &string, string);
        }
            break;
        case 5: {
            
        }
            break;
            
        default:
            break;
    }
}

@end
