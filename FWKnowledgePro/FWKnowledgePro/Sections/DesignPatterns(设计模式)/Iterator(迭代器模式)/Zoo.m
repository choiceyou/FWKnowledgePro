//
//  Zoo.m
//  FWKnowledgePro
//
//  Created by xfg on 2019/11/30.
//

#import "Zoo.h"
#import <UIKit/UIKit.h>
#import "Monkey.h"
#import "ZooIterator.h"

@interface Zoo ()

@property (nonatomic, strong) NSMutableArray<Monkey *> *monkeyArray;

@end


@implementation Zoo

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addMonkey:@"公" weight:61];
        [self addMonkey:@"母" weight:62];
    }
    return self;
}

- (void)addMonkey:(NSString *)sex weight:(CGFloat)weight
{
    Monkey *monkey = [[Monkey alloc] init];
    monkey.sex = sex;
    monkey.weight = weight;
    [self.monkeyArray addObject:monkey];
}

- (nonnull Iterator *)createIterator
{
    return [[ZooIterator alloc] initWithData:self.monkeyArray];
}


#pragma mark -
#pragma mark - GET/SET

- (NSMutableArray<Monkey *> *)monkeyArray
{
    if (!_monkeyArray) {
        _monkeyArray = @[].mutableCopy;
    }
    return _monkeyArray;
}

@end
