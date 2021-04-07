//
//  BCDrawingBoardHeadView.h
//  FWKnowledgePro
//
//  Created by xfg on 2021/4/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BCDBHeadActionType) {
    BCDBHeadActionTypeClear,        // 清屏
    BCDBHeadActionTypeRevoke,       // 撤销
    BCDBHeadActionTypeEraser,       // 橡皮擦
    BCDBHeadActionTypeSelectPhoto,  // 选择照片
    BCDBHeadActionTypeSave,         // 保存
};

typedef void(^BCDBHeadBtnActionBlock)(BCDBHeadActionType type);


@interface BCDrawingBoardHeadView : UIView

/// 点击按钮回调
@property (nonatomic, copy) BCDBHeadBtnActionBlock headBtnActionBlock;

@end

NS_ASSUME_NONNULL_END
