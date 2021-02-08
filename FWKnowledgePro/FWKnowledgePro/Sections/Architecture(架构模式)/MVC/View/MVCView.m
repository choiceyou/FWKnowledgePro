//
//  MVCView.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import "MVCView.h"

@interface MVCView ()

@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MVCView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.bottom.equalTo(self).offset(-30.f);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.top.equalTo(self.iconImgView.mas_bottom).offset(10.f);
        }];
    }
    return self;
}

- (void)setupView:(MVCModel *)model
{
    self.iconImgView.image = [UIImage imageNamed:model.iconName];
    self.titleLabel.text = model.title;
}


#pragma mark -
#pragma mark - GET/SET

- (UIImageView *)iconImgView
{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        [self addSubview:_iconImgView];
    }
    return _iconImgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
