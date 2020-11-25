//
//  UserTestModel.h
//  MSPro
//
//  Created by xfg on 2020/11/19.
//  Copyright © 2020 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserTestModel : NSObject <NSSecureCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger age;
@property (nonatomic, assign) NSInteger sex;

@end

NS_ASSUME_NONNULL_END
