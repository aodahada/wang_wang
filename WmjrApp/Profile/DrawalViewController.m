//
//  DrawalViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/11/20.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "DrawalViewController.h"
#import "PopMenu.h"
#import "ResultShowView.h"
#import "ResetTradePasswordViewController.h"
#import "WebViewForPayViewController.h"

@interface DrawalViewController ()

@property (weak, nonatomic) IBOutlet UILabel *accountLab; /* 账户余额 */
@property (weak, nonatomic) IBOutlet UITextField *drawMoneyLab; /*  输入提现金额 */
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)submitBtnAction:(id)sender;   /* 确认提现 */
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordBtn;
- (IBAction)forgotPasswordBtnAction:(id)sender; /* 忘记密码 */

@property (nonatomic, strong) PopMenu *popMenu;
@property (nonatomic, strong) NSMutableArray *bankInfoArray;  /* 银行卡信息数组 */

@end

@implementation DrawalViewController

- (void)setUpNavigationBar {
    self.title = @"提现";
    self.view.backgroundColor = VIEWBACKCOLOR;
    _submitBtn.backgroundColor = BASECOLOR;
}

- (void)buttonAction {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    _bankInfoArray = [NSMutableArray array];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /* 余额数 */
    _accountLab.text = self.accountStr;
}

/* 确认提现 */
- (IBAction)submitBtnAction:(id)sender {
    if ([_drawMoneyLab.text isEqualToString:@""]) {
        [[SingletonManager sharedManager] alert1PromptInfo:@"请输入提现金额"];
        return;
    }
    if ([_drawMoneyLab.text floatValue] < 0) {
        [[SingletonManager sharedManager] alert1PromptInfo:@"请重新输入提现金额"];
        return;
    }
    if ([_drawMoneyLab.text floatValue] > [_accountLab.text floatValue]) {
        [[SingletonManager sharedManager] alert1PromptInfo:@"账户余额不足"];
        return;
    }
    if ([_drawMoneyLab.text floatValue] == 0) {
        [[SingletonManager sharedManager] alert1PromptInfo:@"请重新输入提现金额"];
        return;
    }
    
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中" maskType:(SVProgressHUDMaskTypeBlack)];
    [manager postDataWithUrlActionStr:@"Trade/new_withdraw" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"money":_drawMoneyLab.text} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSLog(@"我的体现L%@",obj);
            
            [SVProgressHUD dismiss];
//            NSString *accountStr = [NSString stringWithFormat:@"%.2f", [_accountLab.text floatValue] - [_drawMoneyLab.text floatValue]];
//            self.accountChangeBlock1([accountStr floatValue]);
////            _accountLab.text = accountStr;
//            [self.navigationController popViewControllerAnimated:YES];
            NSDictionary *dataDic = obj[@"data"];
            WebViewForPayViewController *webViewForPayVC = [[WebViewForPayViewController alloc]initWithNibName:@"WebViewForPayViewController" bundle:nil];
            webViewForPayVC.htmlString = dataDic[@"html"];
            webViewForPayVC.title = @"提现界面";
            [self.navigationController pushViewController:webViewForPayVC animated:YES];
            
        } else {
            [SVProgressHUD dismiss];
            NSString *mes = [obj[@"result"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:mes];
            [alertView show];
        }
    }];
}

/* 忘记密码 */
- (IBAction)forgotPasswordBtnAction:(id)sender {
    ResetTradePasswordViewController *resettrendPassVC = [[ResetTradePasswordViewController alloc] init];
    [self.navigationController pushViewController:resettrendPassVC animated:YES];
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
