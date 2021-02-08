//
//  RTPerson.h
//  FWKnowledgePro
//
//  Created by xfg on 2020/1/27.
//  自动化归解档

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTPerson : NSObject <NSSecureCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, strong) NSNumber *age;

@end

NS_ASSUME_NONNULL_END
