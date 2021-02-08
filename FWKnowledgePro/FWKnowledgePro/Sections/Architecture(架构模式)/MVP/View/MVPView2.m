//
//  MVPView2.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import "MVPView2.h"

@interface MVPView2 ()

@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation MVPView2

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setupTitle:(NSString *)title
{
    self.titleLabel.text = title;
}


#pragma mark -
#pragma mark - GET/SET

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
