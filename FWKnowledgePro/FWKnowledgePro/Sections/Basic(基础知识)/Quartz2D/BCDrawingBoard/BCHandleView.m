//
//  BCHandleView.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/4/8.
//

#import "BCHandleView.h"

@interface BCHandleView ()

/// 图片
@property (nonatomic, weak) UIImageView *imgView;

@end


@implementation BCHandleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
}


#pragma mark -
#pragma mark - 手势

#pragma mark 添加手势
- (void)addGesture
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGR:)];
    [self.imgView addGestureRecognizer:pan];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGR:)];
    [self.imgView addGestureRecognizer:pinch];
    
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGR:)];
    [self.imgView addGestureRecognizer:rotation];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGR:)];
    [self.imgView addGestureRecognizer:longPress];
}

#pragma mark 拖拽手势
- (void)panGR:(UIPanGestureRecognizer *)pan
{
    CGPoint currentP = [pan translationInView:self.imgView];
    self.imgView.transform = CGAffineTransformTranslate(self.imgView.transform, currentP.x, currentP.y);
    [pan setTranslation:CGPointZero inView:self.imgView];
}

#pragma mark 捏合手势
- (void)pinchGR:(UIPinchGestureRecognizer *)pich
{
    self.imgView.transform = CGAffineTransformScale(self.imgView.transform, pich.scale, pich.scale);
    pich.scale = 1.f;
}

#pragma mark 旋转手势
- (void)rotationGR:(UIRotationGestureRecognizer *)rotation
{
    self.imgView.transform = CGAffineTransformRotate(self.imgView.transform, rotation.rotation);
    rotation.rotation = 0.f;
}

#pragma mark 长按手势
- (void)longPressGR:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.2 animations:^{
            self.imgView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.imgView.alpha = 1.f;
            } completion:^(BOOL finished) {
                UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.f);
                [self.layer renderInContext:UIGraphicsGetCurrentContext()];
                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                !self.handleBlock ? : self.handleBlock(image);
            }];
        }];
    }
}


#pragma mark -
#pragma mark - GET/SET

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imgView.image = image;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        UIImageView *tmpView = [[UIImageView alloc] initWithFrame:self.bounds];
        tmpView.userInteractionEnabled = YES;
        tmpView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:tmpView];
        _imgView = tmpView;
        
        [self addGesture];
    }
    return _imgView;
}

@end
