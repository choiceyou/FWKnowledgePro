//
//  NSObject+Singleton.h
//  FWKnowledgePro
//
//  Created by xfg on 2019/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Singleton)

/// 单例模式
+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
