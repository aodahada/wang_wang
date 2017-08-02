//
//  RegisterAgreeViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 16/1/29.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "RegisterAgreeViewController.h"

@interface RegisterAgreeViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *agreeWeb;

@end

@implementation RegisterAgreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户协议";
    self.tabBarController.tabBar.hidden = YES;
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:VIEWBACKCOLOR};
//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backBtnAction)];
//    self.navigationItem.leftBarButtonItem = backBtn;
//    self.navigationController.navigationBar.barTintColor = GERENCOLOR;
//    self.navigationController.navigationBar.tintColor = VIEWBACKCOLOR;
//    self.navigationController.navigationBar.translucent = NO;
    
    NSURL *url = [[NSURL alloc]initWithString:@"http://wmjr888.com/home/page/protocol"];
    [_agreeWeb loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"RegisterAgreeViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RegisterAgreeViewController"];
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
