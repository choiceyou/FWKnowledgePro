//
//  FWPermanentThread.h
//  FWKnowledgePro
//
//  Created by xfg on 2021/2/20.
//  可控制生命周期的常驻线程

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWPermanentThread : NSObject

/// 开始线程
- (void)run;

/// 执行任务
/// @param target 任务
- (void)executeTarget:(void(^)(void))target;

/// 停止任务
- (void)stop;

@end

NS_ASSUME_NONNULL_END
