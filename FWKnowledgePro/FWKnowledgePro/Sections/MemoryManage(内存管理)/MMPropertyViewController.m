//
//  MMPropertyViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/3/2.
//


/**
 1、assign与weak的区别？
 相同点：
 （1）都可以修饰OC对象；
 （2）都不会强引用OC对象，不能够保住OC对象的命；
 不同点：
 （1）assign一般是作用于基本数据类型，但是也能修饰OC对象；
 （2）weak只能作用于OC对象，不能作用于基本数据类型；
 （3）assign所指向的对象销毁时不会将当前指向对象的指针置为nil，有野指针的生成；
 （4）weak所指向的对象销毁时会将当前指向对象的所有weak指针置为nil，防止野指针；
 
 2、assign与copy的区别？
 相同点：都可以修饰OC对象；
 不同点：
 （1）assign一般是作用于基本数据类型，但是也能修饰OC对象；
 （2）copy只能作用于实现了NSCoping协议的OC对象或其子类对象；
 （3）assign所指向的对象销毁时不会将当前指向对象的指针置为nil，有野指针的生成；
 （4）copy修饰不可变对象时，是指针拷贝，相当于retain（引用计数+1）；copy修饰可变对象时，会生成新的对象（引用计数为1）。
 */

#import "MMPropertyViewController.h"

@interface MMPropertyViewController ()

/// assign修饰OC对象，不能够保住OC对象的命。对象被释放后如果该指针不置为nil，再次访问该对象就出现了野指针问题
@property (nonatomic, assign) MPPerson *person;
/// copy只能作用于实现了NSCoping协议的OC对象或其子类对象
@property (nonatomic, copy) UIImageView *imgView;
/// atomic能保证该属性的setter、getter方法内部是线程同步的，但是无法保证array添加、删除元素是线程同步的
@property (atomic, strong) NSMutableArray *dataArray;

@end


@implementation MMPropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"属性修饰符";
    
    NSMutableArray *tmpArray = @[
        @"copy（崩溃演示）",
        @"assign（崩溃演示）",
        @"retain",
        @"strong",
        @"weak",
        @"readwrite - 可读写",
        @"readonly - 只读",
        @"atomic - 原则性",
        @"nonatomic - 非原子性"
    ].mutableCopy;
    
    [self.titleArray addObjectsFromArray:tmpArray];
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            /**
             copy的目的：拷贝一份副本对象（实现副本对象与源对象互不影响）；
             
             注意：NSString、NSArray、NSDictionary、NSData、NSSet等类有默认实现了<NSCopying>协议，如果是自定义类，默认未实现该协议，因此，使用该协议修饰的话会崩溃；
             
             深拷贝、浅拷贝（具体参考图：10_copy和mutableCopy）：
             （1）copy修饰不可变对象：浅拷贝（指针拷贝，未产生新的对象）；
             （2）copy修饰可变对象：深拷贝（产生新的对象）；
             （3）mutableCopy修饰不可变对象：深拷贝（产生新的对象）；
             （4）mutableCopy修饰可变对象：深拷贝（产生新的对象）；
             */
            
            // copy只能作用于实现了NSCoping协议的OC对象或其子类对象（反之，会崩溃）
            self.imgView = [[UIImageView alloc] init];
        }
            break;
        case 1: {
            /**
             1、一般用来修饰基础数据类型（NSInteger、CGFloat、int、float、double等）；
             
             2、但是它也可以修饰OC对象（一般不这么做的），只是会有一下几点问题：
             （1）它的setter方法直接赋值，不进行任何retain操作，因此它不能保住OC对象的命；
             （2）assign所指向的对象销毁时不会将当前指向对象的指针置为nil，有野指针的生成；
             */
            
            // assign修饰OC对象，不能够保住OC对象的命。对象被释放后如果该指针不置为nil，再次访问该对象就出现了野指针问题
            self.person = [[MPPerson alloc] init];
            self.person.name = @"张三";
            self.person.age = 15;
            
            // self.person = nil; // 将person指针置为nil
            // 野指针错误：给已经释放了的对象发送消息
            NSLog(@"%@", self.person.name);
        }
            break;
        case 2: {
            /**
             一般在MRC模式下使用，被retain修饰的对象，引用计数retainCount要加1的。retain只能修饰oc对象，不能修饰非oc对象。
             注意：容易出现循环引用，导致内存泄露问题。
             */
        }
            break;
        case 3: {
            /**
             strong表示对对象的强引用，一般在ARC模式下使用，相当于retain
             注意：两个对象之间相互强引用造成循环引用，内存泄漏。
             */
        }
            break;
        case 4: {
            /**
             weak表示对对象的弱引用，一般在ARC模式下使用。
             被weak修饰的对象引用计数不会加1，因此，被修饰的对象随时可被系统销毁和回收；
             */
        }
            break;
        case 5: {
            /**
             readwrite修饰的时候表示该属性可读可改。系统默认的情况就是 readwrite。
             */
        }
            break;
        case 6: {
            /**
             readonly修饰的时候表示这个属性只可以读取，不可以修改，一般常用在我们不希望外界改变只希望外界读取这种情况
             */
            
            // 使用height属性，演示readonly修饰符。 .h文件中定义readonly，.m文件中定义readwrite
            // self.person.height = 175;
            NSLog(@"%f", self.person.height);
        }
            break;
        case 7: {
            /**
             atomic 原子属性。用于保证属性setter、getter的原子性操作，相当于在getter和setter内部加了线程同步的锁。但是它并不能保证使用属性的过程是线程安全的。
             */
            
            // atomic能保证该属性的setter、getter方法内部是线程同步的，但是无法保证array添加、删除元素是线程同步的
            NSMutableArray *array = [NSMutableArray array];
            self.dataArray = array;
            NSLog(@"%@", self.dataArray);
            
            dispatch_queue_t queue = dispatch_queue_create("com.xx.testqueue", DISPATCH_QUEUE_CONCURRENT);
            dispatch_async(queue, ^{
                [self.dataArray addObject:@"1"];
                [self.dataArray addObject:@"2"];
            });
            
            dispatch_async(queue, ^{
                [self.dataArray removeAllObjects];
            });
        }
            break;
        case 8: {
            /**
             nonatomic 非原子属性。它的特点是多线程并发访问性能高，但是访问不安全；
             */
        }
            break;
            
        default:
            break;
    }
}

@end
