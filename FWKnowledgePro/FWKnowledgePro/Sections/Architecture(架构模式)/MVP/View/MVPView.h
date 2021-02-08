//
//  MVPView.h
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MVPViewDelegate <NSObject>

@optional

- (void)clickView;

@end


@interface MVPView : UIView

@property (nonatomic, weak) id<MVPViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
