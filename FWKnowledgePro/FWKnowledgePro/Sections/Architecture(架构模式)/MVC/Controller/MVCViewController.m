//
//  MVCViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import "MVCViewController.h"
#import "MVCView.h"

@interface MVCViewController ()

@property (nonatomic, strong) MVCView *mView;

@end


@implementation MVCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.mView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 240.f));
    }];
    
    [self requestData];
}

#pragma mark 假设请求网络数据
- (void)requestData
{
    MVCModel *model = [[MVCModel alloc] init];
    model.iconName = @"MVC_变种";
    model.title = @"MVC-变种";
    
    [self.mView setupView:model];
}


#pragma mark -
#pragma mark - GET/SET

- (MVCView *)mView
{
    if (!_mView) {
        _mView = [[MVCView alloc] init];
        [self.view addSubview:_mView];
    }
    return _mView;
}

@end
