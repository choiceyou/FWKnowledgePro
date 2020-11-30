//
//  PrototypeJob.h
//  FWKnowledgePro
//
//  Created by xfg on 2020/11/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrototypeJob : NSObject <NSCopying>

/// 公司
@property (nonatomic, copy) NSString *company;
/// 职位
@property (nonatomic, copy) NSString *position;
/// 年限要求
@property (nonatomic, assign) NSInteger years;

@end

NS_ASSUME_NONNULL_END
