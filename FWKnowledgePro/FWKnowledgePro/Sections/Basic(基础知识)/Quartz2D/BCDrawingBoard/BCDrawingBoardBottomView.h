//
//  BCDrawingBoardBottomView.h
//  FWKnowledgePro
//
//  Created by xfg on 2021/4/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BCDBBottomBtnClickedBlock)(UIColor *color);
typedef void(^BCDBBottomSliderChangedBlock)(CGFloat value);

@interface BCDrawingBoardBottomView : UIView

/// 点击按钮回调
@property (nonatomic, copy) BCDBBottomBtnClickedBlock btnClickedBlock;
/// 滑动滑竿回调
@property (nonatomic, copy) BCDBBottomSliderChangedBlock sliderChangedBlock;

@end

NS_ASSUME_NONNULL_END
