//
//  FeedbackViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/11/24.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "FeedbackViewController.h"
#import "MMPopupWindow.h"

@interface FeedbackViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *feedText;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
- (IBAction)sendBtnAction:(id)sender;  /* 发送 */

@end

@implementation FeedbackViewController

- (void)setUpNavigationBar {
    self.tabBarController.tabBar.hidden = YES;
    [[MMPopupWindow sharedWindow] cacheWindow];
    self.title = @"意见反馈";
    self.view.backgroundColor = VIEWBACKCOLOR;
    [_sendBtn setBackgroundColor:BASECOLOR];
    _feedText.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

/* 发送 */
- (IBAction)sendBtnAction:(id)sender {
    if ([_feedText.text isEqualToString:@""] || [_feedText.text isEqualToString:@"请输入你对旺马的问题..."]) {
        MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
        alertConfig.defaultTextOK = @"确定";
        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"内容为空不可发送"];
        [alertView show];
        return;
    }
    
    /* 数据反馈 */
    [self getDataWithNetManager];
}

#pragma mark - 数据处理 －
- (void)getDataWithNetManager {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"正在提交" maskType:(SVProgressHUDMaskTypeNone)];
    [manager postDataWithUrlActionStr:@"Public/suggest" withParamDictionary:@{@"content":_feedText.text, @"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            _feedText.text = @"";
            [SVProgressHUD showSuccessWithStatus:@"发送成功" maskType:(SVProgressHUDMaskTypeNone)];
        }
    }];
}

#pragma - uitextview -
- (void)textViewDidBeginEditing:(UITextView *)textView {
    _feedText.text = @"";
}

- (void)textViewDidChange:(UITextView *)textView {
    if (_feedText.text .length >= 150) {
        _feedText.text = [_feedText.text substringToIndex:150];
        [_feedText resignFirstResponder];
        [SVProgressHUD showErrorWithStatus:@"最多只可输入150字"];
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
