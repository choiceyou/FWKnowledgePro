//
//  DownloadTask.h
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/2.
//  离线断点续传

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloadTask : NSObject

/// 开始任务
- (void)startTask;

/// 暂停任务
- (void)suspendTask;

/// 取消任务
- (void)cancelTask;

/// 继续任务
- (void)resumeTask;

@end

NS_ASSUME_NONNULL_END
