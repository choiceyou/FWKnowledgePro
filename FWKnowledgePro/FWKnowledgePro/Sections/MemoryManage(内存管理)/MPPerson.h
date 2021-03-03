//
//  MPPerson.h
//  FWKnowledgePro
//
//  Created by xfg on 2021/3/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPPerson : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

/// .h文件中定义readonly，.m文件中定义readwrite
@property (nonatomic, assign, readonly) double height;

@end

NS_ASSUME_NONNULL_END
