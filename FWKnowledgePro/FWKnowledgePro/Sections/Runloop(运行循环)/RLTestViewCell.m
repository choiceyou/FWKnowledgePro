//
//  RLTestViewCell.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/2/25.
//

#import "RLTestViewCell.h"
#import <Masonry/Masonry.h>

static NSString *const kImageURL = @"https://seopic.699pic.com/photo/50111/6180.jpg_wh1200.jpg";

@interface RLTestViewCell ()

@property (nonatomic, strong) UIImageView *iconImgView;

@end


@implementation RLTestViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}


- (void)loadImg
{
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:kImageURL]];
    self.iconImgView.image = [UIImage imageWithData:imageData];
}


#pragma mark -
#pragma mark - GET/SET

- (UIImageView *)iconImgView
{
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImgView];
    }
    return _iconImgView;
}

@end
