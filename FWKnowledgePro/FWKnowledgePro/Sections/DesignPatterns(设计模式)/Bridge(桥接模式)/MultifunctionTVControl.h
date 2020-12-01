//
//  MultifunctionTVControl.h
//  FWKnowledgePro
//
//  Created by xfg on 2020/12/1.
//

#import "AbstractTVSystem.h"

NS_ASSUME_NONNULL_BEGIN

@interface MultifunctionTVControl : AbstractTVSystem

/// 多功能电视直接选频道
/// @param index 频道下标
- (void)setChannel:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
