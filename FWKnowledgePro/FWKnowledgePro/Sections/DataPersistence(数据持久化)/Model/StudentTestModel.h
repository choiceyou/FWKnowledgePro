//
//  StudentTestModel.h
//  MSPro
//
//  Created by xfg on 2020/11/20.
//  Copyright © 2020 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StudentTestModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *classId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger age;
@property (nonatomic, copy) NSString *hobby;

@end

NS_ASSUME_NONNULL_END
