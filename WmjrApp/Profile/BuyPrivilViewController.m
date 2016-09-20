//
//  BuyPrivilViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/6/29.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "BuyPrivilViewController.h"
//#import "FundBuyViewController.h"
#import "MMPopupItem.h"
#import "MMPopupWindow.h"
#import "ResultDetailViewController.h"

@interface BuyPrivilViewController ()

@property (strong, nonatomic) IBOutlet UILabel *availablePri;//可用特权金
@property (strong, nonatomic) IBOutlet UILabel *earnTime;//收益时间
@property (strong, nonatomic) IBOutlet UILabel *earnOfRate;//收益率
@property (strong, nonatomic) IBOutlet UITextField *investNum;//投资金额
@property (weak, nonatomic) IBOutlet UITextField *tradePassword;  /* 交易密码 */

@property (strong, nonatomic) IBOutlet UIButton *buyBtn;//立即购买
- (IBAction)buyBtnAction:(id)sender;

@end

@implementation BuyPrivilViewController

- (void)configNavigationBar {
    self.title = @"购买特权金";
    self.view.backgroundColor = VIEWBACKCOLOR;
    /* 设置内容的颜色 */
    _availablePri.textColor = AUXILY_COLOR;
    _availablePri.text = self.availableStr;
    _earnOfRate.textColor = BASECOLOR;
    _earnTime.textColor = BASECOLOR;
    _earnTime.text = [NSString stringWithFormat:@"%@开始计息, %@结息", [self getEarningStartDate], [self getEarningEndDate]];
    
    _investNum.textColor = AUXILY_COLOR;
    [_buyBtn setBackgroundColor:BASECOLOR];
}

/*获取收益开始日期*/
- (NSString *)getEarningStartDate {
    NSDate *newDate = [NSDate date];
    NSTimeInterval times = newDate.timeIntervalSince1970 + 24 * 3600;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *todayDate = [NSDate dateWithTimeIntervalSince1970:times];
    NSString *confirmStr = [formatter stringFromDate:todayDate];
    
    return confirmStr;
}

/*获取收益到账日期*/
- (NSString *)getEarningEndDate {
    NSDate *newDate = [NSDate date];
    NSTimeInterval times = newDate.timeIntervalSince1970 + 7 * 24 * 3600;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *todayDate = [NSDate dateWithTimeIntervalSince1970:times];
    NSString *confirmStr = [formatter stringFromDate:todayDate];
    
    return confirmStr;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    [[MMPopupWindow sharedWindow] cacheWindow];
}

/* 购买特权金 */
- (IBAction)buyBtnAction:(id)sender {
    /* 只有当可用特权金的金额大于0才能点击购买 */
    if ([_availablePri.text floatValue] > 0) {
        if ([_tradePassword.text isEqualToString:@""]) {
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"请输入交易密码"];
            [alertView show];
            return;
        }
        if ([_investNum.text floatValue] > 0) {
             NetManager *manager = [[NetManager alloc] init];
            [SVProgressHUD showWithStatus:@"正在购买" maskType:(SVProgressHUDMaskTypeNone)];
            [manager postDataWithUrlActionStr:@"Trade/collect" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"pay_method":@"balance", @"money":_investNum.text, @"product_id":self.sep_idStr, @"product_name":self.sep_nameStr, @"pwd_trade":_tradePassword.text} withBlock:^(id obj) {
                NSLog(@"%@", obj);
                if ([obj[@"result"] isEqualToString:@"1"]) {
                    [SVProgressHUD showSuccessWithStatus:@"购买成功" maskType:(SVProgressHUDMaskTypeNone)];
                    
                    UIStoryboard *resultDe = [UIStoryboard storyboardWithName:@"ResultDetailViewController" bundle:[NSBundle mainBundle]];
                    ResultDetailViewController *resultDVC = [resultDe instantiateViewControllerWithIdentifier:@"ResultDetail"];
                    resultDVC.buyNum = _investNum.text;
                    resultDVC.proname = self.sep_nameStr;
                    CGFloat sum = [_investNum.text floatValue] *[self.yearRate floatValue] / 365 * [self.day intValue] + [_investNum.text floatValue];
                    resultDVC.rateNum = [NSString stringWithFormat:@"%.2f", sum];
                    resultDVC.isRefresh = YES;
                    
                    [self.navigationController pushViewController:resultDVC animated:YES];
                } else {
                    [SVProgressHUD dismiss];
                    MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
                    alertConfig.defaultTextOK = @"确定";
                    MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:[obj[@"data"] objectForKey:@"mes"]];
                    [alertView show];
                }
            }];
        } else {
            /* 没有输入投资金额 */
            if ([_investNum.text intValue] == 0) {
                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
                alertConfig.defaultTextOK = @"确定";
                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"请输入投资金额"];
                [alertView show];
                return;
            }
        }
    } else {
        /* 当没有可用的特权金 */
        if ([_availablePri.text intValue] == 0) {
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"没有可用的特权金"];
            [alertView show];
            return;
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
