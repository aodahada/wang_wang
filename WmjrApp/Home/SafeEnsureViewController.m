//
//  SafeEnsureViewController.m
//  WmjrApp
//
//  Created by horry on 2016/11/16.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "SafeEnsureViewController.h"
#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>

#define selecColor [UIColor colorWithRed:29/255.0 green:98/255.0 blue:166/255.0 alpha:1.0]
#define unSelectColor [UIColor colorWithRed:165/255.0 green:165/255.0 blue:165/255.0 alpha:1.0]

@interface SafeEnsureViewController ()<UIScrollViewDelegate,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) UIButton *buttonForWangma;//旺马
@property (nonatomic, strong) UIButton *buttonForSina;//新浪

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;
@property (nonatomic, assign) BOOL isBottom;//有没有滑动到底部
@property (nonatomic, assign) NSInteger yDistance;//Y的距离

@property (nonatomic, strong) WKWebView *webView;
// 设置加载进度条
@property(nonatomic,strong) UIProgressView *  ProgressView;

@property (nonatomic, strong)UILabel *lineLeft;
@property (nonatomic, strong)UILabel *lineRight;

@end

@implementation SafeEnsureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isBottom = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *viewForNav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, RESIZE_UI(200), RESIZE_UI(40))];
    viewForNav.backgroundColor = NAVBARCOLOR;
    [self.view addSubview:viewForNav];
    [viewForNav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(-50);
        make.width.mas_offset(RESIZE_UI(200));
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_offset(RESIZE_UI(40));
    }];
    
    _buttonForWangma = [[UIButton alloc]init];
    [_buttonForWangma setTitle:@"旺马平台" forState:UIControlStateNormal];
    [_buttonForWangma setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonForWangma.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(17)]];
    [_buttonForWangma addTarget:self action:@selector(buttonActionMethod:) forControlEvents:UIControlEventTouchUpInside];
    [viewForNav addSubview:_buttonForWangma];
    [_buttonForWangma mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(100);
        make.top.equalTo(viewForNav.mas_top);
        make.bottom.equalTo(viewForNav.mas_bottom);
        make.left.equalTo(viewForNav.mas_left);
    }];
    
    _lineLeft = [[UILabel alloc]init];
    _lineLeft.backgroundColor = [UIColor whiteColor];
    [viewForNav addSubview:_lineLeft];
    [_lineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(viewForNav.mas_bottom);
        make.left.equalTo(_buttonForWangma.mas_left).with.offset(RESIZE_UI(10));
        make.right.equalTo(_buttonForWangma.mas_right).with.offset(-RESIZE_UI(10));
        make.height.mas_offset(RESIZE_UI(3));
    }];
    
    _buttonForSina = [[UIButton alloc]init];
    _buttonForSina = [[UIButton alloc]init];
    [_buttonForSina setTitle:@"新浪平台" forState:UIControlStateNormal];
    [_buttonForSina setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonForSina addTarget:self action:@selector(buttonActionMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonForSina.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(17)]];
    [viewForNav addSubview:_buttonForSina];
    [_buttonForSina mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_buttonForWangma.mas_width);
        make.top.equalTo(viewForNav.mas_top);
        make.bottom.equalTo(viewForNav.mas_bottom);
        make.right.equalTo(viewForNav.mas_right);
    }];
    
    _lineRight = [[UILabel alloc]init];
    _lineRight.hidden = YES;
    _lineRight.backgroundColor = [UIColor whiteColor];
    [viewForNav addSubview:_lineRight];
    [_lineRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(viewForNav.mas_bottom);
        make.left.equalTo(_buttonForSina.mas_left).with.offset(RESIZE_UI(10));
        make.right.equalTo(_buttonForSina.mas_right).with.offset(-RESIZE_UI(10));
        make.height.mas_offset(RESIZE_UI(3));
    }];
    
    self.navigationItem.titleView = viewForNav;
    
    [self wangmaLayoutMethod];
    
}

- (void)buttonActionMethod:(UIButton *)btn {
    if (btn == _buttonForWangma) {
        _lineLeft.hidden = NO;
        _lineRight.hidden = YES;
        [self.ProgressView removeFromSuperview];
        self.ProgressView = nil;
        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
        [self.webView removeFromSuperview];
        self.webView = nil;
        [self wangmaLayoutMethod];
    } else {
        _lineLeft.hidden = YES;
        _lineRight.hidden = NO;
        [_mainScrollView removeFromSuperview];
        _mainScrollView = nil;
        [_mainView removeFromSuperview];
        _mainView = nil;
        [_imageView1 removeFromSuperview];
        _imageView1 = nil;
        [_imageView2 removeFromSuperview];
        _imageView2 = nil;
        [_imageView3 removeFromSuperview];
        _imageView3 = nil;
        [self sinaLayoutMethod];
        
        
    }
}

