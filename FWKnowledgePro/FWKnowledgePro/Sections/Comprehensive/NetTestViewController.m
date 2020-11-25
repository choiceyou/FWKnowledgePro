//
//  NetTestViewController.m
//  MSPro
//
//  Created by xfg on 2020/7/2.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "NetTestViewController.h"

@interface NetTestViewController ()

@end

@implementation NetTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Net";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test];
}

- (void)test
{
    NSURL *url = [NSURL URLWithString:
    @"http://127.0.0.1/AF_Hello_Get.php?name=jack&password=123"];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *firsttask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSURLSessionDataTask *secondtask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//    }];
}

@end
