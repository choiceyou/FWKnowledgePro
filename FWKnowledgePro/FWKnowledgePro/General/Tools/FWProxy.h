//
//  FWProxy.h
//  FWKnowledgePro
//
//  Created by xfg on 2021/2/22.
//

/**
 NSProxy 是一个与NSObject同级别的基类，主要用于消息转发
 
 该类的主要作用：两个产生强引用（循环应用）的对象，可以使用该类作为第三方，弱指向其中一方，从而破解循环应用问题。
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWProxy : NSProxy

/// 初始化工厂方法
/// @param target 目标对象
+ (instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
