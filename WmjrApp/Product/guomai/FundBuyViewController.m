//
//  FundBuyViewController.m
//  wangmajinrong
//
//  Created by 1 & 0 on 15/6/24.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "FundBuyViewController.h"
#import "OpenFastPaymentController.h"
#import "ResetTradePasswordViewController.h"
#import "ResultDetailViewController.h"
#import "MMPopupWindow.h"
#import "PopMenu.h"
#import "ComfirmFastPayView.h"
#import "UserInfoModel.h"

@interface FundBuyViewController ()<UITextFieldDelegate>
{
    NSString *_earnTime;//开始收益
    NSString *_maturityTime;//收益到期时间
}

@property (weak, nonatomic) IBOutlet UITextField *buyInField;/*  买入金额 */
@property (weak, nonatomic) IBOutlet UILabel *earnLab; /*  收益时间 */
@property (weak, nonatomic) IBOutlet UILabel *remainMoneyLab; /* 当前余额 */
@property (weak, nonatomic) IBOutlet UILabel *quickPayLab; /* 快捷支付内容 */

@property (weak, nonatomic) IBOutlet UIImageView *remainMoneyImg;  /* 余额图片 */
@property (weak, nonatomic) IBOutlet UIImageView *quickPayImg;  /* 快捷支付图片 */
@property (weak, nonatomic) IBOutlet UIButton *remainMoneyBtn;  /* 点击余额行 */
- (IBAction)remainMoneyBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *quickPayBtn;  /* 点击快捷支付行 */
- (IBAction)quickPayBtnAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
- (IBAction)bindBtnAction:(id)sender; /*  我要绑卡 */
@property (weak, nonatomic) IBOutlet UIButton *fotgotPasswordBtn; /* 忘记密码 */
- (IBAction)fotgotPasswordBtnAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *trendPasswordField;/*  交易密码 */
@property (weak, nonatomic) IBOutlet UIButton *immediateBuyBtn;/*  确认支付 */
- (IBAction)immediateBuyBtnAction:(id)sender;

@property (nonatomic, assign) BOOL flag1;
@property (nonatomic, assign) BOOL flag2;
@property (nonatomic, copy) NSString *isQuickPay; /* 是否开通快捷支付 */

@property (nonatomic, strong) NSMutableArray *bankInfoArray;  /* 银行卡信息数组 */

@property (nonatomic, strong) PopMenu *popMenu;
@property (nonatomic, copy) NSString *ticket;
@property (nonatomic, copy) NSString *order_id; /*  */

@end

@implementation FundBuyViewController

- (void)dealloc {
}

/*  设置导航条 */
- (void)setUpNavigationBar {
    self.tabBarController.tabBar.hidden = YES;
    self.title = @"购买";
    [[MMPopupWindow sharedWindow] cacheWindow];
    self.view.backgroundColor = VIEWBACKCOLOR;
    _immediateBuyBtn.backgroundColor = BASECOLOR;
    _buyInField.placeholder = [NSString stringWithFormat:@"建议买入金额%@元以上", self.lowpurchase];
    
    _earnLab.text = [NSString stringWithFormat:@"%@开始计息, %@结息", self.startTime, self.endTime];
    _trendPasswordField.clearsOnBeginEditing = YES;
    [_trendPasswordField addTarget:self action:@selector(limitedNumberOfWords) forControlEvents:(UIControlEventEditingChanged)];
    
    /* 购买特权金时输入的金额 */
    if ([_buyMoneyNum floatValue] > 0) {
        _buyInField.text = _buyMoneyNum;
    }
    
    /* 购买时默认余额支付 */
    _flag1 = YES;
    _remainMoneyImg.image = [UIImage imageNamed:@"icon_yhfull"];
}

- (void)limitedNumberOfWords {
    if (_trendPasswordField.text.length > 11) {
        _trendPasswordField.text = [_trendPasswordField.text substringToIndex:11];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    
    _bankInfoArray = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self openTheFastPayment];
}

