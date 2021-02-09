//
//  CategoryHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/8.
//

/**
 1、通过Runtime动态将分类的方法合并到类对象、元类对象中；
 
 2、Category的加载处理过程：
 （1）通过Runtime加载某个类的所有category数据；
 （2）把所有category的方法、属性、协议数据，合并到一个大数组中。后面参与编译的category数据，会在数组的前面；
 （3）将合并后的分类数据（方法、属性、协议），插入到类原来数据的前面；
 
 3、+load 方法会在runtime加载类、分类时调用（只会调用一次）；
 调用顺序：
 （1）先调用类的+load方法；
    a. 按照编译先后顺序调用（先编译，先调用）；
    b. 调用子类的+load之前会先调用父类的+load方法（内部是通过递归方法实现）；
 （2）再调用Category的+load方法；
    a. 按照编译先后顺序调用（先编译，先调用）
 
 4、+initialize 方法会在类第一次接收到消息时调用；
 调用顺序：先调用父类的+initialize方法，再调用子类的+initialize方法；
 （先初始化父类，再初始化子类，每个类只会初始化一次）
 
 +initialize方法是通过objc_msgSend方法调用的，所以有一下几个特点：
 （1）如果子类没有实现+initialize方法，会调用父类的+initialize方法（所有父类的+initialize方法可能会被多次调用）；
 （2）如果分类实现了+initialize方法，就会覆盖类本身的+initialize方法的调用；
 */

#import "CategoryHomeViewController.h"
#import <objc/runtime.h>
#import "CYPerson.h"
#import "CYStudent.h"

@interface CategoryHomeViewController ()

@end


@implementation CategoryHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *tmpArray = @[
        @"测试"
    ].mutableCopy;
    
    [self.titleArray addObjectsFromArray:tmpArray];
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
//            [self printMethodNameOfClass:object_getClass([CYPerson class])];
            
            [CYPerson alloc];
//            [CYStudent alloc];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark - Other

#pragma mark 打印某个类对象或者元类对象的所有方法
- (void)printMethodNameOfClass:(Class)cls
{
    unsigned int count;
    Method *methodList = class_copyMethodList(cls, &count);
    NSMutableString *methodNames = [NSMutableString string];
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSString *methodName = NSStringFromSelector(method_getName(method));
        [methodNames appendString:methodName];
        [methodNames appendString:@", "];
    }
    free(methodList);
    
    NSLog(@"%@的所有方法：%@", cls, methodNames);
}


@end
