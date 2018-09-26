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
#import "MMPopupItem.h"
#import "UserInfoModel.h"
#import "WebViewForPayViewController.h"

@interface RechargeViewController ()


@property (strong, nonatomic) UITextField *rechargeLab; /*  输入充值金额 */
@property (strong, nonatomic) UIButton *submitBtn;

@property (nonatomic, strong) PopMenu *popMenu;
@property (nonatomic, copy) NSString *ticket;

@property (nonatomic, strong) NSMutableArray *bankInfoArray;  /* 银行卡信息数组 */
@property (nonatomic, copy) NSString *order_id; /*  */

@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, strong) UIImage *bankNameImg;
@property (nonatomic, copy) NSString *bankTail;
@property (nonatomic, copy) NSString *currentMoney;//当前余额
@property (nonatomic, strong) UILabel *yueContent;//余额
@property (nonatomic, copy) NSString *bankMessage;//银行卡信息


@end

@implementation RechargeViewController

- (void)setUpNavigationBar {
    self.title = @"充值";
    _submitBtn.backgroundColor = RGBA(255, 86, 45, 1.0);
    _bankInfoArray = [NSMutableArray array];
    _bankTail = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"RechargeViewController"];
    self.tabBarController.tabBar.hidden = YES;
    [self getPersonalMoney:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(238, 240, 242, 1.0);
    [self setUpNavigationBar];
    [[MMPopupWindow sharedWindow] cacheWindow];
    [self loadRequestData];
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
    
    _yueContent = [[UILabel alloc]init];
    _yueContent.text = _currentMoney;
    _yueContent.textColor = RGBA(153, 153, 153, 1.0);
    [yueView addSubview:_yueContent];
    [_yueContent mas_makeConstraints:^(MASConstraintMaker *make) {
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
    rechargeTitle.text = @"充值金额";
    rechargeTitle.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    [self.view addSubview:rechargeTitle];
    [rechargeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rechargeMoneyView.mas_left).with.offset(RESIZE_UI(12));
        make.centerY.equalTo(rechargeMoneyView.mas_centerY);
    }];
    
    _rechargeLab = [[UITextField alloc] init];
    _rechargeLab.placeholder = @"请输入充值金额(元)";
    _rechargeLab.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    _rechargeLab.keyboardType = UIKeyboardTypeDecimalPad;
    _rechargeLab.textAlignment = NSTextAlignmentRight;
    [rechargeMoneyView addSubview:_rechargeLab];
    [_rechargeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rechargeMoneyView.mas_right).with.offset(-RESIZE_UI(12));
        make.centerY.equalTo(rechargeMoneyView.mas_centerY);
        make.width.mas_offset(RESIZE_UI(143));
        make.height.mas_offset(RESIZE_UI(26));
    }];
    
    _submitBtn = [[UIButton alloc]init];
    [_submitBtn setBackgroundColor:RGBA(255, 84, 34, 1.0)];
    [_submitBtn setTitle:@"确认充值" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
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
//                _bankNameLab.text = [NSString stringWithFormat:@"%@尾号%@", bankName, bankTail];
//                /* 持卡人 */
//                _holdBankLab.text = _bankInfoArray[3];
                _bankMessage = dataArray[9];
                [self getPersonalMoney:NO];
                
            }
        }
    }];
}


#pragma mark - 获取当前余额
- (void)getPersonalMoney:(BOOL)isApper {
    NetManager *manager = [[NetManager alloc] init];
    NSDictionary *dict;
    if ([_isPayJump isEqualToString:@"yes"]) {
        dict = @{@"member_id":[SingletonManager sharedManager].uid, @"account_type":@"SAVING_POT"};
    } else {
        dict = @{@"member_id":[SingletonManager sharedManager].uid, @"account_type":@"SAVING_POT"};
    }
    [SVProgressHUD showWithStatus:@"更新数据中"];
    [manager postDataWithUrlActionStr:@"User/queryBalance" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"account_type":@"SAVING_POT"} withBlock:^(id obj) {
        if (obj) {
            NSString *balanceValue = [obj[@"data"] objectForKey:@"available_balance"];
            _currentMoney = balanceValue;
            if (isApper) {
                _yueContent.text = _currentMoney;
            } else {
                [self setUpLayout];
            }
            [SVProgressHUD dismiss];
        }
    }];
}

/* 确认充值 */
- (void)submitAction {
    NSString *inputMoney = _rechargeLab.text;
    CGFloat money = [inputMoney floatValue];
    if (money>0) {
        [SVProgressHUD showWithStatus:@"加载中"];
        NetManager *manager = [[NetManager alloc] init];
        [manager postDataWithUrlActionStr:@"Trade/new_deposit" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"money":_rechargeLab.text,} withBlock:^(id obj) {
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
    } else {
        [SVProgressHUD showInfoWithStatus:@"充值金额必须大于0"];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RechargeViewController"];
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
