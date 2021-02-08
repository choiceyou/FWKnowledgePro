//
//  UploadTask.h
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UploadTask : NSObject

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
