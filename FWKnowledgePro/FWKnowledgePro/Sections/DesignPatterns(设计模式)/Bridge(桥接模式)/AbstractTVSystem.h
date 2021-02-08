//
//  AbstractTVSystem.h
//  FWKnowledgePro
//
//  Created by xfg on 2019/12/1.
//

#import <Foundation/Foundation.h>
#import "AbstractTVProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface AbstractTVSystem : NSObject

/// 实现了AbstractTVProtocol协议的电视
@property (nonatomic, strong) id<AbstractTVProtocol> tvSystem;


/// 初始化方法
/// @param system 实现了AbstractTVProtocol协议的电视
- (instancetype)initWith:(id<AbstractTVProtocol>)system;

/// 开、关电视
- (void)onOff;

/// 下一个频道
- (void)nextChannel;

/// 上一个频道
- (void)preChannel;

@end

NS_ASSUME_NONNULL_END
