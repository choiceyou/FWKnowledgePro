//
//  NSObject+KVO.h
//  FWKnowledgePro
//
//  Created by xfg on 2020/1/27.
//  自定义KVO，没有实现完毕

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KVO)

- (void)fw_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;

@end

NS_ASSUME_NONNULL_END
