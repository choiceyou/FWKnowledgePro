//
//  HUAWEITVSystem.m
//  FWKnowledgePro
//
//  Created by xfg on 2019/12/1.
//

#import "HUAWEITVSystem.h"

@implementation HUAWEITVSystem

- (void)off
{
    NSLog(@"HUAWEITV is off!");
}

- (void)on
{
    NSLog(@"HUAWEITV is on!");
}

- (void)setChannel:(NSInteger)index
{
    NSLog(@"HUAWEITV channel is %@", @(index));
}

- (void)setVolume:(NSInteger)index
{
    NSLog(@"HUAWEITV volume is %@", @(index));
}

@end
