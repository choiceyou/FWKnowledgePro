//
//  MVPViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import "MVPViewController.h"
#import "MVPPresenter1.h"
#import "MVPPresenter2.h"

@interface MVPViewController ()

@property (nonatomic, strong) MVPPresenter1 *presenter1;
@property (nonatomic, strong) MVPPresenter2 *presenter2;

@end


@implementation MVPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.presenter1 = [[MVPPresenter1 alloc] initWithVC:self];
    
    self.presenter2 = [[MVPPresenter2 alloc] initWithVC:self];
}

@end
