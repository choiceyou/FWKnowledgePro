//
//  ObserverTestViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2019/12/1.
//

#import "ObserverTestViewController.h"
#import "ObservedModel.h"

/**
 OC中实现了观察者模式的两个比较典型的：
 1、NSNotificationCenter;
 2、KVO；
 */


@interface ObserverTestViewController ()

@property (nonatomic, strong) ObservedModel *observedModel;
@property (nonatomic, strong) UILabel *showNumLabel;
@property (nonatomic, strong) UIButton *addBtn;

@end


@implementation ObserverTestViewController

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"num" context:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.showNumLabel.frame = CGRectMake(20.f, 120.f, CGRectGetWidth(self.view.frame) - 40.f, 40.f);
    self.addBtn.frame = CGRectMake(20.f, 200.f, CGRectGetWidth(self.view.frame) - 40.f, 40.f);
    
    /**
     self.observedModel 为被观察者
     self 为观察者
     NSKeyValueObservingOptionOld 以字典的形式提供 “初始对象数据”
     NSKeyValueObservingOptionNew 以字典的形式提供 “更新后新的数据”
     */
    [self.observedModel addObserver:self forKeyPath:@"num" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}


#pragma mark -
#pragma mark - 观察者

/// 只要object的keyPath属性发生变化，就会调用此回调方法，进行相应的处理：UI更
/// @param keyPath 属性名称
/// @param object 被观察者
/// @param change 变化前后的值都存储在 change 字典中
/// @param context 注册观察者时，context 传过来的值
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.observedModel && [keyPath isEqualToString:@"num"]) {
        self.showNumLabel.text = [NSString stringWithFormat:@"当前的num值为：%@", [change valueForKey:@"new"]];
        // 上文注册时，枚举为2个，因此可以提取change字典中的新、旧值的这两个方法
        NSLog(@"\noldnum:%@ newnum:%@", [change valueForKey:@"old"], [change valueForKey:@"new"]);
    }
}


#pragma mark -
#pragma mark - Action

- (void)btnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn == self.addBtn) {
        self.observedModel.num += 1;
    }
}


#pragma mark -
#pragma mark - GET/SET

- (ObservedModel *)observedModel
{
    if (!_observedModel) {
        _observedModel = [[ObservedModel alloc] init];
    }
    return _observedModel;
}

- (UILabel *)showNumLabel
{
    if (!_showNumLabel) {
        _showNumLabel = [[UILabel alloc] init];
        _showNumLabel.textColor = [UIColor blackColor];
        _showNumLabel.textAlignment = NSTextAlignmentCenter;
        _showNumLabel.text = @"当前的num值为：0";
        [self.view addSubview:_showNumLabel];
    }
    return _showNumLabel;
}

- (UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setTitle:@"+1" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addBtn setBackgroundColor:[UIColor lightGrayColor]];
        [_addBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addBtn];
    }
    return _addBtn;
}

@end
