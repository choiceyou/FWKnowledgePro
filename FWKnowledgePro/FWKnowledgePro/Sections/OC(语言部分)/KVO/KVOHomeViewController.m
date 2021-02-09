//
//  KVOHomeViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/8.
//

/**
 KVO（Key-Value Observing），俗称“键值监听”，可以用于监听某个对象属性值的变化；
 
 iOS用什么方式实现一个对象的KVO？（KVO的本质是什么？）
 答：利用Runtime的API动态的生成一个子类，并且让instance对象的isa指向这个全新的子类。
 大致流程：
 （1）当修改instance对象的属性时，会调用Foundation的_NSSetXXXValueAndNotify函数；
 （2）调用willChangeValueForKey；
 （3）调用父类原来的setter方法；
 （4）调用didChangeValueForKey，内部会触发监听器（Observe）的监听方法(observeValueForKeyPath:ofObject:change:context:)；
 */

#import "KVOHomeViewController.h"

@interface KVOHomeViewController ()

@end

@implementation KVOHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *tmpArray = @[
        
    ].mutableCopy;
    
    [self.titleArray addObjectsFromArray:tmpArray];
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
