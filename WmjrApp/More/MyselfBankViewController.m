//
//  MyselfBankViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/11/24.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "MyselfBankViewController.h"
#import "MMPopupItem.h"
#import "MMPopupWindow.h"

@interface MyselfBankViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bankNameImg;  /* 银行名称图片 */
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab; /* 银行名称和尾号 */
@property (weak, nonatomic) IBOutlet UILabel *holdBankLab; /* 持卡人 */

@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;  /* 确定 */
- (IBAction)comfirmBtnAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *unbindBtn;
- (IBAction)unbindAction:(id)sender;  /* 解绑银行卡 */

@property (nonatomic, copy) NSString *myBalance;  /* 我的余额 */
@property (nonatomic, copy) NSString *mySavin_pot;   /* 我的存钱罐 */

@property (nonatomic, strong) NSMutableArray *bankInfoArray;  /* 银行卡信息数组 */
@property (nonatomic, strong) UIBarButtonItem *button;

@end

@implementation MyselfBankViewController



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)setUpNavigationBar {
    self.view.backgroundColor = VIEWBACKCOLOR;
    
    UIImage *image = [[UIImage imageNamed:@"arrow_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [[MMPopupWindow sharedWindow] cacheWindow];
    self.title = @"我的银行卡";
    _comfirmBtn.backgroundColor = BASECOLOR;
    [_comfirmBtn setTitleColor:VIEWBACKCOLOR forState:UIControlStateNormal];
    
}

- (void)backClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
//    self.title = @"我的银行卡";
    self.view.backgroundColor = RGBA(237, 238, 242, 1.0);
    _bankInfoArray = [NSMutableArray array];
    
    /* 获取数据 */
    [self loadRequestData];
}

/* 获取绑定银行卡信息 */
- (void)loadRequestData {
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"Card/query" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSString *dataStr = obj[@"data"];
            dataStr = [self convertNullString:dataStr];
            if ([dataStr isEqualToString:@""]) {
//                NSLog(@"haha1");
            } else {
                NSArray *dataArray = [dataStr componentsSeparatedByString:@"^"];
                [_bankInfoArray addObjectsFromArray:dataArray];
                /* Card信息id ^银行编号 ^银行卡号 ^户名 ^卡类型 ^卡属性 ^VerifyMode是否是Sign ^创建时间 ^安全卡标识 */
                self.card_id = dataArray[0];
                NSDictionary *bankDic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"banks.plist" ofType:nil]];
                NSDictionary *dic = [bankDic objectForKey:@"bank"];
                /* 银行图标 */
                _bankNameImg.image = [UIImage imageNamed:_bankInfoArray[1]];
                /* 银行名称 */
                NSString *bankName = [[dic objectForKey:_bankInfoArray[1]] firstObject];
                /* 银行尾号 */
                NSString *bankNum = _bankInfoArray[2];
                NSString *bankTail = [bankNum substringWithRange:NSMakeRange(bankNum.length - 4, 4)];
                _bankNameLab.text = [NSString stringWithFormat:@"%@尾号%@", bankName, bankTail];
                /* 持卡人 */
                _holdBankLab.text = _bankInfoArray[3];
            }
        }
    }];
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

/* 解绑银行卡 */
- (IBAction)unbindAction:(id)sender {
    NetManager *manager = [[NetManager alloc] init];
    /* 余额不为零,不能解绑 */
//    [manager postDataWithUrlActionStr:@"User/queryBalance" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"account_type":@"SAVING_POT"} withBlock:^(id obj) {
//        if (obj) {
//            NSString *balanceValue = [obj[@"data"] objectForKey:@"available_balance"];
//            if ([balanceValue floatValue] > 0) {
//                [[SingletonManager sharedManager] alert1PromptInfo:@"余额不为零,不能解绑"];
//                return ;
//            }
//        }
//    }];
//    /* 存钱罐不为零,不能解绑 */
//    [manager postDataWithUrlActionStr:@"User/queryBalance" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"account_type":@"SAVING_POT"} withBlock:^(id obj) {
//        if (obj) {
//            NSString *balanceValue = [obj[@"data"] objectForKey:@"available_balance"];
//            if ([balanceValue floatValue] > 0) {
//                [[SingletonManager sharedManager] alert1PromptInfo:@"存钱罐不为零,不能解绑"];
//                return ;
//            }
//        }
//    }];
    /* 点击确定,可解绑银行卡 */
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 0) {
            return ;
        }
        if (index == 1) {
            NSMutableDictionary *paramMutableDic = [NSMutableDictionary dictionary];
            paramMutableDic[@"member_id"] = [SingletonManager sharedManager].uid;
            paramMutableDic[@"card_id"] = self.card_id;
            NSDictionary *paramDic = (NSDictionary *)paramMutableDic;
            [manager postDataWithUrlActionStr:@"Card/unbind" withParamDictionary:paramDic withBlock:^(id obj) {
                if ([obj[@"result"] isEqualToString:@"1"]) {
                    [SVProgressHUD showSuccessWithStatus:@"解绑成功" maskType:(SVProgressHUDMaskTypeNone)];
                    
                    [SingletonManager sharedManager].userModel.card_id = @"0";
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [[SingletonManager sharedManager] alert1PromptInfo:[obj[@"data"] objectForKey:@"mes"]];
                }
            }];
        }
    };
    NSArray *items =
    @[MMItemMake(@"取消", MMItemTypeNormal, block),
      MMItemMake(@"确定", MMItemTypeNormal, block)];
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
                                                         detail:@"你确定解绑绑定银行卡?"
                                                          items:items];
    [alertView show];
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
