//
//  MVVMViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import "MVVMViewController.h"
#import "MVVMViewModel.h"

@interface MVVMViewController ()

@property (nonatomic, strong) MVVMViewModel *myViewModel;

@end


@implementation MVVMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.myViewModel = [[MVVMViewModel alloc] initWithVC:self];
}

@end
