//
//  RTPerson2.h
//  FWKnowledgePro
//
//  Created by xfg on 2020/1/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTPerson2 : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nick;


/// 字典==》模型
/// @param dict 字典
- (instancetype)initWithDict:(NSDictionary *)dict;

/// 模型转字典
- (NSDictionary *)modelToDict;

@end

NS_ASSUME_NONNULL_END
