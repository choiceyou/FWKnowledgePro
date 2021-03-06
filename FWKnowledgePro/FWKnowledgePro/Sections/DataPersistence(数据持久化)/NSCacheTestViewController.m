//
//  NSCacheTestViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/3/6.
//

/**
 1、NSCache是苹果官方提供的缓存类，具体使用和NSDictionary类似，在AFN和SDWebImage框架中被使用来管理缓存；
 2、苹果官方解释NSCache在系统内存很低时，会自动释放对象；
 3、NSCache是线程安全的，在多线程操作中，不需要对NSCache加锁；
 4、NSCache的Key只是对对象进行Strong引用，不是拷贝；
 */

#import "NSCacheTestViewController.h"

@interface NSCacheTestViewController () <NSCacheDelegate>

/// NSCache
@property (nonatomic, strong) NSCache *cache;

@end


@implementation NSCacheTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"NSCache";
    
    NSMutableArray *tmpArray = @[
        @"存入数据",
        @"取出数据",
        @"删除数据"
    ].mutableCopy;
    
    [self.titleArray addObjectsFromArray:tmpArray];
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            // 将这个放外面可以验证：NSCache的Key只是对对象进行Strong引用，不是拷贝
            // NSString *path = [[NSBundle mainBundle] pathForResource:@"Info.plist" ofType:nil];
            // NSData *data = [NSData dataWithContentsOfFile:path];
            
            for (int i = 0; i < 10; i++) {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"Info.plist" ofType:nil];
                NSData *data = [NSData dataWithContentsOfFile:path];
                // 假设我每一条数据就是1个成本
                [self.cache setObject:data forKey:@(i) cost:1];
                NSLog(@"存入数据：%d", i);
            }
        }
            break;
        case 1: {
            for (int i = 0; i < 10; i++) {
                NSData *data = [self.cache objectForKey:@(i)];
                if (data) {
                    NSLog(@"取出数据：%d", i);
                }
            }
        }
            break;
        case 2: {
            [self.cache removeAllObjects];
            NSLog(@"清空所有数据");
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark - 代理

- (void)cache:(NSCache *)cache willEvictObject:(id)obj
{
    NSLog(@"将要被回收的数据：%p", obj);
}


#pragma mark -
#pragma mark - GET/SET

- (NSCache *)cache
{
    if (!_cache) {
        _cache = [[NSCache alloc] init];
        // 假如我们设置总成本数量是5，如果发现存入的数据成本超过总成本，那么会自动回收之前的对象
        _cache.totalCostLimit = 5;
        // 可以使用代理来观察被回收的对象
        _cache.delegate = self;
    }
    return _cache;
}

@end
