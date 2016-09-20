//
//  RestPassWordViewController.m
//  WmjrApp
//
//  Created by huorui on 16/8/16.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "RestPassWordViewController.h"

@interface RestPassWordViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation RestPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改交易密码";
    _webView = [[UIWebView alloc]init];
    _webView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSURL *url = [NSURL URLWithString:_redirect_url];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    [_webView sizeToFit];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//
//    NSLog(@"我拦截的超链接请求:%@",request.URL);
//
//    return YES;
//
//}

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
