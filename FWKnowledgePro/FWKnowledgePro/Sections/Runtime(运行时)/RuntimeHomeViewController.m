//
//  RuntimeHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/1/27.
//

#import "RuntimeHomeViewController.h"
#import "MessageSendTest.h"
#import "MessageSendTest+Extend.h"
#import "RTPerson.h"
#import "RTPerson2.h"
#import "RTPerson3.h"
#import "RTPerson4.h"
#import <objc/message.h>
#import "RTTest.h"
#import "NSObject+KVO.h"
#import "RTPerson5.h"

@interface RuntimeHomeViewController ()

@property (nonatomic, strong) RTPerson3 *person3;

@end


@implementation RuntimeHomeViewController

- (void)dealloc
{
    // [self removeObserver:self forKeyPath:@"name"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Runtime";
    
    NSMutableArray *tmpArray = @[
        @"消息转发机制",
        @"拦截系统方法",
        @"通过分类添加属性",
        @"实现自动归解档",
        @"字典模型互转",
        @"自定义kvo",
        @"自定义kvc",
        @"动态创建类、方法、实例变量",
        @"获取实例变量、实例属性、实例方法",
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
            // 演示一：消息转发机制
            // [[MessageSendTest new] setName:@"测试"];
            
            
            // 演示二：RTTest.h文件未定义test方法
            // 调用方法的本质其实就是发消息
            
            // NSClassFromString() 还可以使用：objc_getClass()
            // NSSelectorFromString() 还可以使用：sel_registerName()
            // RTTest *rTest = [RTTest alloc];
            RTTest *rTest = ((RTTest* (*)(id, SEL))objc_msgSend)(objc_getClass("RTTest"), sel_registerName("alloc"));
            // rTest = [rTest init];
            rTest = ((RTTest* (*)(id, SEL))objc_msgSend)(rTest, sel_registerName("init"));
            
            // [test performSelector:@selector(test)];
            ((void (*)(id, SEL))objc_msgSend)(rTest, sel_registerName("test"));
            
            
            // 演示三：RTTest.h、RTTest.m文件都未定义test2方法
            RTTest *rTest2 = [[RTTest alloc] init];
            // [rTest2 performSelector:@selector(test2:) withObject:@"test2测试"];
            ((void (*)(id, SEL, id))objc_msgSend)(rTest2, sel_registerName("test2:"), @"test2测试");
        }
            break;
        case 1: {
            
        }
            break;
        case 2: {
            MessageSendTest *mst = [MessageSendTest new];
            mst.type = @"1";
            NSLog(@"MessageSendTest的type：%@", mst.type);
        }
            break;
        case 3: {
            RTPerson *person = [[RTPerson alloc] init];
            person.name = @"李四";
            person.age = @16;
            person.nick = @"小李子";
            
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filePath = [documentPath stringByAppendingString:@"/person.plist"];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                // 归档
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:person requiringSecureCoding:YES error:nil];
                [data writeToFile:filePath atomically:NO];
            } else {
                // 解档
                NSData *data = [NSData dataWithContentsOfFile:filePath];
                NSError *error;
                RTPerson *person2 = [NSKeyedUnarchiver unarchivedObjectOfClass:[RTPerson class] fromData:data error:&error];
                NSLog(@"name = %@, nick = %@, age = %@", person2.name, person2.nick, person2.age);
            }
        }
            break;
        case 4: {
            // 字典 转 模型
            NSDictionary *tmpDict = @{@"name" : @"张三", @"nick" : @"小张"};
            RTPerson2 *person = [[RTPerson2 alloc] initWithDict:tmpDict];
            NSLog(@"name = %@, nick = %@", person.name, person.nick);
            
            NSDictionary *tmpDict2 = [person modelToDict];
            NSLog(@"tmpDict2 = %@", tmpDict2);
        }
            break;
        case 5: {
            // 系统KVO
            RTPerson3 *person = [[RTPerson3 alloc] init];
            _person3 = person;
            
            //            NSLog(@"before - RTPerson3及其所有子类：%@", [RuntimeHomeViewController findSubClass:[RTPerson3 class]]);
            //            [person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
            //            NSLog(@"after - RTPerson3及其所有子类：%@", [RuntimeHomeViewController findSubClass:[RTPerson3 class]]);
            //            self.person3.name = @"王五";
            
            
            // 自定义KVO
            [person fw_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
            self.person3.name = @"王五";
        }
            break;
        case 6: {
            // 系统KVC
            RTPerson4 *person = [RTPerson4 new];
            // 可以发现先调用getName方法，注释掉getName方法后调用name方法，注释掉name方法取name属性，然后依次往下执行；
            NSLog(@"name = %@", [person valueForKey:@"name"]);
            
            
            // 自定义KVC
            [person fw_setValue:@"测试测试" forKey:@"name"];
            NSLog(@"name = %@", [person valueForKey:@"name"]);
        }
            break;
        case 7: {
            // 动态创建类、方法、实例变量，类销毁 的应用
            
            // 1.创建一个类对
            Class RTTest2 = objc_allocateClassPair([NSObject class], "RTTest2", 0);
            // 2.向这个类添加一个方法
            if (class_addMethod(RTTest2, sel_registerName("setTest:"), (IMP)setTest, "v@:@")) {
                NSLog(@"class_addMethod success!");
            }
            // 3.向这个类添加一个实例变量
            class_addIvar(RTTest2, "testName", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
            // 4.注册这个类
            objc_registerClassPair(RTTest2);
            
            // 5.创建一个实例
            id rTest2 = [[RTTest2 alloc] init];
            // 6.使用kvc对成员变量进行赋值
            [rTest2 setValue:@"你好" forKey:@"testName"];
            NSLog(@"testName = %@", [rTest2 valueForKey:@"testName"]);
            
            // 7.调用setTest方法（向该实例发送一条消息）
            ((void (*)(id, SEL, id))objc_msgSend)(rTest2, sel_registerName("setTest:"), @"嗨咯");
            
            // 8.销毁
            rTest2 = nil;
            objc_disposeClassPair(RTTest2);
        }
            break;
        case 8: {
            // 获取实例变量、实例属性、实例方法
            
            RTPerson5 *person = [[RTPerson5 alloc] init];
            [person setValue:@"Tim" forKey:@"name"];
            [person setValue:@"男" forKey:@"gender"];
            person.nickName = @"小提莫";
            
            // 获取实例变量列表
            unsigned int count = 0;
            Ivar *ivars = class_copyIvarList([person class], &count);
            for (int i = 0; i < count; i++) {
                Ivar ivar = ivars[i];
                const char *varName = ivar_getName(ivar);
                NSString *name = [NSString stringWithUTF8String:varName];
                NSLog(@"name = %@, value = %@", name, [person valueForKey:name]);
            }
            free(ivars);
            
            // 获取属性列表
            unsigned int count2 = 0;
            objc_property_t *properties = class_copyPropertyList([person class], &count2);
            for (int i = 0; i < count2; i++) {
                const char *propertyName = property_getName(properties[i]);
                NSString *name = [NSString stringWithUTF8String:propertyName];
                NSLog(@"propertyName = %@, value = %@", name, [person valueForKey:name]);
            }
            free(properties);
            
            // 获取方法列表
            unsigned int count3 = 0;
            Method *methods = class_copyMethodList([person class], &count3);
            for (int i = 0; i < count3; i++) {
                SEL sel = method_getName(methods[i]);
                // 获取该方法的参数个数（至少有两个默认参数：self、_cmd）
                int arg = method_getNumberOfArguments(methods[i]);
                NSLog(@"方法：%@，参数个数：%d", NSStringFromSelector(sel), arg);
            }
            free(methods);
        }
            break;
            
        default:
            break;
    }
    if (tmpVC) {
        [self.navigationController pushViewController:tmpVC animated:YES];
    }
}


#pragma mark -
#pragma mark - Other

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"name"]) {
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark 获取指定类的所有子类
+ (NSArray *)findSubClass:(Class)defaultClass
{
    // 1.获取注册类的总数
    int count = objc_getClassList(NULL, 0);
    
    // 2.创建一个数组，其中包含指定对象
    NSMutableArray *tmpArray = [NSMutableArray arrayWithObject:defaultClass];
    
    // 3.获取所有已注册的类
    Class *classes = (Class *)malloc(sizeof(Class) *count);
    objc_getClassList(classes, count);
    
    // 4.遍历
    for (int i = 0; i < count; i++) {
        if (defaultClass == class_getSuperclass(classes[i])) {
            [tmpArray addObject:classes[i]];
        }
    }
    
    // 5.释放
    free(classes);
    
    return tmpArray;
}

void setTest(id self, SEL _cmd, NSString *param) {
    NSLog(@"%@", param);
}

@end
