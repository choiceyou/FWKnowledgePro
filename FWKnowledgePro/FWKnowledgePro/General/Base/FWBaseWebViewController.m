//
//  FWBaseWebViewController.m
//  FWKnowledgePro
//
//  Created by xfg on 2021/3/4.
//

#import "FWBaseWebViewController.h"
#import <WebKit/WebKit.h>
#import <Masonry/Masonry.h>
#import "FWTools.h"

@interface FWBaseWebViewController ()

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *navTitleStr;
@property (nonatomic, copy) NSString *htmlStr;

@end


@implementation FWBaseWebViewController

+ (instancetype)webVCWithContent:(NSString *)content title:(NSString *)title
{
    FWBaseWebViewController *webVC = [[FWBaseWebViewController alloc] init];
    
    webVC.htmlStr = [FWTools htmlWithStr:content];
    webVC.navTitleStr = title;
    return webVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.navTitleStr;
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self loadHtmlStr];
}

- (void)loadHtmlStr
{
    if (!_htmlStr) return;
    [self.webView loadHTMLString:self.htmlStr baseURL:nil];
}


#pragma mark -
#pragma mark - GET/SET

- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        [self.view addSubview:_webView];
    }
    return _webView;
}

@end
