//
//  FWBaseViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2019/11/23.
//

#import "FWBaseViewController.h"

@interface FWBaseViewController ()

@end


@implementation FWBaseViewController

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
