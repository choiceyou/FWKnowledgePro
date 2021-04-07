//
//  BCGestureLockViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/4/6.
//

#import "BCGestureLockViewController.h"
#import "BCGestureLockView.h"
#import <Masonry/Masonry.h>

@interface BCGestureLockViewController ()

/// 背景图片
@property (nonatomic, strong) UIImageView *bgImgView;
/// 手势锁视图
@property (nonatomic, strong) BCGestureLockView *gestureLockView;

@end


@implementation BCGestureLockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"手势解锁";
    
    [self setupConstraits];
}

- (void)setupConstraits
{
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.gestureLockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.gestureLockView.mas_width);
    }];
}


#pragma mark -
#pragma mark - GET/SET

- (UIImageView *)bgImgView
{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gesture_bg"]];
        [self.view addSubview:_bgImgView];
    }
    return _bgImgView;
}

- (BCGestureLockView *)gestureLockView
{
    if (!_gestureLockView) {
        _gestureLockView = [[BCGestureLockView alloc] init];
        [self.view addSubview:_gestureLockView];
    }
    return _gestureLockView;
}

@end
