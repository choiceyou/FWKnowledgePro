//
//  RLTestViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/2/25.
//  只是个演示，这边需要注意销毁Observer

#import "RLTestViewController.h"
#import "RLTestViewCell.h"
#import <Masonry/Masonry.h>
#import "FWProxy.h"

static NSString *const kCellReuseIdentifier = @"kCellReuseIdentifier";
static CGFloat const kHSpace = 20.f;
static CGFloat const kVSpace = 20.f;
static NSInteger const kHnumber = 3;
#define kItemWidth ((CGRectGetWidth(UIScreen.mainScreen.bounds) - (kHnumber + 1) * kHSpace) / kHnumber)
#define kItemSize CGSizeMake(kItemWidth, kItemWidth)

typedef void(^RunLoopBlock)(void);

static int const kCurrntScreenShowMaxNum = 21;


@interface RLTestViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    CFRunLoopObserverRef _obsever;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<RunLoopBlock> *tasks;
@property (nonatomic, strong) NSTimer *timer;

@end


@implementation RLTestViewController

- (void)dealloc
{
    NSLog(@"%s", __func__);
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_obsever) {
        // 移除RunLoop监听
        CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), _obsever, kCFRunLoopCommonModes);
        // 释放
        CFRelease(_obsever);
        _obsever = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self addRunLoopObserver];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:[FWProxy proxyWithTarget:self] selector:@selector(timerMethod) userInfo:nil repeats:YES];
}


#pragma mark -
#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 200;
}

#pragma mark item行间距(横)
- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kHSpace;
}

#pragma mark item列间距(纵)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kVSpace;
}

#pragma mark 调整内容的边距(cell的上左下右缩进)
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, kHSpace, 0, kHSpace);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return kItemSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RLTestViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
    
#warning 需要复原问题，修改这边即可。。。
    
#if 0 // 优化之前
    [cell loadImg];
#endif
    
    
#if 1 // 优化之后
    __weak typeof(cell) weakCell = cell;
    [self addtask:^{
        [weakCell loadImg];
    }];
#endif
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(CGRectGetWidth(UIScreen.mainScreen.bounds), CGFLOAT_MIN);
}


#pragma mark -
#pragma mark - 优化处理

- (void)addRunLoopObserver
{
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)self,
        &CFRetain,
        &CFRelease,
        NULL
    };
    _obsever = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &callback2, &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), _obsever, kCFRunLoopDefaultMode);
    CFRelease(_obsever);
}

#pragma mark 我们在RunLoop的每次循环，都取出一个任务来执行
void callback2(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    RLTestViewController *currentVC = (__bridge RLTestViewController *)info;
    if (currentVC.tasks.count > 0) {
        RunLoopBlock rlBlock = currentVC.tasks.lastObject;
        rlBlock();
        [currentVC.tasks removeLastObject];
    }
}

- (void)addtask:(RunLoopBlock)task
{
    [self.tasks addObject:task];
    if (self.tasks.count > kCurrntScreenShowMaxNum) {
        [self.tasks removeObjectAtIndex:0];
    }
}

#pragma mark 此方法主要是利用定时器事件保持RunLoop处于循环中，不用做任何处理
- (void)timerMethod
{
    // 啥也不干
}


#pragma mark -
#pragma mark - GET/SET

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[RLTestViewCell class] forCellWithReuseIdentifier:kCellReuseIdentifier];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSMutableArray<RunLoopBlock> *)tasks
{
    if (!_tasks) {
        _tasks = @[].mutableCopy;
    }
    return _tasks;
}

@end
