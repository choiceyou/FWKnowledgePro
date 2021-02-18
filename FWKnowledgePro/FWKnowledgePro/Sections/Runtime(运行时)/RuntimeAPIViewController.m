//
//  RuntimeAPIViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/2/18.
//  常用的API，并不是所有的

#import "RuntimeAPIViewController.h"
#import <objc/message.h>
#import "RTPerson3.h"
#import "RTPerson5.h"
#import "RTAnimal.h"

@interface RuntimeAPIViewController ()

@end


@implementation RuntimeAPIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *tmpArray = @[
        @"Runtime_API_类",
        @"Runtime_API_成员变量",
        @"Runtime_API_属性",
        @"Runtime_API_方法",
    ].mutableCopy;
    
    [self.titleArray addObjectsFromArray:tmpArray];
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            RTPerson3 *person = [[RTPerson3 alloc] init];
            [person eat];
            
            // 获取isa指向的Class
            NSLog(@"%p %p", object_getClass(person), object_getClass([RTPerson3 class]));
            
            // 设置isa执行的Class
            // object_setClass(person, [RTPerson5 class]);
            // [person eat];
            
            // 判断一个OC对象是否为Class
            NSLog(@"person是否类对象：%d，[RTPerson3 class]是否类对象：%d", object_isClass(person), object_isClass([RTPerson3 class]));
            
            // 判断一个Class是否有元类
            NSLog(@"[RTPerson3 class]是否为元类：%d，object_getClass([RTPerson3 class])是否有元类：%d", class_isMetaClass([RTPerson3 class]), class_isMetaClass(object_getClass([RTPerson3 class])));
            
            // 获取父类（可观察：p (Class)地址）
            NSLog(@"%p", class_getSuperclass([RTPerson5 class]));
            
            // ============
            // 动态创建一个类（参数：父类，类名，额外的内存空间）
            Class RTCat = objc_allocateClassPair([RTAnimal class], "RTCat", 0);
            
            // 添加成员变量（已经注册的类是不能动态添加成员变量的）
            class_addIvar(RTCat, "_age", 4, 1, @encode(int));
            
            // 添加方法
            class_addMethod(RTCat, sel_registerName("catEat"), class_getMethodImplementation([self class], sel_registerName("animalEat2")), "v@:");
            
            // 注册一个类（要在类注册之前添加成员变量，方法、属性之类的任何时候都可以添加）
            objc_registerClassPair(RTCat);
            NSLog(@"查看RTCat占用多少内存：%zu", class_getInstanceSize(RTCat));
            
            id cat = [[RTCat alloc] init];
            // 通过KVC设值
            [cat setValue:@5 forKey:@"_age"];
            // 调用方法
            ((void (*)(id, SEL))objc_msgSend)(cat, sel_registerName("catEat"));
            
            NSLog(@"%d", [[cat valueForKey:@"_age"] intValue]);
            
            // 销毁一个类
            // objc_disposeClassPair([RTCat class]);
        }
            break;
        case 1: {
            // 获取成员变量信息
            Ivar ivar = class_getInstanceVariable([RTPerson5 class], "_nickName");
            const char *ivarName = ivar_getName(ivar);
            NSLog(@"%@", [NSString stringWithUTF8String:ivarName]);
            
            RTPerson5 *person = [[RTPerson5 alloc] init];
            // 设置成员变量的值
            object_setIvar(person, ivar, @"张三");
            NSLog(@"设置的成员变量值：%@", person.nickName);
            // 获取成员变量的值
            NSLog(@"获取的成员变量值：%@", object_getIvar(person, ivar));
            
            // 获取类的成员变量列表
            unsigned int count;
            Ivar *ivarList = class_copyIvarList([RTPerson5 class], &count);
            for (int i = 0; i < count; i++) {
                Ivar ivar = ivarList[i];
                NSLog(@"%s %s", ivar_getName(ivar), ivar_getTypeEncoding(ivar));
            }
            free(ivarList);
        }
            break;
        case 2: {
            unsigned int count;
            objc_property_t * properties = class_copyPropertyList([self class], &count);
            for (int i = 0; i < count; i++) {
                objc_property_t property = properties[i];
                NSLog(@"%s", property_getName(property));
            }
            free(properties);
        }
            break;
        case 3: {
            RTPerson5 *person = [[RTPerson5 alloc] init];
            [person eat];
            class_replaceMethod([RTPerson5 class], sel_registerName("eat"), (IMP)animalEat, "v16@0:8");
            [person eat];
        }
            break;
            
        default:
            break;
    }
}


void animalEat(id self, SEL _cmd)
{
    NSLog(@"%@, %@", self, NSStringFromSelector(_cmd));
}

- (void)animalEat2
{
    NSLog(@"%s", __func__);
}

@end
