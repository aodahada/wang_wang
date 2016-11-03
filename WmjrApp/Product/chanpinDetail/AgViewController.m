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
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_back"] style:(UIBarButtonItemStyleDone) target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backBtn;
    _agWeb.delegate = self;
    [_agWeb setScalesPageToFit:YES];
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
