//
//  WildlifePark.m
//  FWKnowledgePro
//
//  Created by xfg on 2019/11/30.
//

#import "WildlifePark.h"
#import <UIKit/UIKit.h>
#import "Monkey.h"
#import "WildlifeParkIterator.h"

@interface WildlifePark ()

@property (nonatomic, strong) NSArray<Monkey *> *monkeyArray;

@end


@implementation WildlifePark

- (instancetype)init
{
    self = [super init];
    if (self) {
        Monkey *monkey1 = [self addMonkey:@"公" weight:63];
        Monkey *monkey2 = [self addMonkey:@"母" weight:64];
        self.monkeyArray = @[monkey1, monkey2];
    }
    return self;
}

- (Monkey *)addMonkey:(NSString *)sex weight:(CGFloat)weight
{
    Monkey *monkey = [[Monkey alloc] init];
    monkey.sex = sex;
    monkey.weight = weight;
    return monkey;
}

- (nonnull Iterator *)createIterator
{
    return [[WildlifeParkIterator alloc] initWithData:self.monkeyArray];
}

@end
