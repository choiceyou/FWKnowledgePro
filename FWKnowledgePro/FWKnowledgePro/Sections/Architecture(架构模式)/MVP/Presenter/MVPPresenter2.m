//
//  MVPPresenter2.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import "MVPPresenter2.h"
#import "MVPViewController.h"
#import "MVPView2.h"
#import "MVPModel.h"

@interface MVPPresenter2 ()

@property (nonatomic, weak) MVPViewController *currentVC;
@property (nonatomic, strong) MVPView2 *mView;

@end

@implementation MVPPresenter2

- (instancetype)initWithVC:(MVPViewController *)currentVC
{
    self = [super init];
    if (self) {
        self.currentVC = currentVC;
        
        [self.mView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.mView.superview);
            make.bottom.equalTo(self.mView.superview).offset(-50.f);
            make.height.mas_equalTo(30.f);
        }];
        
        [self requestData];
    }
    return self;
}

#pragma mark 假设请求网络数据
- (void)requestData
{
    MVPModel *model = [[MVPModel alloc] init];
    model.title = @"MVPPresenter2 测试";
    
    [self.mView setupTitle:model.title];
}


#pragma mark -
#pragma mark - GET/SET

- (MVPView2 *)mView
{
    if (!_mView) {
        _mView = [[MVPView2 alloc] init];
        [self.currentVC.view addSubview:_mView];
    }
    return _mView;
}

@end
