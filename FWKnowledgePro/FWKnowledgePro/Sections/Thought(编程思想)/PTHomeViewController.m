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
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"编程思想";
    
    NSMutableArray *tmpArray = @[
        @"链式编程",
        @"响应式编程",
        @"函数式编程",
    ].mutableCopy;
    
    [self.titleArray addObjectsFromArray:tmpArray];
    
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

@end
