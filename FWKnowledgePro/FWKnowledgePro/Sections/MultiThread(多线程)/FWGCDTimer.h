//
//  FWGCDTimer.h
//  FWKnowledgePro
//
//  Created by xfg on 2021/2/22.
//  封装一个方便使用的GCD定时器

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWGCDTimer : NSObject

/// 执行GCD定时器
/// @param task 任务
/// @param start 开始时间
/// @param interval 间隔时间
/// @param repeats 是否重复
/// @param async 是否异步
+ (NSString *)executeTask:(void (^)(void))task start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async;

/// 取消定时器
/// @param name 传入创建时的唯一标识符
+ (void)cancelTask:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
