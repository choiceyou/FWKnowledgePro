//
//  PrototypePersonShallowCopy.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/11/27.
//

#import "PrototypePersonShallowCopy.h"

@implementation PrototypePersonShallowCopy

- (id)copyWithZone:(NSZone *)zone
{
    PrototypePerson *ptPerson = [[PrototypePerson allocWithZone:zone] init];
    ptPerson.name = self.name;
    ptPerson.age = self.age;
    ptPerson.height = self.height;
    ptPerson.gender = self.gender;
    ptPerson.job = self.job;
    return ptPerson;
}

@end
