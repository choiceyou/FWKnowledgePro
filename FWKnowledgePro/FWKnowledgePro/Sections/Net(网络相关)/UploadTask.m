//
//  UploadTask.m
//  FWKnowledgePro
//
//  Created by xfg on 2020/2/3.
//

/**
 1、设置请求头：multipart/from-data;boundary=--WebKitFormBoundaryjv0UfA04ED44AhWx；
 2、按照固定格式来拼接请求体的数据；
 （1）文件参数：
    --分隔符
    Content-Disposition: from-data; name="file"; filename="Snip20160225_341.png"
    Content-Type: image/png (MIMEType:大类型/小类型)
    空行
    文件参数
 （2）非文件参数：
    --分隔符
    Content-Disposition: from-data; name="username"
    空行
    123456
 （3）结尾标识：
    --分隔符--
 */


#import "UploadTask.h"

// 文件名称
static NSString *const kFileName = @"tcp_1.png";
// 分隔符（这个随便定义）
static NSString *const kBoundary = @"--WebKitFormBoundaryjv0UfA04ED44AhWx";
// 换行
#define kNewLine [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]


@interface UploadTask () <NSURLSessionDataDelegate>

/// 会话对象
@property (nonatomic, strong) NSURLSession *session;
/// 上传任务
@property (nonatomic, strong) NSURLSessionUploadTask *uploadTask;

@end


@implementation UploadTask

#pragma mark 开始任务
- (void)startTask
{
    [self.uploadTask resume];
}

#pragma mark 暂停任务
- (void)suspendTask
{
    [self.uploadTask suspend];
}

#pragma mark 取消任务
- (void)cancelTask
{
    [self.uploadTask cancel];
    self.uploadTask = nil;
}

#pragma mark 继续任务
- (void)resumeTask
{
    [self.uploadTask resume];
}


#pragma mark -
#pragma mark - NSURLSessionDataDelegate

/// 上传进度回调
/// @param session 会话对象
/// @param task 上传任务
/// @param bytesSent 本次上传的数据大小
/// @param totalBytesSent 总共已经上传完的数据大小
/// @param totalBytesExpectedToSend 文件的总大小
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    NSLog(@"%s", __func__);
    
    NSLog(@"%f", 1.0 * totalBytesSent / totalBytesExpectedToSend);
}


#pragma mark -
#pragma mark - Other

- (NSMutableData *)getFileData
{
    // 3.拼接请求体数据
    NSMutableData *fileData = [NSMutableData data];
    // 3.1 拼接文件参数
    /**
     --分隔符
     Content-Disposition: from-data; name="file"; filename="Snip20160225_341.png"
     Content-Type: image/png (MIMEType:大类型/小类型)
     空行
     文件参数
     */
    [fileData appendData:[[NSString stringWithFormat:@"--%@", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:kNewLine];
    [fileData appendData:[[NSString stringWithFormat:@"Content-Disposition: from-data; name=\"file\"; filename=\"%@\"", kFileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:kNewLine];
    [fileData appendData:[@"Content-Type: image/png" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:kNewLine];
    [fileData appendData:kNewLine];
    
    UIImage *image = [UIImage imageNamed:kFileName];
    [fileData appendData:UIImagePNGRepresentation(image)];
    [fileData appendData:kNewLine];
    
    // 3.2 拼接非文件参数
    /**
     --分隔符
     Content-Disposition: from-data; name="username"
     空行
     123456
     */
    [fileData appendData:[[NSString stringWithFormat:@"--%@", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:kNewLine];
    [fileData appendData:[[NSString stringWithFormat:@"Content-Disposition: from-data; name=\"%@\"; ", @"test"] dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:kNewLine];
    [fileData appendData:kNewLine];
    [fileData appendData:[@"123456" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:kNewLine];
    
    // 3.3 拼接结尾标识符
    /**
     --分隔符--
     */
    [fileData appendData:[[NSString stringWithFormat:@"--%@--", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return fileData;
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

- (NSURLSessionUploadTask *)uploadTask
{
    if (!_uploadTask) {
        // 1.确定URL
        NSURL *url = [NSURL URLWithString:@"http://api.xxx.com"];
        // 2.创建请求对象，告诉服务端请求哪一部分数据
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"POST";
        [request setValue:[NSString stringWithFormat:@"multipart/from-data;boundary=%@", kBoundary] forHTTPHeaderField:@"Content-Type"];
        // 3.拼接请求体数据
        NSMutableData *fileData = [self getFileData];
        
        _uploadTask = [self.session uploadTaskWithRequest:request fromData:fileData];
    }
    return _uploadTask;
}

@end
