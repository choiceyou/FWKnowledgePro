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

@interface PTHomeViewController ()

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
            kFirstLevel : @"一、编程思想",
            kSecondLevel : @[
                    @"面向对象编程（Object Oriented Programming，简称：OOP）",
                    @"面向过程编程（Process Oriented programming，简称：POP）",
                    @"面向切面编程（Aspect Oriented Programming，简称：AOP）",
                    @"面向服务架构（简称：SOA）"
            ]
        },
        @{
            kFirstLevel : @"二、面向对象的三大特性",
            kSecondLevel : @[
                    @"封装：将类的某些信息隐藏在类内部，不允许外部程序直接访问，而是通过该类提供的方法来实现对隐藏信息的操作和访问，常见的实现方式就是：getter、setter；",
                    @"继承：继承是类与类的一种关系，子类拥有父类的所有属性和方法（除了private修饰的属性不能拥有）从而实现了实现代码的复用；",
                    @"多态：多态一般都要跟继承结合起来说，其本质是子类通过覆盖或重载父类的方法，来使得对同一类对象同一方法的调用产生不同的结果（简单定义就是：父类类型的指针指向子类对象）。",
            ]
        },
        @{
            kFirstLevel : @"三、面向对象重写、重载",
            kSecondLevel : @[
                    @"重写：在父子类当中，子类拥有与父类同名、同参、同返回类型的方法，可以改变父类的行为；",
                    @"重载：重载一定是在同一个类当中，有一组方法名字相同，功能是类似的，但参数不同。",
            ]
        },
        @{
            kFirstLevel : @"四、其它编程思想",
            kSecondLevel : @[
                    @"链式编程",
                    @"响应式编程",
                    @"函数式编程",
            ]
        },
    ].mutableCopy;
    
    [self.dataArray addObjectsFromArray:tmpArray];
    
    
    PTPerson *p = [PTPerson new];
    [p rac_observeKeyPath:@"name" options:NSKeyValueObservingOptionNew observer:self block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        NSLog(@"change = %@", change);
    }];
    
    _person = p;
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

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

@end
