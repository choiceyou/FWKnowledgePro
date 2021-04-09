//
//  BCClockViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/4/9.
//

#import "BCClockViewController.h"
#import "BCClockView.h"

@interface BCClockViewController ()

/// 时钟视图
@property (nonatomic, weak) BCClockView *clockView;

@end

@implementation BCClockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"时钟";
    
    self.clockView.hidden = NO;
}


#pragma mark -
#pragma mark - GET/SET

- (BCClockView *)clockView
{
    if (!_clockView) {
        CGFloat tmpWH = 200.f;
        BCClockView *tmpView = [[BCClockView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - tmpWH) / 2, ([UIScreen mainScreen].bounds.size.height - tmpWH) / 2, tmpWH, tmpWH)];
        [self.view addSubview:tmpView];
        _clockView = tmpView;
    }
    return _clockView;
}

@end
