//
//  MVPView.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import "MVPView.h"

@implementation MVPView

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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickView)]) {
        [self.delegate clickView];
    }
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
