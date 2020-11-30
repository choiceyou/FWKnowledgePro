//
//  DPHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/11/26.
//

#import "DPHomeViewController.h"
#import "SingletonTest.h"
#import "PrototypePersonDeepCopy.h"
#import "PrototypePersonShallowCopy.h"
#import "CatFactory.h"
#import "DogFactory.h"
#import "DomesticAnimalFactory.h"
#import "WildAnimalFactory.h"
#import "Zoo.h"
#import "WildlifePark.h"
#import "Iterator.h"
#import "Monkey.h"


// 重用标识符
static NSString *const kCellIdentifier = @"kCellIdentifier";

static NSString *const kTypeName = @"typeName";
static NSString *const kModeName = @"modeName";


@interface DPHomeViewController ()

/// 数据源
@property (nonatomic, strong) NSMutableArray *dataArray;

@end


@implementation DPHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"设计模式";
    
    NSMutableArray *tmpArray = @[
        @{
            kTypeName : @"面向对象五个基本原则(SOLID) + 1条法则",
            kModeName : @[
                    @"单一职责原则（Single Responsibility Principle）：一个类有且仅有一个职责，只有一个引起它变化的原因",
                    @"开闭原则（Open Closed Principle）：软件中的对象（类，模块，函数等）应该对于扩展是开放的，但是对于修改是封闭的。具体来说就是你应该通过扩展来实现变化，而不是通过修改原有的代码来实现变化",
                    @"里氏替换原则（Liskov Substitution Principle）：派生类（子类）对象可以在程序中代替其基类（超类）对象",
                    @"接口隔离原则（Interface Segregation Principle）：客户端不应该依赖它不需要的接口。一个类对另一个类的依赖应该建立在最小的接口上",
                    @"依赖倒置原则（Dependence Inversion Principle）：程序要依赖于抽象接口，不要依赖具体的实现",
                    @"迪米特法则（Law of Demeter）又叫作最少知识原则（The Least Knowledge Principle）：一个类对于其他类知道的越少越好，就是说一个对象应当对其他对象有尽可能少的了解,只和朋友通信，不和陌生人说话",
            ]
        },
        @{
            kTypeName : @"一、创建型",
            kModeName : @[
                    @"单例模式（Singleton）",
                    @"工厂方法（Factory Method）",
                    @"抽象工厂（Abstract Factory）",
                    @"建造模式（Builder）",
                    @"原型模式（Prototype）",
            ]
        },
        @{
            kTypeName : @"二、行为型",
            kModeName : @[
                    @"迭代器模式（Iterator）",
                    @"观察者模式（Observer）",
                    @"模板方法（Template Method）",
                    @"命令模式（Command）",
                    @"状态模式（State）",
                    @"策略模式（Strategy）",
                    @"职责链模式（China of Responsibility）",
                    @"中介者模式（Mediator）",
                    @"访问者模式（Visitor）",
                    @"解释器模式（Interpreter）",
                    @"备忘录模式（Memento）",
            ]
        },
        @{
            kTypeName : @"三、结构型",
            kModeName : @[
                    @"组合模式（Composite）",
                    @"外观模式(Facade)",
                    @"代理模式(Proxy)",
                    @"适配器模式(Adapter)",
                    @"装饰模式(Decrator)",
                    @"桥接模式(Bridge)",
                    @"享元模式(Flyweight)",
            ]
        },
    ].mutableCopy;
    
    [self.dataArray addObjectsFromArray:tmpArray];
    
    self.tableView.estimatedRowHeight = 44.f;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
}


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
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: {
                // 循环创建5个SingletonTest对象，5个对象都相同
                for (int i = 0; i < 5; i++) {
                    SingletonTest *stTest = [SingletonTest sharedInstance];
                    NSLog(@"stTest地址：%@", stTest);
                }
            }
                break;
            case 1: {
                // 外部传入需要创建的工厂
                NSString *factoryStr = @"CatFactory";
                
                id<AnimalProtocol> animal = [NSClassFromString(factoryStr) createAnimal];
                [animal eat];
            }
                break;
            case 2: {
                DomesticAnimalFactory *daFactory = [[DomesticAnimalFactory alloc] init];
                id<AbstractCat> cat = [daFactory createCat];
                [cat eat];
                
                id<AbstractDog> dog = [daFactory createDog];
                [dog eat];
                
                WildAnimalFactory *waFactory = [[WildAnimalFactory alloc] init];
                id<AbstractCat> cat2 = [waFactory createCat];
                [cat2 eat];
                
                id<AbstractDog> dog2 = [waFactory createDog];
                [dog2 eat];
            }
                break;
            case 3: {
                
            }
                break;
            case 4: {
                NSString *strSource = @"I am zhangsanfeng";
                // 使用copy方法,strSource和strCopy内存地址一致,strSource引用计数加1
                NSString *strCopy = [strSource mutableCopy];
                NSLog(@"原始字符串，指向对象的指针的地址：%p, 对象的内存地址：%p, 对象值：%@", &strSource, strSource, strSource);
                NSLog(@"复制字符串，指向对象的指针的地址：%p, 对象的内存地址：%p, 对象值：%@", &strCopy, strCopy, strCopy);
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0: {
                Zoo *zoo = [[Zoo alloc] init];
                Iterator *iterator = [zoo createIterator];
                while ([iterator hasNext]) {
                    Monkey *monkey = [iterator next];
                    NSLog(@"======monkey1:%@, %f", monkey.sex, monkey.weight);
                }
                
                WildlifePark *wlPark = [[WildlifePark alloc] init];
                Iterator *iterator2 = [wlPark createIterator];
                while ([iterator2 hasNext]) {
                    Monkey *monkey = [iterator2 next];
                    NSLog(@"======monkey2:%@, %f", monkey.sex, monkey.weight);
                }
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 3) {
        
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
