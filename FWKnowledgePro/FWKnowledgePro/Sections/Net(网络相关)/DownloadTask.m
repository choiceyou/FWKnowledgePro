//
//  DownloadTask.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/2.
//

#import "DownloadTask.h"

static NSString *const kFileUrlStr = @"http://1251020758.vod2.myqcloud.com/8a96e57evodgzp1251020758/85304f0c5285890800850173495/FYlJ4Lp89AQA.mp4";

@interface DownloadTask () <NSURLSessionTaskDelegate>

/// 会话对象
@property (nonatomic, strong) NSURLSession *session;
/// 任务
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
/// 文件句柄
@property (nonatomic, strong) NSFileHandle *fileHandle;
/// 文件总大小
@property (nonatomic, assign) NSInteger totalSize;
/// 当前下载了文件的大小
@property (nonatomic, assign) NSInteger currentSize;
/// 文件存放路径
@property (nonatomic, copy) NSString *fullPath;

@end


@implementation DownloadTask

- (void)dealloc
{
    // 释放（也可以调用：finishTasksAndInvalidate）
    [self.session invalidateAndCancel];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark 开始任务
- (void)startTask
{
    [self.dataTask resume];
}

#pragma mark 暂停任务
- (void)suspendTask
{
    [self.dataTask suspend];
}

#pragma mark 取消任务
- (void)cancelTask
{
    [self.dataTask cancel];
    self.dataTask = nil;
}

#pragma mark 继续任务
- (void)resumeTask
{
    [self.dataTask resume];
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
    NSLog(@"%s", __func__);
    
    self.totalSize = response.expectedContentLength + self.currentSize;
    // 创建文件
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.fullPath]) {
        [[NSFileManager defaultManager] createFileAtPath:self.fullPath contents:nil attributes:nil];
    }
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.fullPath];
    // 移动指针
    [self.fileHandle seekToEndOfFile];
    
    completionHandler(NSURLSessionResponseAllow);
}

/// 接收到服务器返回的数据（TCP在传输层分段传输，因此此处可能会多次回调）
/// @param session 会话对象
/// @param dataTask 请求任务
/// @param data 本次下载的数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    NSLog(@"%s", __func__);
    // 写入数据到文件
    [self.fileHandle writeData:data];
    self.currentSize += data.length;
    // 计算文件的下载进度
    NSLog(@"文件下载进度：%f", 1.0 * self.currentSize / self.totalSize);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"%s", __func__);
    
    [self.fileHandle closeFile];
    self.fileHandle = nil;
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


#pragma mark -
#pragma mark - GET/SET

- (NSURLSession *)session
{
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.allowsCellularAccess = YES;
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

- (NSURLSessionDataTask *)dataTask
{
    if (!_dataTask) {
        // 1.确定URL
        NSURL *url = [NSURL URLWithString:kFileUrlStr];
        
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.fullPath error:nil];
        if (attributes && [attributes.allKeys containsObject:@"NSFileSize"]) {
            self.currentSize = [[attributes objectForKey:@"NSFileSize"] integerValue];
        }
        
        // 2.创建请求对象，告诉服务端请求哪一部分数据
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.currentSize];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        //    request.HTTPMethod = @"POST";
        //    request.timeoutInterval = 30.f;
        //
        //    request.HTTPBody = [[self dictToJsonStr:dict] dataUsingEncoding:NSUTF8StringEncoding];
        
        _dataTask = [self.session dataTaskWithRequest:request];
    }
    return _dataTask;
}

- (NSString *)fullPath
{
    if (!_fullPath) {
        _fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[[NSURL URLWithString:kFileUrlStr] lastPathComponent]];
    }
    return _fullPath;
}

@end
