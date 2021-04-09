//
//  BCDrawingBoardView.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/4/7.
//

#import "BCDrawingBoardView.h"
#import "BCBezierPath.h"

@interface BCDrawingBoardView ()

/// 存放绘制的路径（也有可能是选择的图片）
@property (nonatomic, strong) NSMutableArray *allPathArray;
/// 当前绘制路径
@property (nonatomic, strong) BCBezierPath *currentPath;
/// 当前线宽
@property (nonatomic, assign) CGFloat lineWidth;
/// 当前笔颜色
@property (nonatomic, strong) UIColor *lineColor;

@end


@implementation BCDrawingBoardView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [self addGestureRecognizer:pan];
        
        self.lineWidth = 1.f;
        self.lineColor = [UIColor redColor];
    }
    return self;
}


#pragma mark -
#pragma mark - 手势

- (void)panGesture:(UIPanGestureRecognizer *)pan
{
    CGPoint currentP = [pan locationInView:self];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.currentPath = [BCBezierPath bezierPath];
        self.currentPath.lineWidth = self.lineWidth;
        self.currentPath.color = self.lineColor;
        [self.currentPath moveToPoint:currentP];
        [self.allPathArray addObject:self.currentPath];
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        [self.currentPath addLineToPoint:currentP];
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        
    }
    
    // 重绘
    [self setNeedsDisplay];
}


#pragma mark -
#pragma mark - 绘制

- (void)drawRect:(CGRect)rect
{
    for (BCBezierPath *path in self.allPathArray) {
        if ([path isKindOfClass:[BCBezierPath class]]) {
            [path.color set];
            [path stroke];
        } else if ([path isKindOfClass:[UIImage class]]) {
            UIImage *image = (UIImage *)path;
            [image drawInRect:rect];
        }
    }
}


#pragma mark -
#pragma mark - Public

#pragma mark 头部的按钮的相关操作
- (void)headBtnActionWithType:(BCDBHeadActionType)type
{
    switch (type) {
        case BCDBHeadActionTypeClear:
            [self clearAction];
            break;
        case BCDBHeadActionTypeRevoke:
            [self revokeAction];
            break;
        case BCDBHeadActionTypeEraser:
            [self eraserAction];
            break;
        case BCDBHeadActionTypeSave:
            [self saveAction];
            break;
            
        default:
            break;
    }
}

#pragma mark 底部按钮改变
- (void)bottomBtnClicked:(UIColor *)color
{
    self.lineColor = color;
}

#pragma mark 底部滑竿滑动
- (void)bottomSliderChanged:(CGFloat)value
{
    self.lineWidth = value;
}


#pragma mark -
#pragma mark - Private

#pragma mark 清屏
- (void)clearAction
{
    [self.allPathArray removeAllObjects];
    [self setNeedsDisplay];
}

#pragma mark 撤销
- (void)revokeAction
{
    [self.allPathArray removeLastObject];
    [self setNeedsDisplay];
}

#pragma mark 橡皮擦
- (void)eraserAction
{
    self.lineColor = [UIColor whiteColor];
}

#pragma mark 选择照片
- (void)selectPhoto:(UIImage *)image
{
    [self.allPathArray addObject:image];
    [self setNeedsDisplay];
}

#pragma mark 保存
- (void)saveAction
{
    // 1、开启一个位图上下文
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.f);
    // 2、把画板的内容渲染到当前上下文中
    [self.layer drawInContext:UIGraphicsGetCurrentContext()];
    // 3、从当前上下文中取出一张图片
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    // 4、关闭上下文
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(newImg, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil ;
    if(error) {
        msg = @"保存图片失败";
    } else {
        msg = @"保存图片成功";
    }
    NSLog(@"保存图片结果：%@", msg);
}


#pragma mark -
#pragma mark - GET/SET

- (NSMutableArray *)allPathArray
{
    if (!_allPathArray) {
        _allPathArray = @[].mutableCopy;
    }
    return _allPathArray;
}

@end