/* 开通快捷支付 */
- (void)openTheFastPayment {
     /* 是否显示绑卡 */
    if ([[SingletonManager sharedManager].isCard_id isEqualToString:@"0"]) {
        _bindBtn.hidden = NO;
        _quickPayLab.numberOfLines = 1;
        _quickPayLab.font = [UIFont systemFontOfSize:13.0];
        _quickPayLab.text = @"请开通快捷支付";
    } else {
        _bindBtn.hidden = YES;
        /* 余额数 */
        NetManager *manager = [[NetManager alloc] init];
        [manager postDataWithUrlActionStr:@"User/queryBalance" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"account_type":@"SAVING_POT"} withBlock:^(id obj) {
            if (obj) {
                NSString *balanceValue = [obj[@"data"] objectForKey:@"available_balance"];
                _remainMoneyLab.text = [NSString stringWithFormat:@"当前余额(%.2f元)", [balanceValue floatValue]];
            }
        }];
        /* 开通快捷支付的银行卡信息 */
        _quickPayLab.numberOfLines = 2;
        _quickPayLab.font = [UIFont systemFontOfSize:12.0];
        [manager postDataWithUrlActionStr:@"Card/query" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                NSString *dataStr = obj[@"data"];
                NSArray *dataArray = [dataStr componentsSeparatedByString:@"^"];
                [_bankInfoArray addObjectsFromArray:dataArray];
                /* Card信息id ^银行编号 ^银行卡号 ^户名 ^卡类型 ^卡属性 ^VerifyMode是否是Sign ^创建时间 ^安全卡标识 */
                
                NSDictionary *bankDic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"banks.plist" ofType:nil]];
                NSDictionary *dic = [bankDic objectForKey:@"bank"];
                /* 银行名称 */
                NSString *bankName = [[dic objectForKey:_bankInfoArray[1]] firstObject];
                /* 银行尾号 */
                NSString *bankNum = _bankInfoArray[2];
                NSString *bankTail = [bankNum substringWithRange:NSMakeRange(bankNum.length - 4, 4)];
                _quickPayLab.text = [NSString stringWithFormat:@"%@尾号(%@) \n%@", bankName, bankTail, [[dic objectForKey:_bankInfoArray[1]] lastObject]];
            }
        }];
    }
}

/*  我要绑定 */
- (IBAction)bindBtnAction:(id)sender {
    /* 开通快捷支付 */
    UIStoryboard *openFast = [UIStoryboard storyboardWithName:@"OpenFastPaymentController" bundle:[NSBundle mainBundle]];
    OpenFastPaymentController *openFastPayment = [openFast instantiateViewControllerWithIdentifier:@"openFastPayment"];
    openFastPayment.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:openFastPayment animated:YES];
    
}

/*  确认支付 */
- (IBAction)immediateBuyBtnAction:(id)sender {
    if (_buyInField.text.length == 0) {
        MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
        alertConfig.defaultTextOK = @"确定";
        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"请输入购买金额"];
        [alertView show];
        return;
    }
    
    if ([_buyInField.text floatValue] < [self.lowpurchase floatValue]) {
        MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
        alertConfig.defaultTextOK = @"确定";
        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"输入购买金额少于起购金额"];
        [alertView show];
        return;
    }
    
    if ([_trendPasswordField.text isEqualToString:@""]) {
        MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
        alertConfig.defaultTextOK = @"确定";
        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"请输入交易密码"];
        [alertView show];
        return;
    }
    if (_trendPasswordField.text.length != 6) {
        MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
        alertConfig.defaultTextOK = @"确定";
        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"请输入6位交易密码"];
        [alertView show];
        return;
    }


    NetManager *manager = [[NetManager alloc] init];
    NSString *pay_methodStr = nil;
    /* 选择余额支付 */
    if (_flag1 == YES) {
        pay_methodStr = @"balance";
        /* 生成订单 */
        [SVProgressHUD showWithStatus:@"正在支付" maskType:(SVProgressHUDMaskTypeNone)];
        [manager postDataWithUrlActionStr:@"Trade/collect" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"pay_method":pay_methodStr, @"money":_buyInField.text, @"product_id":self.product_idStr, @"product_name":self.product_name, @"pwd_trade":_trendPasswordField.text} withBlock:^(id obj) {
            NSLog(@"%@", obj);
            if ([obj[@"result"] isEqualToString:@"1"]) {
                [SVProgressHUD showSuccessWithStatus:@"支付成功" maskType:(SVProgressHUDMaskTypeNone)];
                
                UIStoryboard *resultDe = [UIStoryboard storyboardWithName:@"ResultDetailViewController" bundle:[NSBundle mainBundle]];
                ResultDetailViewController *resultDVC = [resultDe instantiateViewControllerWithIdentifier:@"ResultDetail"];
                resultDVC.buyNum = _buyInField.text;
                resultDVC.proname = self.product_name;
                CGFloat sum = [_buyInField.text floatValue] *[self.yearRate floatValue] / 365 * [self.day intValue] + [_buyInField.text floatValue];
                resultDVC.rateNum = [NSString stringWithFormat:@"%.2f", sum];

                [self.navigationController pushViewController:resultDVC animated:YES];
            } else {
                [SVProgressHUD dismiss];
                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
                alertConfig.defaultTextOK = @"确定";
                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:[obj[@"data"] objectForKey:@"mes"]];
                [alertView show];
            }
        }];
    }
    /* 选择快捷支付 */
    if (_flag2 == YES) {
        if ([[SingletonManager sharedManager].isCard_id isEqualToString:@"0"]) {
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"请先绑定银行卡"];
            [alertView show];
            return;
        }
