//
//  KVCHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/8.
//

/**
 KVC（Key-Value Coding），俗称“键值编码”，可以通过一个key来访问某个属性；
 
 
 总体原则是先找相关方法，再找相关成员变量；
 
 KVC的赋值过程：
 （1）先依次查找set<Key>、_set<Key>、setIs<Key>方法，如果找到直接调用，反之，没有找到则继续寻找；
 （2）通过accessInstanceVariablesDirectly方法判断，如果为YES（默认返回YES），则依次寻找_<Key>、_Is<Key>、<Key>、is<Key>成员变量，如果找到就直接赋值，反之，没有找到调用setValue:forUndefinedKey:函数并抛出异常NSUnknownKeyException；
 （3）通过accessInstanceVariablesDirectly方法判断，如果为NO，直接调用setValue:forUndefinedKey:函数并抛出异常NSUnknownKeyException。

 KVC的取值过程：
 （1）先依次查找get<Key>、<Key>、is<Key>、_<Key>，如果找到直接调用，反之，没有找到则继续寻找；
 （2）通过accessInstanceVariablesDirectly方法判断，如果为YES（默认返回YES），则依次寻找_<Key>、_Is<Key>、<Key>、is<Key>成员变量，如果找到就直接取值，反之，没有找到调用valueForUndefinedKey:函数并抛出异常NSUnknownKeyException；
 （3）通过accessInstanceVariablesDirectly方法判断，如果为NO，直接调用valueForUndefinedKey:函数并抛出异常NSUnknownKeyException。
 */

#import "KVCHomeViewController.h"
#import "KVCPerson.h"

@interface KVCHomeViewController ()

@end

@implementation KVCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *tmpArray = @[
        @"测试KVC"
    ].mutableCopy;
    
    [self.titleArray addObjectsFromArray:tmpArray];
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            KVCPerson *p = [[KVCPerson alloc] init];
            [p setValue:@15 forKey:@"age"];
            NSLog(@"1111");
        }
            break;
            
        default:
            break;
    }
}

@end
