//
//  RTPerson4.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/1/28.
//

/**
 KVC valueForKey (总体规则：先找相关方法，再找相关变量)
 1、先找先关方法：set<Key>、setIs<Key>，如果相关方法找不到往下继续找；
 2、根据accessInstanceVariablesDirectly方法来判断，如果返回NO，直接执行KVC的valueForUndefinedKey（系统抛出一个异常，未定义key）；
 3、根据accessInstanceVariablesDirectly方法来判断，如果返回YES（默认返回的是YES），继续找相关变量（相关变量依次有：_<key>,_is<key>,<key>,is<Key>）；
 */


#import "RTPerson4.h"

@implementation RTPerson4

- (instancetype)init
{
    self = [super init];
    if (self) {
        _name = @"_name";
        _isName = @"_isName";
        name = @"name";
        isName = @"isName";
    }
    return self;
}

+ (BOOL)accessInstanceVariablesDirectly
{
    return YES;
}

- (NSString *)name
{
    return @"name method";
}

- (NSString *)getName
{
    return @"getName method";
}

@end
