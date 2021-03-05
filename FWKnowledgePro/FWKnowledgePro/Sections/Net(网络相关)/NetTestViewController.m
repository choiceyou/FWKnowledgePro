//
//  NetTestViewController.m
//  MSPro
//
//  Created by xfg on 2020/7/2.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "NetTestViewController.h"
#import "DownloadTask.h"

@interface NetTestViewController () <NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

/// 接收网络请求信息
@property (nonatomic, strong) NSMutableData *fileData;
/// 下载任务
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
/// 会话对象
@property (nonatomic, strong) NSURLSession *session;
/// 记录上一次取消下载时的数据
@property (nonatomic, strong) NSData *resumeData;

/// 断点续传
@property (nonatomic, strong) DownloadTask *dContinuation;

@end


@implementation NetTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"网络实践";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *tmpArray = @[
        @"开始下载任务",
        @"暂停下载任务",
        @"取消下载任务",
        @"继续下载任务",
    ].mutableCopy;
    
    [self.titleArray addObjectsFromArray:tmpArray];
}

#pragma mark 开始任务
- (void)startTask
{
    [self netDownloadMethod:@{@"username" : @"test"}];
}

#pragma mark 暂停任务
- (void)suspendTask
{
    [self.downloadTask suspend];
}

#pragma mark 取消任务
- (void)cancelTask
{
    // 不能恢复下载
    //    [self.downloadTask cancel];
    
    // 可以恢复下载
    __weak typeof(self) weakSelf = self;
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.resumeData = resumeData;
    }];
}

#pragma mark 继续任务
- (void)resumeTask
{
    if (self.resumeData) {
        self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
    }
    
    [self.downloadTask resume];
}


#pragma mark -
#pragma mark - 网络请求方法

#pragma mark GET方法
- (void)netGetMethod
{
    // 1.确定URL
    NSURL *url = [NSURL URLWithString:@"https://api.xxx.com/login?username=123&pwd=123"];
    // 2.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 30.f;
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.allowsCellularAccess = YES;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
    [dataTask resume];
}

#pragma mark POST方法
- (void)netPostMethod:(NSDictionary *)dict
{
    if (!dict) {
        return;
    }
    // 1.确定URL
    NSURL *url = [NSURL URLWithString:@"https://api.xxx.com"];
    // 2.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 30.f;
    
    request.HTTPBody = [[self dictToJsonStr:dict] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"identifier"];
    config.allowsCellularAccess = YES;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
}

#pragma mark 下载方法
- (void)netDownloadMethod:(NSDictionary *)dict
{
    if (!dict) {
        return;
    }
    // 1.确定URL
    NSURL *url = [NSURL URLWithString:@"https://api.xxx.com"];
    // 2.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 30.f;
    
    request.HTTPBody = [[self dictToJsonStr:dict] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"identifier"];
    config.allowsCellularAccess = YES;
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // 方法一：该方法内部已经实现了边接受数据边保存到沙盒(tmp)的操作
    //    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //        // 创建文件保存路径
    //        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
    //        // 剪切文件
    //        [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL URLWithString:fullPath] error:nil];
    //    }];
    
    // 方法二
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithRequest:request];
    [downloadTask resume];
    
    self.downloadTask = downloadTask;
}


#pragma mark -
#pragma mark - NSURLSessionDataDelegate

/// 接收到服务器的响应(默认会取消请求)
/// @param session 会话对象
/// @param dataTask 请求任务
/// @param response 响应头信息
/// @param completionHandler 回调（需要回传回去）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
}

/// 接收到服务器返回的数据（TCP在传输层分段传输，因此此处可能会多次回调）
/// @param session 会话对象
/// @param dataTask 请求任务
/// @param data 本次下载的数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    // 拼接数据
    [self.fileData appendData:data];
}

/// 请求结束或者失败的时候调用
/// @param session 会话对象
/// @param dataTask 请求任务
/// @param proposedResponse 包含 NSURLResponse 以及它对应的缓存中的 NSData 的类
/// @param completionHandler 回调
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler
{
    // 解析数据
}


#pragma mark -
#pragma mark - NSURLSessionDownloadDelegate

/// 写数据
/// @param session 会话对象
/// @param downloadTask 下载任务
/// @param bytesWritten 本次写入的数据大小
/// @param totalBytesWritten 下载的数据总大小
/// @param totalBytesExpectedToWrite 文件的总大小
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
                                           didWriteData:(int64_t)bytesWritten
                                      totalBytesWritten:(int64_t)totalBytesWritten
                              totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    // 1.获得文件的下载进度
    NSLog(@"%f", 1.0 * totalBytesWritten / totalBytesExpectedToWrite);
}

/// 当恢复下载时调用该方法
/// @param session 会话对象
/// @param downloadTask 下载任务
/// @param fileOffset 继续下载的起始位置
/// @param expectedTotalBytes 文件的总大小
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
                                      didResumeAtOffset:(int64_t)fileOffset
                                     expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

/// 下载完成
/// @param session 会话对象
/// @param downloadTask 下载任务
/// @param location 文件的临时存储路径
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    // 创建文件保存路径
    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    // 剪切文件
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL URLWithString:fullPath] error:nil];
}

/// 请求结束
/// @param session 会话对象
/// @param task 下载任务
/// @param error 错误信息
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
}


#pragma mark -
#pragma mark - UITableViewDataSource/UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            [self.dContinuation startTask];
        }
            break;
        case 1: {
            [self.dContinuation suspendTask];
        }
            break;
        case 2: {
            [self.dContinuation cancelTask];
        }
            break;
        case 3: {
            [self.dContinuation resumeTask];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark - Other

- (NSString *)dictToJsonStr:(NSDictionary *)dict
{
    NSString *jsonStr;
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (data) {
        jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return jsonStr;
}

- (NSMutableData *)fileData
{
    if (!_fileData) {
        _fileData = [NSMutableData data];
    }
    return _fileData;
}

- (DownloadTask *)dContinuation
{
    if (!_dContinuation) {
        _dContinuation = [[DownloadTask alloc] init];
    }
    return _dContinuation;
}

@end
