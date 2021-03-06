//
//  FWOperation.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/3/6.
//

#import "FWOperation.h"

@implementation FWOperation

#pragma mark 定义要执行的任务
#pragma mark 1、有利于代码隐蔽；2、有利于代码复用；
- (void)main
{
    NSLog(@"任务 --- %@", [NSThread currentThread]);
}

@end
