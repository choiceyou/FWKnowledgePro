//
//  ClassTestModel.h
//  MSPro
//
//  Created by xfg on 2019/11/20.
//  Copyright © 2020 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudentTestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassTestModel : NSObject

@property (nonatomic, copy) NSString *class_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, strong) NSMutableArray<StudentTestModel *> *studentArray;

@end

NS_ASSUME_NONNULL_END
