//
//  BCGestureLockView.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/4/6.
//  相对比较简单，需要更多的完善

#import "BCGestureLockView.h"

@interface BCGestureLockView ()

/// 选中的按钮
@property (nonatomic, strong) NSMutableArray *selectedBtnArray;
/// 当前点
@property (nonatomic, assign) CGPoint currentPoint;

@end


@implementation BCGestureLockView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupBtns];
    }
    return self;
}

#pragma mark 创建按钮
- (void)setupBtns
{
    for (int i = 0; i < 9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        btn.tag = i;
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_node_selected"] forState:UIControlStateSelected];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger column = 3;
    CGSize btnSize = CGSizeMake(74.f, 74.f);
    CGFloat space = (CGRectGetWidth(self.frame) - column * btnSize.width) / (column + 1);
    CGFloat tmpX = 0;
    CGFloat tmpY = 0;
    
    for (int i = 0; i < self.subviews.count; i++) {
        UIButton *btn = self.subviews[i];
        tmpX = ((i % column) + 1) * space + (i % column) * btnSize.width;
        tmpY = ((i / column) + 1) * space + (i / column) * btnSize.height;
        btn.frame = CGRectMake(tmpX, tmpY, btnSize.width, btnSize.height);
    }
}


#pragma mark -
#pragma mark - 手势

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint currentP = [self obtainCurrentPoint:touches];
    UIButton *btn = [self btnRectContainsPoint:currentP];
    if (btn && !btn.isSelected) {
        btn.selected = YES;
        [self.selectedBtnArray addObject:btn];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.currentPoint = [self obtainCurrentPoint:touches];
    UIButton *btn = [self btnRectContainsPoint:self.currentPoint];
    if (btn && !btn.isSelected) {
        btn.selected = YES;
        [self.selectedBtnArray addObject:btn];
    }
    // 重绘
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSMutableString *tmpStr = [NSMutableString string];
    for (UIButton *btn in self.selectedBtnArray) {
        [tmpStr appendFormat:@"%ld", btn.tag];
        btn.selected = NO;
    }
    NSLog(@"当次选中的所有点：%@", tmpStr);
    [self.selectedBtnArray removeAllObjects];
    [self setNeedsDisplay];
}

#pragma mark 获取当前点
- (CGPoint)obtainCurrentPoint:(NSSet<UITouch *> *)touches
{
    UITouch *touch = [touches anyObject];
    return [touch locationInView:self];
}

#pragma mark 判断某个点是否在按钮上（不在按钮上时返回nil）
- (UIButton *)btnRectContainsPoint:(CGPoint)point
{
    for (UIButton *btn in self.subviews) {
        // 方案一（这个必须要是在同一个坐标系）
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return nil;
}


#pragma mark -
#pragma mark - 绘制

- (void)drawRect:(CGRect)rect
{
    if (self.selectedBtnArray.count > 0) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        for (int i = 0; i < self.selectedBtnArray.count; i++) {
            UIButton *btn = self.selectedBtnArray[i];
            if (i == 0) {
                [path moveToPoint:btn.center];
            } else {
                [path addLineToPoint:btn.center];
            }
        }
        [path addLineToPoint:self.currentPoint];
        
        [[UIColor whiteColor] set];
        path.lineWidth = 10.f;
        path.lineJoinStyle = kCGLineJoinRound;
        [path stroke];
    }
}


#pragma mark -
#pragma mark - GET/SET

- (NSMutableArray *)selectedBtnArray
{
    if (!_selectedBtnArray) {
        _selectedBtnArray = @[].mutableCopy;
    }
    return _selectedBtnArray;
}

@end
