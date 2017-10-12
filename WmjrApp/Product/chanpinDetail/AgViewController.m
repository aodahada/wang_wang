//
//  AgViewController.m
//  WmjrApp
//
//  Created by Baimifan on 16/5/5.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "AgViewController.h"

@interface AgViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *agWeb;

@end

@implementation AgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([_isNotification isEqualToString:@"yes"]) {
        UIImage *image = [[UIImage imageNamed:@"arrow_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        self.navigationItem.leftBarButtonItem = backButton;
    }
    
    _agWeb.delegate = self;
    [_agWeb setScalesPageToFit:YES];
    _agWeb.backgroundColor = [UIColor clearColor];
    [_agWeb setOpaque:YES];
    if (![[self convertNullString:_htmlContent] isEqualToString:@""]) {
        [_agWeb loadHTMLString:_htmlContent baseURL:nil];
    }else {
        [_agWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]]];
    }
}

- (NSString*)convertNullString:(NSString*)oldString{
    if (oldString!=nil && (NSNull *)oldString != [NSNull null]) {
        if ([oldString length]!=0) {
            if ([oldString isEqualToString:@"(null)"]) {
                return @"";
            }
            return  oldString;
        }else{
            return @"";
        }
    }
    else{
        return @"";
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [SVProgressHUD showWithStatus:@"加载中"];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [SVProgressHUD dismiss];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"AgViewController"];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AgViewController"];
    [SVProgressHUD dismiss];
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
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
