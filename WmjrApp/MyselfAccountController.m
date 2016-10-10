//
//  MyselfAccountController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/11/19.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "MyselfAccountController.h"
#import "DrawalViewController.h"
#import "RechargeViewController.h"
#import "MMPopupWindow.h"
#import "RealNameCertificationViewController.h"
#import "OpenFastPaymentController.h"
#import "MMPopupItem.h"

// test
#import "SmartModel.h"

@interface MyselfAccountController ()

@property (weak, nonatomic) IBOutlet UILabel *myAccoutLab; /* 账户余额 */

@property (nonatomic, copy) NSString *isRealNameAuth;  /* 是否实名认证 */
@property (nonatomic, copy) NSString *isOpenFastPay;  /* 是否开通快捷支付 */

// test
@property (nonatomic,strong)SmartModel *smartModel;

@property (nonatomic,assign)CGFloat price;

@end

@implementation MyselfAccountController

- (void)setUpNavigationBar {
    self.title = @"我的账户";
}

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // test
    self.smartModel = [[SmartModel alloc]init];
    self.smartModel.price = 50;

    [self setUpNavigationBar];
    /*  初始化 */
    
    [[MMPopupWindow sharedWindow] cacheWindow];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /* 余额数 */
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"User/queryBalance" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"account_type":@"SAVING_POT"} withBlock:^(id obj) {
        if (obj) {
            NSString *balanceValue = [obj[@"data"] objectForKey:@"available_balance"];
            _myAccoutLab.text = balanceValue;
            //            _myAccoutLab.text = [NSString stringWithFormat:@"%.2f",self.smartModel.price];
        }
    }];

    /* 余额的变化 */
//    _myAccoutLab.text = [NSString stringWithFormat:@"%.2f",self.smartModel.price];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 2;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            /* 充值 */
            if ([[SingletonManager sharedManager].isRealName isEqualToString:@"0"]) {
                MMPopupItemHandler block = ^(NSInteger index){
                    if (index == 0) {
                        return ;
                    }
                    if (index == 1) {
                        /*  实名认证 */
                        RealNameCertificationViewController *realNameAuth = [[RealNameCertificationViewController alloc] init];
                        [self.navigationController pushViewController:realNameAuth animated:YES];
                        return;
                    }
                };
                NSArray *items =
                @[MMItemMake(@"取消", MMItemTypeNormal, block),
                  MMItemMake(@"确定", MMItemTypeNormal, block)];
                MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
                                                                     detail:@"你还未认证,请实名认证"
                                                                      items:items];
                [alertView show];
            }
//            if ([[SingletonManager sharedManager].isCard_id isEqualToString:@"0"]) {
//                /* 开通快捷支付 */
//                UIStoryboard *openFast = [UIStoryboard storyboardWithName:@"OpenFastPaymentController" bundle:[NSBundle mainBundle]];
//                OpenFastPaymentController *openFastPayment = [openFast instantiateViewControllerWithIdentifier:@"openFastPayment"];
//                openFastPayment.hidesBottomBarWhenPushed = YES;
////                openFastPayment.transferModel = self.smartModel;
////                openFastPayment.smartManager = ^(CGFloat price){
////                    _myAccoutLab.text = [NSString stringWithFormat:@"%.2f",price];
////                };
//                [self.navigationController pushViewController:openFastPayment animated:YES];
//                return;
//            }
            else {
                RechargeViewController *rechangeVC = [[RechargeViewController alloc] init];
                rechangeVC.accountChangeBlock = ^(CGFloat account) {
                    _myAccoutLab.text = [NSString stringWithFormat:@"%.2f", account];
                };
                [self.navigationController pushViewController:rechangeVC animated:YES];
            }
        }
        if (indexPath.row == 1) {
            /* 提现 */
            /* 当前余额为零不可提现 */
            if ([_myAccoutLab.text floatValue] == 0) {
                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
                alertConfig.defaultTextOK = @"确定";
                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"没有可用的余额"];
                [alertView show];
            } else {
                [[MMPopupWindow sharedWindow] cacheWindow];
                DrawalViewController *drawalVC = [[DrawalViewController alloc] init];
                drawalVC.accountStr = _myAccoutLab.text;
                drawalVC.accountChangeBlock1 = ^(CGFloat account) {
                _myAccoutLab.text = [NSString stringWithFormat:@"%.2f", account];
                };
                [self.navigationController pushViewController:drawalVC animated:YES];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1;
}

@end
