//
//  BCDrawingBoardView.h
//  FWKnowledgePro
//
//  Created by xfg on 2021/4/7.
//

#import <UIKit/UIKit.h>
#import "BCDrawingBoardHeadView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BCDrawingBoardView : UIView

/// 头部的按钮的相关操作
/// @param type 操作类型
- (void)headBtnActionWithType:(BCDBHeadActionType)type;

/// 底部按钮改变
/// @param color 按钮颜色
- (void)bottomBtnClicked:(UIColor *)color;

/// 底部滑竿滑动
/// @param value 滑竿值
- (void)bottomSliderChanged:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END
