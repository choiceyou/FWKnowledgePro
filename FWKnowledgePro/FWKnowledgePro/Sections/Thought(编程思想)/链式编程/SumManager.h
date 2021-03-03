//
//  SumManager.h
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SumManager : NSObject

@property (nonatomic, assign) float result;

/// 加法
- (SumManager * (^)(float number))add;

/// 减法
- (SumManager * (^)(float number))sub;

@end

NS_ASSUME_NONNULL_END
