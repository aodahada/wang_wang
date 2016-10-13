//
//  RechargeViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/11/19.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "RechargeViewController.h"
#import "PopMenu.h"
#import "ComfirmFastPayView.h"
#import "MMPopupWindow.h"
#import "MyselfAccountController.h"
#import "MMPopupItem.h"
#import "UserInfoModel.h"
#import "WebViewForPayViewController.h"

@interface RechargeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bankImg; /*  银行图标 */
@property (weak, nonatomic) IBOutlet UILabel *bankName; /* 银行名称 */
@property (weak, nonatomic) IBOutlet UILabel *holdCard; /* 持卡人 */
@property (weak, nonatomic) IBOutlet UILabel *limitLab;  /* 账户余额 */

@property (weak, nonatomic) IBOutlet UILabel *accountLab; /* 账户余额 */
@property (weak, nonatomic) IBOutlet UITextField *rechargeLab; /*  输入充值金额 */
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)submitAction:(id)sender;  /* 确认提交 */

@property (nonatomic, strong) PopMenu *popMenu;
@property (nonatomic, copy) NSString *ticket;

@property (nonatomic, strong) NSMutableArray *bankInfoArray;  /* 银行卡信息数组 */
@property (nonatomic, copy) NSString *bankTail;  /* 银行卡尾号 */
@property (nonatomic, copy) NSString *order_id; /*  */

@end

@implementation RechargeViewController



- (void)setUpNavigationBar {
    self.view.backgroundColor = VIEWBACKCOLOR;
    self.title = @"充值";
    _bankImg.layer.cornerRadius = CGRectGetWidth(_bankImg.frame) / 2;
    _bankImg.layer.masksToBounds = YES;
    _submitBtn.backgroundColor = BASECOLOR;
    _bankInfoArray = [NSMutableArray array];
    _bankTail = nil;
}

- (void)dealloc {
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    NetManager *manager = [[NetManager alloc] init];
//    [manager postDataWithUrlActionStr:@"Card/query" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
//        if ([obj[@"result"] isEqualToString:@"1"]) {
//
//            NSString *dataStr = obj[@"data"];
//            NSArray *dataArray = [dataStr componentsSeparatedByString:@"^"];
//            [_bankInfoArray addObjectsFromArray:dataArray];
//            /* Card信息id ^银行编号 ^银行卡号 ^户名 ^卡类型 ^卡属性 ^VerifyMode是否是Sign ^创建时间 ^安全卡标识 */
//            NSDictionary *bankDic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"banks.plist" ofType:nil]];
//            NSDictionary *dic = [bankDic objectForKey:@"bank"];
//            /* 银行名称 */
//            NSString *bankName = [[dic objectForKey:_bankInfoArray[1]] firstObject];
//            /*  银行额度 */
//            _limitLab.text = [NSString stringWithFormat:@"本卡充值限额%@", [[dic objectForKey:_bankInfoArray[1]] lastObject]];
//            /* 银行尾号 */
//            NSString *bankNum = _bankInfoArray[2];
//            NSString *bankTail = [bankNum substringWithRange:NSMakeRange(bankNum.length - 4, 4)];
//            _bankTail = bankTail;
//            /* 持卡人 */
//            NSString *cardHolder = _bankInfoArray[3];
//            _bankImg.image = [UIImage imageNamed:_bankInfoArray[1]];
//            _bankName.text = [NSString stringWithFormat:@"%@ 尾号%@", bankName, bankTail];
//            _holdCard.text = cardHolder;
//        }
//    }];
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    [[MMPopupWindow sharedWindow] cacheWindow];
    
    /* 余额数 */
    NetManager *manager = [[NetManager alloc] init];
    NSDictionary *dict;
    if ([_isPayJump isEqualToString:@"yes"]) {
        dict = @{@"member_id":[SingletonManager sharedManager].uid, @"account_type":@"SAVING_POT"};
    } else {
        dict = @{@"member_id":[SingletonManager sharedManager].uid, @"account_type":@"SAVING_POT"};
    }
    [manager postDataWithUrlActionStr:@"User/queryBalance" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"account_type":@"SAVING_POT"} withBlock:^(id obj) {
        if (obj) {
            NSString *balanceValue = [obj[@"data"] objectForKey:@"available_balance"];
            _accountLab.text = balanceValue;
        }
    }];
}

/* 确认充值 */
- (IBAction)submitAction:(id)sender {
//    if ([_rechargeLab.text floatValue] == 0) {
//        MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
//        alertConfig.defaultTextOK = @"确定";
//        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"请输入充值金额"];
//        [alertView show];
//        return;
//    }
//    
//    /* 获取充值验证码 */
//    _popMenu = [[PopMenu alloc] init];
//    _popMenu.dimBackground = YES;
//    _popMenu.coverNavigationBar = YES;
//    [_popMenu showInRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    ComfirmFastPayView *fastPay = [[[NSBundle mainBundle] loadNibNamed:@"ComfirmFastPayView" owner:nil options:nil] firstObject];
//    fastPay.frame = CGRectMake(0, 0, 300, 130);
//    [fastPay setCenter:self.view.center];
//    fastPay.layer.cornerRadius = 5;
//    fastPay.layer.masksToBounds = YES;
//    [_popMenu addSubview:fastPay];
    
    /* 标题提示 */
//    fastPay.promptLab.text = [NSString stringWithFormat:@"支付%@元", _rechargeLab.text];
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"Trade/new_deposit" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"money":_rechargeLab.text,} withBlock:^(id obj) {
        NSLog(@"我的书1 ：%@",obj);
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [SVProgressHUD dismiss];
//            _ticket = [obj[@"data"] objectForKey:@"ticket"];
//            _order_id = [obj[@"data"] objectForKey:@"order_id"];
            NSDictionary *dataDic = obj[@"data"];
            WebViewForPayViewController *webViewForPayVC = [[WebViewForPayViewController alloc]initWithNibName:@"WebViewForPayViewController" bundle:nil];
            webViewForPayVC.htmlString = dataDic[@"html"];
            webViewForPayVC.isPayJump = _isPayJump;
            webViewForPayVC.title = @"充值界面";
            [self.navigationController pushViewController:webViewForPayVC animated:YES];
        } else {
            [SVProgressHUD dismiss];
            NSString *mes = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:mes];
            [alertView show];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