#pragma mark - 旺马界面
- (void)wangmaLayoutMethod {
    _mainScrollView = [[UIScrollView alloc]init];
    _mainScrollView.backgroundColor = [UIColor orangeColor];
    _mainScrollView.delegate = self;
    _mainScrollView.bounces = NO;
    [self.view addSubview:_mainScrollView];
    [_mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _mainView = [[UIView alloc]init];
    [_mainScrollView addSubview:_mainView];
    [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_mainScrollView);
        make.width.equalTo(self.view.mas_width);
    }];
    
    _imageView1 = [[UIImageView alloc]init];
    _imageView1.image = [UIImage imageNamed:@"image_wangma1"];
    [_mainView addSubview:_imageView1];
    [_imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainView.mas_top);
        make.left.equalTo(_mainView.mas_left);
        make.right.equalTo(_mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(667));
    }];
    
    _imageView2 = [[UIImageView alloc]init];
    _imageView2.image = [UIImage imageNamed:@"image_wangma2"];
    [_mainView addSubview:_imageView2];
    [_imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView1.mas_bottom);
        make.left.equalTo(_mainView.mas_left);
        make.right.equalTo(_mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(667));
    }];
    
    _imageView3 = [[UIImageView alloc]init];
    _imageView3.image = [UIImage imageNamed:@"image_wangma3"];
    [_mainView addSubview:_imageView3];
    [_imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView2.mas_bottom);
        make.left.equalTo(_mainView.mas_left);
        make.right.equalTo(_mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(614));
        make.bottom.equalTo(_mainView.mas_bottom).with.offset(49);
    }];
}

#pragma mark - 新浪界面
- (void)sinaLayoutMethod{
    self.ProgressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.ProgressView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 2);
    // 设置进度条的色彩
    [self.ProgressView setTrackTintColor:[UIColor clearColor]];
    self.ProgressView.progressTintColor = RGBA(29, 98, 166, 1.0);
    [self.view addSubview:self.ProgressView];
    //    }
    
    
    //设置网页的配置文件
    WKWebViewConfiguration * Configuration = [[WKWebViewConfiguration alloc]init];
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
        make.top.equalTo(self.view.mas_top).with.offset(2);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://pay.sina.com.cn/zjtg/#thirdPage"]]];
    [_webView sizeToFit];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat y = scrollView.contentOffset.y;
//    if (y>RESIZE_UI(667)+RESIZE_UI(667)-RESIZE_UI(1948-1345)) {
//        _isBottom = YES;
//        _yDistance = (RESIZE_UI(667)+RESIZE_UI(667)+RESIZE_UI(614)-RESIZE_UI(1948-1345))-y;
//    } else {
//        _isBottom = NO;
//    }
//}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"SafeEnsureViewController"];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SafeEnsureViewController"];
}

- (void)dealloc {
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
}

//开始加载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载的时候，让加载进度条显示
    self.ProgressView.hidden = NO;
    //    NSLog(@"开始加载的时候调用。。");
    //    NSLog(@"%lf",   self.webView.estimatedProgress);
    
}

//内容返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    //    NSLog(@"当内容返回的时候调用");
    //    NSLog(@"%lf",   self.webView.estimatedProgress);
    
}
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    //    NSLog(@"这是服务器请求跳转的时候调用");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //    NSLog(@"加载完成");
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    // 内容加载失败时候调用
    //    NSLog(@"这是加载失败时候调用");
    //    NSLog(@"错误信息：%@",error);
}
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    //    NSLog(@"通过导航跳转失败的时候调用");
}
-(void)webViewDidClose:(WKWebView *)webView{
    //    NSLog(@"网页关闭的时候调用");
}
-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    //    NSLog(@"%lf",   webView.estimatedProgress);
    
}
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    // 获取js 里面的提示
}
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    // js 信息的交流
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
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    // 首先，判断是哪个路径
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        // 判断是哪个对象
        if (object == self.webView) {
            //            NSLog(@"进度信息：%lf",self.webView.estimatedProgress);
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
