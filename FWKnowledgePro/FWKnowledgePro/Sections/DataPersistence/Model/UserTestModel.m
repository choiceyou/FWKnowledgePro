//
//  UserTestModel.m
//  MSPro
//
//  Created by xfg on 2020/11/19.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "UserTestModel.h"

@implementation UserTestModel

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.name = [coder decodeObjectForKey:@"name"];
        self.age = [coder decodeIntegerForKey:@"age"];
        self.sex = [coder decodeIntegerForKey:@"sex"];
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder
{
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeInteger:self.age forKey:@"age"];
    [coder encodeInteger:self.sex forKey:@"sex"];
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
