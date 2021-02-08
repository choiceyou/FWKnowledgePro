//
//  MVVMViewModel.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import "MVVMViewModel.h"
#import "MVVMViewController.h"
#import "MVVMView.h"
#import "MVVMModel.h"

@interface MVVMViewModel () <MVVMViewDelegate>

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, weak) MVVMViewController *currentVC;
@property (nonatomic, strong) MVVMView *mView;
@property (nonatomic, strong) MVVMModel *model;

@end


@implementation MVVMViewModel

- (instancetype)initWithVC:(MVVMViewController *)currentVC
{
    self = [super init];
    if (self) {
        self.currentVC = currentVC;
        
        [self.mView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.mView.superview);
            make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 220.f));
        }];
        
        [self requestData];
    }
    return self;
}

#pragma mark 模拟网络请求数据
- (void)requestData
{
    self.model = [[MVVMModel alloc] init];
    self.model.iconName = @"MVVM";
    self.model.title = @"MVVM -- 请点击测试";
    
    self.iconName = self.model.iconName;
    self.title = self.model.title;
}


#pragma mark -
#pragma mark - MVVMViewDelegate

- (void)clickView
{
    // 注意：这边就是双向绑定
    self.title = [NSString stringWithFormat:@"%@ -- %d", self.model.title, arc4random() % 100];
}


#pragma mark -
#pragma mark - GET/SET

- (MVVMView *)mView
{
    if (!_mView) {
        _mView = [[MVVMView alloc] initWithViewModel:self];
        _mView.delegate = self;
        [self.currentVC.view addSubview:_mView];
    }
    return _mView;
}

@end
