//
//  PTHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import "PTHomeViewController.h"
#import "NSObject+sum.h"
#import "PTPerson.h"
#import <NSObject+RACKVOWrapper.h>
#import <ReactiveObjC.h>

// 重用标识符
static NSString *const kCellIdentifier = @"kCellIdentifier";

static NSString *const kTypeName = @"typeName";
static NSString *const kModeName = @"modeName";


@interface PTHomeViewController ()

/// 数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) PTPerson *person;

@end


@implementation PTHomeViewController

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"编程思想";
    
    NSMutableArray *tmpArray = @[
        @{
            kTypeName : @"一、编程思想",
            kModeName : @[
                    @"面向对象编程（Object Oriented Programming，简称：OOP）",
                    @"面向过程编程（Process Oriented programming，简称：POP）",
                    @"面向切面编程（Aspect Oriented Programming，简称：AOP）",
                    @"面向服务架构（简称：SOA）"
            ]
        },
        @{
            kTypeName : @"二、面向对象的三大特性",
            kModeName : @[
                    @"封装：将类的某些信息隐藏在类内部，不允许外部程序直接访问，而是通过该类提供的方法来实现对隐藏信息的操作和访问，常见的实现方式就是：getter、setter；",
                    @"继承：继承是类与类的一种关系，子类拥有父类的所有属性和方法（除了private修饰的属性不能拥有）从而实现了实现代码的复用；",
                    @"多态：多态一般都要跟继承结合起来说，其本质是子类通过重写或重载父类的方法，来使得对同一类对象同一方法的调用产生不同的结果（简单定义就是：父类类型的指针指向子类对象）。",
            ]
        },
        @{
            kTypeName : @"三、其它编程思想",
            kModeName : @[
                    @"链式编程",
                    @"响应式编程",
                    @"函数式编程",
            ]
        },
    ].mutableCopy;
    
    [self.dataArray addObjectsFromArray:tmpArray];
    
    self.tableView.estimatedRowHeight = 44.f;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    
    
    PTPerson *p = [PTPerson new];
    [p rac_observeKeyPath:@"name" options:NSKeyValueObservingOptionNew observer:self block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        NSLog(@"change = %@", change);
    }];
    
    _person = p;
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *tmpDict = [self.dataArray objectAtIndex:section];
    NSArray *tmpArray = [tmpDict objectForKey:kModeName];
    return tmpArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *tmpDict = [self.dataArray objectAtIndex:indexPath.section];
    NSArray *tmpArray = [tmpDict objectForKey:kModeName];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld、%@", indexPath.row + 1, [tmpArray objectAtIndex:indexPath.row]];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *tmpDict = [self.dataArray objectAtIndex:section];
    return [tmpDict objectForKey:kTypeName];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                
            }
                break;
            case 1: {
                
            }
                break;
            case 2: {
                
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: {
                
            }
                break;
            case 1: {
                
            }
                break;
            case 2: {
                /**
                 多态的好处：如果函数参数（方法）中使用的是父类类型，可以传入父类、子类对象；
                 多态的局限性：父类类型的变量不能直接调用子类特有的方法。必须强转为子类类型变量后，才能直接调用子类特有的方法；
                 */
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0: {
                // 链式编程思想：自定义类似Masonry
                float result =[self FW_makeMgr:^(SumManager * _Nonnull mgr) {
                    mgr.add(5.1).sub(3.2).add(2.5);
                }];
                NSLog(@"result = %f", result);
            }
                break;
            case 1: {
                static int a = 0;
                self.person.name = [NSString stringWithFormat:@"%d", a++];
            }
                break;
            case 2: {
                
            }
                break;
                
            default:
                break;
        }
    }
}


#pragma mark -
#pragma mark - GET/SET

- (NSMutableArray<NSString *> *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

@end
