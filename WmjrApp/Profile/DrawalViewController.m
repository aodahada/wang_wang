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

@property (strong, nonatomic) UILabel *accountLab; /* 账户余额 */
@property (strong, nonatomic) UITextField *drawMoneyLab; /*  输入提现金额 */
@property (strong, nonatomic) UIButton *submitBtn;

@property (nonatomic, strong) PopMenu *popMenu;
@property (nonatomic, strong) NSMutableArray *bankInfoArray;  /* 银行卡信息数组 */

@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, strong) UIImage *bankNameImg;
@property (nonatomic, copy) NSString *bankTail;
@property (nonatomic, copy) NSString *currentMoney;//当前余额
@property (nonatomic, copy) NSString *bankMessage;//银行卡信息

@end

@implementation DrawalViewController

- (void)setUpNavigationBar {
    self.title = @"提现";
    self.view.backgroundColor = RGBA(238, 240, 242, 1.0);
    _submitBtn.backgroundColor = BASECOLOR;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    _bankInfoArray = [NSMutableArray array];
    [self loadRequestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"DrawalViewController"];
    /* 余额数 */
//    _accountLab.text = self.accountStr;
    self.tabBarController.tabBar.hidden = YES;
    [self getPersonalMoney:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"DrawalViewController"];
}

#pragma mark - 界面
- (void)setUpLayout {
    
    UIView *bankView = [[UIView alloc]init];
    bankView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bankView];
    [bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(RESIZE_UI(80));
    }];
    
    UIImageView *bankImageView = [[UIImageView alloc]init];
    bankImageView.image = _bankNameImg;
    bankImageView.layer.masksToBounds = YES;
    bankImageView.layer.cornerRadius = RESIZE_UI(20);
    [bankView addSubview:bankImageView];
    [bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_offset(RESIZE_UI(40));
        make.left.equalTo(bankView.mas_left).with.offset(RESIZE_UI(18));
        make.centerY.equalTo(bankView.mas_centerY);
    }];
    
    UILabel *bankNameLabel = [[UILabel alloc]init];
    bankNameLabel.text = [NSString stringWithFormat:@"%@(%@)",_bankName,_bankTail];
    bankNameLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [bankView addSubview:bankNameLabel];
    [bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankView.mas_top).with.offset(RESIZE_UI(15));
        make.left.equalTo(bankImageView.mas_right).with.offset(RESIZE_UI(20));
    }];
    
    UILabel *bankMessLabel = [[UILabel alloc]init];
    bankMessLabel.text = _bankMessage;
    bankMessLabel.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    bankMessLabel.textColor = RGBA(153, 153, 153, 1.0);
    [bankView addSubview:bankMessLabel];
    [bankMessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bankImageView.mas_bottom);
        make.left.equalTo(bankNameLabel.mas_left);
    }];
    
    //余额view
    UIView *yueView = [[UIView alloc]init];
    yueView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:yueView];
    [yueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankView.mas_bottom).with.offset(RESIZE_UI(12));
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(RESIZE_UI(54));
    }];
    
    UILabel *yueTitle = [[UILabel alloc]init];
    yueTitle.text = @"账户余额";
    yueTitle.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [yueView addSubview:yueTitle];
    [yueTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yueView.mas_left).with.offset(RESIZE_UI(12));
        make.centerY.equalTo(yueView.mas_centerY);
    }];
    
    _accountLab = [[UILabel alloc]init];
    _accountLab.text = _currentMoney;
    _accountLab.textColor = RGBA(153, 153, 153, 1.0);
    [yueView addSubview:_accountLab];
    [_accountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(yueView.mas_right).with.offset(-RESIZE_UI(12));
        make.centerY.equalTo(yueView.mas_centerY);
    }];
    
    //充值金额
    UIView *rechargeMoneyView = [[UIView alloc]init];
    rechargeMoneyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rechargeMoneyView];
    [rechargeMoneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yueView.mas_bottom).with.offset(1);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(RESIZE_UI(54));
    }];
    
    UILabel *rechargeTitle = [[UILabel alloc]init];
    rechargeTitle.text = @"提现金额";
    rechargeTitle.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [self.view addSubview:rechargeTitle];
    [rechargeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rechargeMoneyView.mas_left).with.offset(RESIZE_UI(12));
        make.centerY.equalTo(rechargeMoneyView.mas_centerY);
    }];
    
    _drawMoneyLab = [[UITextField alloc] init];
    _drawMoneyLab.placeholder = @"请输入提现金额(元)";
    _drawMoneyLab.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _drawMoneyLab.keyboardType = UIKeyboardTypeDecimalPad;
    _drawMoneyLab.textAlignment = NSTextAlignmentRight;
    [rechargeMoneyView addSubview:_drawMoneyLab];
    [_drawMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rechargeMoneyView.mas_right).with.offset(-RESIZE_UI(12));
        make.centerY.equalTo(rechargeMoneyView.mas_centerY);
        make.width.mas_offset(RESIZE_UI(143));
        make.height.mas_offset(RESIZE_UI(26));
    }];
    
    _submitBtn = [[UIButton alloc]init];
    [_submitBtn setBackgroundColor:RGBA(255, 84, 34, 1.0)];
    [_submitBtn setTitle:@"确认提现" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(submitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitBtn];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rechargeMoneyView.mas_bottom).with.offset(RESIZE_UI(44));
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_offset(RESIZE_UI(345));
        make.height.mas_offset(RESIZE_UI(49));
    }];
    
}

#pragma mark - 获取绑定银行卡信息
- (void)loadRequestData {
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"Card/query" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSString *dataStr = obj[@"data"];
            dataStr = [SingletonManager convertNullString:dataStr];
            if ([dataStr isEqualToString:@""]) {
                //                NSLog(@"haha1");
            } else {
                NSArray *dataArray = [dataStr componentsSeparatedByString:@"^"];
                [_bankInfoArray addObjectsFromArray:dataArray];
                /* Card信息id ^银行编号 ^银行卡号 ^户名 ^卡类型 ^卡属性 ^VerifyMode是否是Sign ^创建时间 ^安全卡标识 */
                //                self.card_id = dataArray[0];
                NSDictionary *bankDic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"banks.plist" ofType:nil]];
                NSDictionary *dic = [bankDic objectForKey:@"bank"];
                /* 银行图标 */
                _bankNameImg = [UIImage imageNamed:_bankInfoArray[1]];
                /* 银行名称 */
                NSString *bankNameHa = [[dic objectForKey:_bankInfoArray[1]] firstObject];
                _bankName = bankNameHa;
                /* 银行尾号 */
                NSString *bankNum = _bankInfoArray[2];
                NSString *bankTailHa = [bankNum substringWithRange:NSMakeRange(bankNum.length - 4, 4)];
                _bankTail = bankTailHa;
                _bankMessage = dataArray[9];
                [self getPersonalMoney:NO];
                
            }
        }
    }];
}


#pragma mark - 获取当前余额
- (void)getPersonalMoney:(BOOL)isApper {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"更新数据中"];
    [manager postDataWithUrlActionStr:@"User/queryBalance" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"account_type":@"SAVING_POT"} withBlock:^(id obj) {
        if (obj) {
            NSString *balanceValue = [obj[@"data"] objectForKey:@"available_balance"];
            _currentMoney = balanceValue;
            if (isApper) {
                _accountLab.text = _currentMoney;
            } else {
                [self setUpLayout];
            }
            [SVProgressHUD dismiss];
        }
    }];
}



/* 确认提现 */
- (void)submitBtnAction {
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
