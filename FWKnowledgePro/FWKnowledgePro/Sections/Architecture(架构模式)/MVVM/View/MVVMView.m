//
//  MVVMView.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import "MVVMView.h"
#import <NSObject+RACKVOWrapper.h>
#import <KVOController.h>

@interface MVVMView ()

@property (nonatomic, weak) MVVMViewModel *myViewModel;

@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MVVMView

- (void)dealloc
{
    [self.myViewModel removeObserver:self forKeyPath:@"iconName"];
    [self.myViewModel removeObserver:self forKeyPath:@"title"];
}

- (instancetype)initWithViewModel:(MVVMViewModel *)viewModel
{
    self = [super init];
    if (self) {
        self.myViewModel = viewModel;
        
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.bottom.equalTo(self).offset(-30.f);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.top.equalTo(self.iconImgView.mas_bottom).offset(10.f);
        }];
        
        __weak typeof(self) weakSelf = self;
        // 方法一：这边使用的是RAC的KVO
        [viewModel rac_observeKeyPath:@"iconName" options:NSKeyValueObservingOptionNew observer:self block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.iconImgView.image = [UIImage imageNamed:change[NSKeyValueChangeNewKey]];
        }];
        
        // 方法二：这边使用的是Facebook的KVO
        [self.KVOController observe:viewModel keyPath:@"title" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.titleLabel.text = change[NSKeyValueChangeNewKey];
        }];
        
        // 方法三：通知（一般不推荐使用）
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
