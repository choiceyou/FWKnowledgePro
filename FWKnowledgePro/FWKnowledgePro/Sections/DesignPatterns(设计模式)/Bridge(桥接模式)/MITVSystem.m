//
//  MITVSystem.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/12/1.
//

#import "MITVSystem.h"

@implementation MITVSystem

- (void)off
{
    NSLog(@"MITV is off!");
}

- (void)on
{
    NSLog(@"MITV is on!");
}

- (void)setChannel:(NSInteger)index
{
    NSLog(@"MITV channel is %@", @(index));
}

- (void)setVolume:(NSInteger)index
{
    NSLog(@"MITV volume is %@", @(index));
}

@end
