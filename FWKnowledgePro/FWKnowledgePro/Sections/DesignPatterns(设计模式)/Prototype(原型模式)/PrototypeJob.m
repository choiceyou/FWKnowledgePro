//
//  PrototypeJob.m
//  FWKnowledgePro
//
//  Created by xfg on 2019/11/27.
//

#import "PrototypeJob.h"

@implementation PrototypeJob

- (nonnull id)copyWithZone:(nullable NSZone *)zone
{
    PrototypeJob *ptJob = [[PrototypeJob allocWithZone:zone] init];
    ptJob.company = [self.company copy];
    ptJob.position = [self.position copy];
    ptJob.years = self.years;
    return ptJob;
}

@end
