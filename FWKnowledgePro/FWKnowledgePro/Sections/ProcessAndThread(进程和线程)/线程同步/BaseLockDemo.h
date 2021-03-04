//
//  BaseLockDemo.h
//  FWKnowledgePro
//
//  Created by xfg on 2021/2/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseLockDemo : NSObject

/// 卖票演示
- (void)ticketTest;

/// 卖票过程
- (void)saleTicket;


/// 存钱、取钱演示
- (void)moneyTest;

/// 存钱
- (void)saveMoney;

/// 取钱
- (void)withDrawMoney;

@end

NS_ASSUME_NONNULL_END
