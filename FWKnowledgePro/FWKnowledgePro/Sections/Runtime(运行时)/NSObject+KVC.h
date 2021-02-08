//
//  NSObject+KVC.h
//  FWKnowledgePro
//
//  Created by xfg on 2020/1/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KVC)

- (void)fw_setValue:(nullable id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
