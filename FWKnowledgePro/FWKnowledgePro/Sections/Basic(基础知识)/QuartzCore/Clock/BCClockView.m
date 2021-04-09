//
//  BCClockView.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/4/9.
//

#import "BCClockView.h"
#import <Masonry/Masonry.h>

// 弧度转角度
#define kRadianToAngle(radian) ((radian) / 180.f * M_PI)


@interface BCClockView ()

/// 背景
@property (nonatomic, weak) UIImageView *bgImgView;
/// 秒针
@property (nonatomic, weak) CALayer *secondLayer;
/// 分针
@property (nonatomic, weak) CALayer *minuteLayer;
/// 时针
@property (nonatomic, weak) CALayer *hourLayer;

@end


@implementation BCClockView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConstraints];
        
        [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(setupTime) userInfo:nil repeats:YES];
        [self setupTime];
    }
    return self;
}

- (void)setupConstraints
{
    self.bgImgView.frame = self.bounds;
    
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor blackColor].CGColor;
    layer.bounds = CGRectMake(0, 0, 10.f, 10.f);
    layer.position = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
    layer.cornerRadius = 5.f;
    [self.layer addSublayer:layer];
}

#pragma mark 设置时间
- (void)setupTime
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    
    CGFloat hourRadian = components.hour * (360 / 12) + (360 / 12) * components.hour / 60;
    self.hourLayer.transform = CATransform3DMakeRotation(kRadianToAngle(hourRadian), 0, 0, 1);
    
    CGFloat minuteRadian = components.minute * (360 / 60);
    self.minuteLayer.transform = CATransform3DMakeRotation(kRadianToAngle(minuteRadian), 0, 0, 1);
    
    CGFloat secondRadian = components.second * (360 / 60);
    self.secondLayer.transform = CATransform3DMakeRotation(kRadianToAngle(secondRadian), 0, 0, 1);
}


#pragma mark -
#pragma mark - GET/SET

- (UIImageView *)bgImgView
{
    if (!_bgImgView) {
        UIImageView *tmpView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bc_clock_bg"]];
        [self addSubview:tmpView];
        _bgImgView = tmpView;
    }
    return _bgImgView;
}

- (CALayer *)secondLayer
{
    if (!_secondLayer) {
        CALayer *tmpLayer = [CALayer layer];
        tmpLayer.backgroundColor = [UIColor redColor].CGColor;
        tmpLayer.frame = CGRectMake(0, 0, 2, CGRectGetHeight(self.frame)/2 - 20.f);
        tmpLayer.anchorPoint = CGPointMake(0.5, 1);
        tmpLayer.position = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
        [self.layer addSublayer:tmpLayer];
        _secondLayer = tmpLayer;
    }
    return _secondLayer;
}

- (CALayer *)minuteLayer
{
    if (!_minuteLayer) {
        CALayer *tmpLayer = [CALayer layer];
        tmpLayer.backgroundColor = [UIColor blackColor].CGColor;
        tmpLayer.frame = CGRectMake(0, 0, 4.f, CGRectGetHeight(self.frame)/2 - 30.f);
        tmpLayer.cornerRadius = 2.f;
        tmpLayer.anchorPoint = CGPointMake(0.5, 1);
        tmpLayer.position = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
        [self.layer addSublayer:tmpLayer];
        _minuteLayer = tmpLayer;
    }
    return _minuteLayer;
}

- (CALayer *)hourLayer
{
    if (!_hourLayer) {
        CALayer *tmpLayer = [CALayer layer];
        tmpLayer.backgroundColor = [UIColor blackColor].CGColor;
        tmpLayer.frame = CGRectMake(0, 0, 4.f, CGRectGetHeight(self.frame)/2 - 40.f);
        tmpLayer.cornerRadius = 2.f;
        tmpLayer.anchorPoint = CGPointMake(0.5, 1);
        tmpLayer.position = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
        [self.layer addSublayer:tmpLayer];
        _hourLayer = tmpLayer;
    }
    return _hourLayer;
}

@end
