//
//  BCDrawingBoardViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/4/7.
//

#import "BCDrawingBoardViewController.h"
#import "BCDrawingBoardHeadView.h"
#import <Masonry/Masonry.h>
#import "BCDrawingBoardBottomView.h"
#import "BCDrawingBoardView.h"
#import "BCHandleView.h"

// 状态栏高度
#define kStatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height)
// 导航栏高度
#define kNavigationBarHeight 44.0


@interface BCDrawingBoardViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/// 头部视图
@property (nonatomic, weak) BCDrawingBoardHeadView *dBoardHeadView;
/// 底部视图
@property (nonatomic, weak) BCDrawingBoardBottomView *dBoardBottomView;
/// 画图视图
@property (nonatomic, weak) BCDrawingBoardView *drawingBoardView;
/// 处理从相册中选择的图片
@property (nonatomic, weak) BCHandleView *handleView;

@end


@implementation BCDrawingBoardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"画板";
    
    [self setupConstraints];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)setupConstraints
{
    [self.dBoardHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kStatusBarHeight + kNavigationBarHeight);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44.f);
    }];
    
    [self.drawingBoardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.dBoardHeadView.mas_bottom);
        make.bottom.equalTo(self.dBoardBottomView.mas_top);
    }];
    
    [self.dBoardBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(120.f);
    }];
}


#pragma mark -
#pragma mark - UINavigationControllerDelegate/UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.handleView.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark - GET/SET

- (BCDrawingBoardHeadView *)dBoardHeadView
{
    if (!_dBoardHeadView) {
        BCDrawingBoardHeadView *tmpView = [[BCDrawingBoardHeadView alloc] init];
        [self.view addSubview:tmpView];
        _dBoardHeadView = tmpView;
        
        __weak typeof(self) weakSelf = self;
        _dBoardHeadView.headBtnActionBlock = ^(BCDBHeadActionType type) {
            if (type == BCDBHeadActionTypeSelectPhoto) {
                UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
                pickerVC.delegate = self;
                pickerVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                pickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
                if (@available(iOS 11, *)) {
                    UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
                }
                [weakSelf presentViewController:pickerVC animated:YES completion:nil];
            } else {
                [weakSelf.drawingBoardView headBtnActionWithType:type];
            }
        };
    }
    return _dBoardHeadView;
}

- (BCDrawingBoardView *)drawingBoardView
{
    if (!_drawingBoardView) {
        BCDrawingBoardView *tmpView = [[BCDrawingBoardView alloc] init];
        [self.view addSubview:tmpView];
        _drawingBoardView = tmpView;
    }
    return _drawingBoardView;
}

- (BCDrawingBoardBottomView *)dBoardBottomView
{
    if (!_dBoardBottomView) {
        BCDrawingBoardBottomView *tmpView = [[BCDrawingBoardBottomView alloc] init];
        [self.view addSubview:tmpView];
        _dBoardBottomView = tmpView;
        
        __weak typeof(self) weakSelf = self;
        _dBoardBottomView.btnClickedBlock = ^(UIColor * _Nonnull color) {
            [weakSelf.drawingBoardView bottomBtnClicked:color];
        };
        
        _dBoardBottomView.sliderChangedBlock = ^(CGFloat value) {
            [weakSelf.drawingBoardView bottomSliderChanged:value];
        };
    }
    return _dBoardBottomView;
}

- (BCHandleView *)handleView
{
    if (!_handleView) {
        BCHandleView *tmpView = [[BCHandleView alloc] initWithFrame:self.drawingBoardView.frame];
        [self.view addSubview:tmpView];
        _handleView = tmpView;
        
        __weak typeof(self) weakSelf = self;
        _handleView.handleBlock = ^(UIImage * _Nonnull image) {
            [weakSelf.drawingBoardView selectPhoto:image];
            [weakSelf.handleView removeFromSuperview];
        };
    }
    return _handleView;
}

@end
