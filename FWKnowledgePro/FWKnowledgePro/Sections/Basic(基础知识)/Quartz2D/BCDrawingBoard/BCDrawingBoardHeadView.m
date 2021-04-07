//
//  BCDrawingBoardHeadView.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/4/7.
//

#import "BCDrawingBoardHeadView.h"
#import <Masonry/Masonry.h>

@interface BCDrawingBoardHeadView ()

/// 工具条
@property (nonatomic, weak) UIToolbar *toolbar;

@end


@implementation BCDrawingBoardHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


#pragma mark -
#pragma mark - Pirvate

#pragma mark 清屏
- (void)clearAction
{
    !self.headBtnActionBlock ? : self.headBtnActionBlock(BCDBHeadActionTypeClear);
}

#pragma mark 撤销
- (void)revokeAction
{
    !self.headBtnActionBlock ? : self.headBtnActionBlock(BCDBHeadActionTypeRevoke);
}

#pragma mark 橡皮擦
- (void)eraserAction
{
    !self.headBtnActionBlock ? : self.headBtnActionBlock(BCDBHeadActionTypeEraser);
}

#pragma mark 选择照片
- (void)selectPhotoAction
{
    !self.headBtnActionBlock ? : self.headBtnActionBlock(BCDBHeadActionTypeSelectPhoto);
}

#pragma mark 保存
- (void)saveAction
{
    !self.headBtnActionBlock ? : self.headBtnActionBlock(BCDBHeadActionTypeSave);
}


#pragma mark -
#pragma mark - GET/SET

- (UIToolbar *)toolbar
{
    if (!_toolbar) {
        UIToolbar *tmpToolbar = [[UIToolbar alloc] init];
        [self addSubview:tmpToolbar];
        _toolbar = tmpToolbar;
        
        UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithTitle:@"清屏" style:UIBarButtonItemStyleDone target:self action:@selector(clearAction)];
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"撤销" style:UIBarButtonItemStyleDone target:self action:@selector(revokeAction)];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"橡皮擦" style:UIBarButtonItemStyleDone target:self action:@selector(eraserAction)];
        UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"图片" style:UIBarButtonItemStyleDone target:self action:@selector(selectPhotoAction)];
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *item4 = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveAction)];
        [_toolbar setItems:@[item0, item1, item2, item3, flexItem, item4]];
    }
    return _toolbar;
}

@end
