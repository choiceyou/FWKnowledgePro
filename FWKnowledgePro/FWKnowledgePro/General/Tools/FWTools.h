//
//  FWTools.h
//  FWKnowledgePro
//
//  Created by xfg on 2021/3/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWTools : NSObject

/// 获取固定的html字符串
/// @param str 普通字符串
+ (NSString *)htmlWithStr:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
