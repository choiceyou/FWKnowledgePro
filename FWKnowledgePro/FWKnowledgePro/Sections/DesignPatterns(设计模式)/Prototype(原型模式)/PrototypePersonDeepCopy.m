//
//  PrototypePersonDeepCopy.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/11/27.
//

#import "PrototypePersonDeepCopy.h"

@implementation PrototypePersonDeepCopy

- (id)copyWithZone:(NSZone *)zone
{
    PrototypePerson *ptPerson = [[PrototypePerson allocWithZone:zone] init];
    ptPerson.name = [self.name copy];
    ptPerson.age = self.age;
    ptPerson.height = self.height;
    ptPerson.gender = self.gender;
    ptPerson.job = [self.job copy];
    return ptPerson;
}

@end