//        pay_methodStr = @"binding_pay";
//        /* 生成订单 */
//        NetManager *manager = [[NetManager alloc] init];
//        [manager postDataWithUrlActionStr:@"Trade/collect" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"pay_method":pay_methodStr, @"money":_buyInField.text, @"product_id":self.product_idStr, @"product_name":self.product_name, @"pwd_trade":_trendPasswordField.text} withBlock:^(id obj) {
//            NSLog(@"%@", obj); // 1000   1001
//            if ([obj[@"result"] isEqualToString:@"1"]) {
//            } else {
//                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
//                alertConfig.defaultTextOK = @"确定";
//                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:[obj[@"data"] objectForKey:@"mes"]];
//                [alertView show];
//                return ;
//            }
//        }];
  
    /* 获取充值验证码 */
    _popMenu = [[PopMenu alloc] init];
    _popMenu.dimBackground = YES;
    _popMenu.coverNavigationBar = YES;
    [_popMenu showInRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    ComfirmFastPayView *fastPay = [[[NSBundle mainBundle] loadNibNamed:@"ComfirmFastPayView" owner:nil options:nil] firstObject];
    fastPay.frame = CGRectMake(0, 0, 300, 130);
    [fastPay setCenter:self.view.center];
    fastPay.layer.cornerRadius = 5;
    fastPay.layer.masksToBounds = YES;
    [_popMenu addSubview:fastPay];
    
    /* 标题提示 */
    fastPay.promptLab.text = [NSString stringWithFormat:@"支付%@元", _buyInField.text];
    
    NSDictionary *paramDic4 = @{@"member_id":[SingletonManager sharedManager].uid};
    [manager postDataWithUrlActionStr:@"User/que" withParamDictionary:paramDic4 withBlock:^(id obj) {
        if (obj) {
            UserInfoModel *model = [[UserInfoModel alloc] init];
            [model setValuesForKeysWithDictionary:obj[@"data"]];
            /* 手机尾号 */
            NSString *phoneBind = model.mobile_bind;
            fastPay.phoneTailLab.text = [NSString stringWithFormat:@"输入手机尾号%@接受的验证码", [phoneBind substringFromIndex:7]];
        }
    }];
    
    [fastPay callBtnClickEventBlock:^(UIButton *sender) {
        /* 获取验证码 */
        if (sender.tag == 1000) {
            [manager postDataWithUrlActionStr:@"Trade/deposit" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"money":_buyInField.text,} withBlock:^(id obj) {
                if ([obj[@"result"] isEqualToString:@"1"]) {
                    _ticket = [obj[@"data"] objectForKey:@"ticket"];
                    _order_id = [obj[@"data"] objectForKey:@"order_id"];
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
        
        if ([sender.titleLabel.text isEqualToString:@"取消"]) {
            [_popMenu dismissMenu];
            return ;
        }
        
        if ([sender.titleLabel.text isEqualToString:@"确认"]) {
            if ([fastPay.vercerNumField.text isEqualToString:@""]) {
                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
                alertConfig.defaultTextOK = @"确定";
                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"请输入验证码"];
                [alertView show];
                return;
            }
            [SVProgressHUD showWithStatus:@"正在支付..." maskType:(SVProgressHUDMaskTypeNone)];
            [manager postDataWithUrlActionStr:@"Trade/advance" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"order_id":_order_id, @"ticket":_ticket, @"validate_code":fastPay.vercerNumField.text} withBlock:^(id obj) {
                if ([obj[@"result"] isEqualToString:@"1"]) {
                    [_popMenu dismissMenu];
                    [SVProgressHUD showSuccessWithStatus:@"支付成功" maskType:(SVProgressHUDMaskTypeNone)];
                    
                    UIStoryboard *resultDe = [UIStoryboard storyboardWithName:@"ResultDetailViewController" bundle:[NSBundle mainBundle]];
                    ResultDetailViewController *resultDVC = [resultDe instantiateViewControllerWithIdentifier:@"ResultDetail"];
                    resultDVC.buyNum = _buyInField.text;
                    resultDVC.proname = self.product_name;
                    CGFloat sum = [_buyInField.text floatValue] *[self.yearRate floatValue] / 365 * [self.day intValue] + [_buyInField.text floatValue];
                    resultDVC.rateNum = [NSString stringWithFormat:@"%.2f", sum];
                    
                    [self.navigationController pushViewController:resultDVC animated:YES];
                    
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
    }];
}
}

/* 忘记密码 */
- (IBAction)fotgotPasswordBtnAction:(id)sender {
    ResetTradePasswordViewController *resetTradePVC = [[ResetTradePasswordViewController alloc] init];
    [self.navigationController pushViewController:resetTradePVC animated:YES];
}

/* 两个支付方式而选其一 */
/* 点击余额行 */
- (IBAction)remainMoneyBtnAction:(id)sender {
    if (_flag2 != YES) {
        _remainMoneyBtn.enabled = NO;
        return;
    } else {
        _remainMoneyBtn.enabled = YES;
    }
    if (!_flag1) {
        _remainMoneyImg.image = [UIImage imageNamed:@"icon_yhfull"];
        /*  二选其一 余额支付,非快捷支付 */
        _flag2 = NO;
        _quickPayImg.image = [UIImage imageNamed:@"icon_yhempty"];
        _quickPayBtn.enabled = YES;
    } else {
        _remainMoneyImg.image = [UIImage imageNamed:@"icon_yhempty"];
    }
    _flag1 = !_flag1;
//    NSLog(@"%d", _flag1);
}

/* 点击快捷支付行 */
- (IBAction)quickPayBtnAction:(id)sender {
    if (_flag1 != YES) {
        _quickPayBtn.enabled = NO;
        return;
    } else {
        _quickPayBtn.enabled = YES;
    }
    if (!_flag2) {
        _quickPayImg.image = [UIImage imageNamed:@"icon_yhfull"];
        /* 而选其一 快捷支付,非余额支付 */
        _flag1 = NO;
        _remainMoneyImg.image = [UIImage imageNamed:@"icon_yhempty"];
        _remainMoneyBtn.enabled  =YES;
    } else {
        _quickPayImg.image = [UIImage imageNamed:@"icon_yhempty"];
    }
    _flag2 = !_flag2;
//    NSLog(@"%d", _flag2);
    
    /* 提示框,提示需先开通快捷支付 */
    
}

#pragma mark - UITextField -

/*获取收益开始日期*/
- (NSString *)getEarningStartDate {
    NSDate *newDate = [NSDate date];
    NSTimeInterval times = newDate.timeIntervalSince1970 + 8 * 3600;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *todayDate = [NSDate dateWithTimeIntervalSince1970:times];
    NSString *confirmStr = [formatter stringFromDate:todayDate];
    
    return confirmStr;
}

/*获取收益到账日期*/
- (NSString *)getEarningEndDate {
    NSDate *newDate = [NSDate date];
    NSTimeInterval times = newDate.timeIntervalSince1970 + 8 * 3600 + 7 * 24 * 3600;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *todayDate = [NSDate dateWithTimeIntervalSince1970:times];
    NSString *confirmStr = [formatter stringFromDate:todayDate];
    
    return confirmStr;
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
