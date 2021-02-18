//
//  NSObject+FWJson.h
//  FWKnowledgePro
//
//  Created by xfg on 2021/2/18.
//  字典 <--> 模型 互转分类

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (FWJson)

/// 字典转模型
/// @param dict 字典
+ (instancetype)fw_objectWithJson:(NSDictionary *)dict;

/// 模型转字典
- (NSMutableDictionary *)fw_dictWithObjec;

@end

NS_ASSUME_NONNULL_END
