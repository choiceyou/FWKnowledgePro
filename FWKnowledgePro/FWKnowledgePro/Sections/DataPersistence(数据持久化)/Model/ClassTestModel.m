//
//  ClassTestModel.m
//  MSPro
//
//  Created by xfg on 2020/11/20.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "ClassTestModel.h"

@implementation ClassTestModel

- (NSMutableArray<StudentTestModel *> *)studentArray
{
    if (!_studentArray) {
        _studentArray = @[].mutableCopy;
    }
    return _studentArray;
}

@end
