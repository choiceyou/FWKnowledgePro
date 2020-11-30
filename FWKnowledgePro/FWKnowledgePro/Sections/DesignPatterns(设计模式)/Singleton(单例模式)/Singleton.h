//
//  Singleton.h
//  FWKnowledgePro
//
//  Created by xfg on 2020/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Singleton : NSObject

/// 单例模式
+ (Singleton *)sharedInstance;

@end

NS_ASSUME_NONNULL_END
