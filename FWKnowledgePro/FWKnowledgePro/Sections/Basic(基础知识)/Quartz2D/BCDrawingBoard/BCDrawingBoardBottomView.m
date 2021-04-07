//
//  BCDrawingBoardBottomView.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/4/7.
//

#import "BCDrawingBoardBottomView.h"
#import <Masonry/Masonry.h>

@interface BCDrawingBoardBottomView ()

/// 堆视图
@property (nonatomic, weak) UIStackView *stackView;
/// 滑竿
@property (nonatomic, weak) UISlider *slider;

@end


@implementation BCDrawingBoardBottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(15.f);
        make.right.equalTo(self).offset(-15.f);
        make.height.mas_equalTo(26.f);
    }];
    
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.slider.mas_bottom).offset(15.f);
        make.left.right.equalTo(self.slider);
        make.bottom.equalTo(self).offset(-15.f);
    }];
}


#pragma mark -
#pragma mark - Private

- (void)btnAction:(UIButton *)btn
{
    if (btn.tag > 0) {
        !self.btnClickedBlock ? : self.btnClickedBlock(btn.backgroundColor);
    }
}

- (void)sliderChanged:(UISlider *)slider
{
    !self.sliderChangedBlock ? : self.sliderChangedBlock(slider.value);
}


#pragma mark -
#pragma mark - GET/SET

- (UIStackView *)stackView
{
    if (!_stackView) {
        UIStackView *tmpStackView = [[UIStackView alloc] init];
        tmpStackView.axis = UILayoutConstraintAxisHorizontal;
        tmpStackView.distribution = UIStackViewDistributionFillEqually;
        tmpStackView.spacing = 10.f;
        tmpStackView.alignment = UIStackViewAlignmentFill;
        tmpStackView.backgroundColor = [UIColor clearColor];
        [self addSubview:tmpStackView];
        _stackView = tmpStackView;
        
        for (int i = 0; i < 3; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i + 1;
            if (i == 0) {
                [btn setBackgroundColor:[UIColor redColor]];
            } else if (i == 1) {
                btn.backgroundColor = [UIColor greenColor];
            } else {
                btn.backgroundColor = [UIColor blueColor];
            }
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [tmpStackView addArrangedSubview:btn];
        }
    }
    return _stackView;
}

- (UISlider *)slider
{
    if (!_slider) {
        UISlider *tmpSlider = [[UISlider alloc] init];
        [self addSubview:tmpSlider];
        tmpSlider.minimumValue = 1.f;
        tmpSlider.maximumValue = 20.f;
        [tmpSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        _slider = tmpSlider;
    }
    return _slider;
}

@end
