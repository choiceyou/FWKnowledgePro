//
//  MultifunctionTVControl.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/12/1.
//

#import "MultifunctionTVControl.h"

@interface MultifunctionTVControl ()

@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, assign) NSInteger channelIndex;

@end


@implementation MultifunctionTVControl

- (void)onOff
{
    if (self.isOn) {
        [self.tvSystem off];
    } else {
        [self.tvSystem on];
    }
    self.isOn = !self.isOn;
}

- (void)nextChannel
{
    self.channelIndex ++;
    [self.tvSystem setChannel:self.channelIndex];
}

- (void)preChannel
{
    self.channelIndex --;
    [self.tvSystem setChannel:self.channelIndex];
}

- (void)setChannel:(NSInteger)index
{
    self.channelIndex = index;
    [self.tvSystem setChannel:index];
}

@end
