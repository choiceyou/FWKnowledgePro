//
//  SumManager.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import "SumManager.h"

@implementation SumManager

- (SumManager * _Nonnull (^)(float number))add
{
    return ^(float number){
        self.result += number;
        return self;
    };
}

- (SumManager * _Nonnull (^)(float number))sub
{
    return ^(float number){
        self.result -= number;
        return self;
    };
}

@end
