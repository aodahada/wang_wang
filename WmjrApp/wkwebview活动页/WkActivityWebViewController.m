//
//  WkActivityWebViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/6/28.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "WkActivityWebViewController.h"
#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>
#import "WKDelegateController.h"

@interface WkActivityWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,WKDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong)WKUserContentController *userContentController;
// 设置加载进度条
@property(nonatomic,strong) UIProgressView *  ProgressView;

@end

@implementation WkActivityWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置网页的配置文件
    WKWebViewConfiguration * Configuration = [[WKWebViewConfiguration alloc]init];
    _userContentController =[[WKUserContentController alloc]init];
    Configuration.userContentController = _userContentController;
    //注册方法
    WKDelegateController * delegateController = [[WKDelegateController alloc]init];
    delegateController.delegate = self;
    [_userContentController addScriptMessageHandler:self  name:@"openProductList"];
    //允许视频播放
    Configuration.allowsAirPlayForMediaPlayback = YES;
    // 允许在线播放
    Configuration.allowsInlineMediaPlayback = YES;
    // 允许可以与网页交互，选择视图
    Configuration.selectionGranularity = YES;
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, SCREEN_HEIGHT-2) configuration:Configuration];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    //http://7hg.oss-cn-shanghai.aliyuncs.com/test.html
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://7hg.oss-cn-shanghai.aliyuncs.com/test.html"]]];
    [_webView sizeToFit];
    
    
    self.ProgressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.ProgressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 2);
    // 设置进度条的色彩
    [self.ProgressView setTrackTintColor:[UIColor clearColor]];
    self.ProgressView.progressTintColor = [UIColor redColor];
    [self.view addSubview:self.ProgressView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"WkActivityWebViewController"];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"WkActivityWebViewController"];
}

- (void)dealloc {
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_userContentController removeScriptMessageHandlerForName:@"huorui"];
    
}

//开始加载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载的时候，让加载进度条显示
    self.ProgressView.hidden = NO;
    
}

//内容返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
    
    
}
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    // 内容加载失败时候调用
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
}
-(void)webViewDidClose:(WKWebView *)webView{
    
}
-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
    
}
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    // 获取js 里面的提示
    NSString *mes = message;
    NSLog(@"我活的懂得信息:%@",mes);
}
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    // js 信息的交流
    NSString *mes = message;
    NSLog(@"我活的懂得信息22222:%@",mes);
}
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    // 交互。可输入的文本。
}

#pragma mark - 解决href跳转_blank一个新页面在wkwebview里失效
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    WKScriptMessage *mes = message;
    NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    // 首先，判断是哪个路径
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        // 判断是哪个对象
        if (object == self.webView) {
            if (self.webView.estimatedProgress == 1.0) {
                //隐藏
                self.ProgressView.hidden = YES;
            }else{
                // 添加进度数值
                self.ProgressView.progress = self.webView.estimatedProgress;
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
