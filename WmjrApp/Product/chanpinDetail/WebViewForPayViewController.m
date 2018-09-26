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
    NSLog(@"我的请求地址:%@",_htmlString);
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_htmlString]]];
    [_webView sizeToFit];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"WebViewForPayViewController"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"WebViewForPayViewController"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    
    NSString *url = request.URL.absoluteString;
    
    NSString *scheme = @"xmg://";
    
    
    if ([url hasPrefix:scheme]) {
        
        
        NSString *path = [url substringFromIndex:scheme.length];

        //不带参数的情况
//        NSString *methodName = [url substringFromIndex:scheme.length];
//        [self performSelector:NSSelectorFromString(methodName) withObject:nil];
        if ([path isEqualToString:@"openWangmaDeposit"]) {
            if ([_isPayJump isEqualToString:@"yes"]) {
                NSArray * ctrlArray = self.navigationController.viewControllers;
                for (UIViewController *ctrl in ctrlArray) {
                    

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
        } else if([path isEqualToString:@"openWangmaPassword"]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            MyselfManageFinanceController *mySelfFianceVC = [[MyselfManageFinanceController alloc]init];
            mySelfFianceVC.isPay = @"YES";
            //购买成功改变用户新人状态
            if ([[SingletonManager sharedManager].userModel.is_newer isEqualToString:@"1"]) {
                [SingletonManager sharedManager].userModel.is_newer = @"0";
            }
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
    
    return YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
