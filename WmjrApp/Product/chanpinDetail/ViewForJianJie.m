//
//  ViewForJianJie.m
//  WmjrApp
//
//  Created by horry on 16/9/7.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "ViewForJianJie.h"
#import "ProductModel.h"

@interface ViewForJianJie ()<UIWebViewDelegate>

@property (nonatomic, strong) ProductModel *productModel;

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ViewForJianJie

- (instancetype)initWithProductModel:(ProductModel *)productModel {
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _productModel = productModel;
        [self setUpLayout];
    }
    return self;
}

- (void)setUpLayout {
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    _webView = [[UIWebView alloc]init];
    _webView.scrollView.bounces = NO;
    _webView.delegate = self;
    [self addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(1);
    }];
    
    //    [_webView loadHTMLString:[_htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"] baseURL:nil];
//    [_webView loadHTMLString:_productModel.detail baseURL:nil];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_productModel.detail_url]]];
    [_webView sizeToFit];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [SVProgressHUD showWithStatus:@"加载中"];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
//    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
//    //    NSLog(@"我的高度:%.2f",fittingSize.height);
//    if (_transHight) {
//        _transHight(fittingSize.height);
//    }
    
    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:
                         @"document.body.scrollHeight"] integerValue];
    
//    NSLog(@"我的高度1:%ld",(long)fittingSize.height);
//    NSLog(@"我的高度2:%ld",(long)height);
    [_webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(height);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [SVProgressHUD dismiss];
    
}


@end
