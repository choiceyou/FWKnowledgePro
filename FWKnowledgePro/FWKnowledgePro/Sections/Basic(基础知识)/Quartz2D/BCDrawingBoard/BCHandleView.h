//
//  BCHandleView.h
//  FWKnowledgePro
//
//  Created by xfg on 2021/4/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BCHandleBlock)(UIImage *image);


@interface BCHandleView : UIView

/// 传入从相册中选择的图片
@property (nonatomic, strong) UIImage *image;
/// 传出一张截图
@property (nonatomic, copy) BCHandleBlock handleBlock;

@end

NS_ASSUME_NONNULL_END
