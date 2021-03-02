//
//  MVPPresenter1.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import "MVPPresenter1.h"
#import "MVPViewController.h"
#import "MVPView.h"
#import "MVPModel.h"

@interface MVPPresenter1 () <MVPViewDelegate>

@property (nonatomic, weak) MVPViewController *currentVC;
@property (nonatomic, strong) MVPView *mView;

@end


@implementation MVPPresenter1

- (instancetype)initWithVC:(MVPViewController *)currentVC
{
    self = [super init];
    if (self) {
        self.currentVC = currentVC;
        
        [self.mView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.mView.superview);
            make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 240.f));
        }];
        
        [self requestData];
    }
    return self;
}

#pragma mark 假设请求网络数据
- (void)requestData
{
    MVPModel *model = [[MVPModel alloc] init];
    model.iconName = @"04_MVP";
    model.title = @"MVP";
    
    self.mView.iconImgView.image = [UIImage imageNamed:model.iconName];
    self.mView.titleLabel.text = model.title;
}


#pragma mark -
#pragma mark - MVPViewDelegate

- (void)clickView
{
    NSLog(@"点击了 MVPView 视图");
}


#pragma mark -
#pragma mark - GET/SET

- (MVPView *)mView
{
    if (!_mView) {
        _mView = [[MVPView alloc] init];
        _mView.delegate = self;
        [self.currentVC.view addSubview:_mView];
    }
    return _mView;
}

@end
