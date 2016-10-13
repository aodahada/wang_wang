//
//  WebViewForPayViewController.m
//  WmjrApp
//
//  Created by huorui on 16/8/15.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "WebViewForPayViewController.h"
#import "MyselfManageFinanceController.h"
#import "MyselfTransactionController.h"
#import "HRBuyViewController.h"

@interface WebViewForPayViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WebViewForPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"支付界面";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _webView = [[UIWebView alloc]init];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [_webView loadHTMLString:_htmlString baseURL:nil];
    [_webView sizeToFit];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"我拦截的超链接请求:%@",request.URL);
    
    NSString *url = request.URL.absoluteString;
    
    NSString *scheme = @"xmg://";
    
    
    if ([url hasPrefix:scheme]) {
        NSLog(@"想调用OC的方法");
        
        NSString *path = [url substringFromIndex:scheme.length];
//        NSLog(@"我的路径:%@",path);
        //不带参数的情况
//        NSString *methodName = [url substringFromIndex:scheme.length];
//        [self performSelector:NSSelectorFromString(methodName) withObject:nil];
        if ([path isEqualToString:@"openWangmaDeposit"]) {
            if ([_isPayJump isEqualToString:@"yes"]) {
                NSArray * ctrlArray = self.navigationController.viewControllers;
                for (UIViewController *ctrl in ctrlArray) {
                    
//                    NSLog(@"ctrl ---- %@", ctrl);
                    if ([ctrl isKindOfClass:[HRBuyViewController class]]) {
                        [self.navigationController popToViewController:ctrl animated:YES];
                    }
                    
                }
            } else {
                MyselfTransactionController *myselftransVC = [[MyselfTransactionController alloc]init];
                [self.navigationController pushViewController:myselftransVC animated:YES];
                
                NSMutableArray *tempVCA = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
                for(UIViewController *tempVC in tempVCA)
                {
                    if([tempVC isKindOfClass:[WebViewForPayViewController class]])
                    {
                        
                        [tempVCA removeObject:tempVC];
                        [self.navigationController setViewControllers:tempVCA animated:YES];
                        break;
                    }
                }
            }
        } else if ([path isEqualToString:@"openWangmaWithdraw"]) {
            MyselfTransactionController *myselftransVC = [[MyselfTransactionController alloc]init];
            myselftransVC.isWithDraw = @"yes";
            [self.navigationController pushViewController:myselftransVC animated:YES];
            
            NSMutableArray *tempVCA = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
            for(UIViewController *tempVC in tempVCA)
            {
                if([tempVC isKindOfClass:[WebViewForPayViewController class]])
                {
                    
                    [tempVCA removeObject:tempVC];
                    [self.navigationController setViewControllers:tempVCA animated:YES];
                    break;
                }
            }
        } else {
            MyselfManageFinanceController *mySelfFianceVC = [[MyselfManageFinanceController alloc]init];
            mySelfFianceVC.isPay = @"YES";
            [self.navigationController pushViewController:mySelfFianceVC animated:YES];
            
            NSMutableArray *tempVCA = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
            for(UIViewController *tempVC in tempVCA)
            {
                if([tempVC isKindOfClass:[WebViewForPayViewController class]])
                {
                    
                    [tempVCA removeObject:tempVC];
                    [self.navigationController setViewControllers:tempVCA animated:YES];
                    break;
                }
            }
            
        }
        
        return NO;
    }
//    NSLog(@"想加载其他请求，不是调用OC方法");
    
    return YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
