//
//  LayeredViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/5.
//

#import "LayeredViewController.h"
#import "FWTestService.h"

@interface LayeredViewController ()

@end

@implementation LayeredViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [FWTestService loadData:@{@"username" : @"test"} success:^(NSDictionary * _Nonnull result) {
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

@end
