//
//  OCHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/12/2.
//

#import "OCHomeViewController.h"
#import "BlockTestViewController.h"

@interface OCHomeViewController ()

@property (nonatomic, copy) NSString *copMutStr;
@property (nonatomic, strong) NSString *strongMutStr;

@end


@implementation OCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"OC语言部分";
    
    NSMutableArray *tmpArray = @[
        @"属性修饰符",
        @"对象消息机制",
        @"Block",
        @"其它",
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
            // 参考：https://www.jianshu.com/p/14c5bbb95846
            
            /**
             一、什么情况使用 weak 关键字，相比 assign 有什么不同？
             
             什么情况使用 weak 关键字？
             1、在 ARC 中,在有可能出现循环引用的时候,往往要通过让其中一端使用 weak 来解决,比如: delegate 代理属性；
             2、自身已经对它进行一次强引用,没有必要再强引用一次,此时也会使用 weak,自定义 IBOutlet 控件属性一般也使用weak；当然，也可以使用strong；
             
             有什么不同？
             1、weak此特质表明该属性定义了一种“非拥有关系” (nonowning relationship)。为这种属性设置新值时，设置方法既不保留新值，也不释放旧值。此特质同assign类似， 然而在属性所指的对象遭到摧毁时，属性值也会清空(nil out)。 而 assign的“设置方法”只会执行针对“纯量类型” (scalar type，例如 CGFloat 或 NSlnteger 等)的简单赋值操作；
             2、assigin 可以用非 OC 对象,而 weak 必须用于 OC 对象；
             
             
             二、property 的本质是什么？ivar、getter、setter 是如何生成并添加到这个类中的？
             @property = ivar + getter + setter;
             自动合成
             
             */
            
            NSMutableString *str = [NSMutableString stringWithFormat:@"123"];
            self.copMutStr = str;
            self.strongMutStr = str;
            [str appendString:@"abc"];
            NSLog(@"打印结果=%@", self.copMutStr);
            NSLog(@"打印结果=%@", self.strongMutStr);
        }
            break;
        case 1: {
            
        }
            break;
        case 2: {
            tmpVC = [[BlockTestViewController alloc] init];
        }
            break;
        case 3: {
            
        }
            break;
            
        default:
            break;
    }
    if (tmpVC) {
        [self.navigationController pushViewController:tmpVC animated:YES];
    }
}

@end
