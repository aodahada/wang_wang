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
#import "BankDetailViewController.h"
#import "ReleaseBankCardViewController.h"
#import "ReleaseCardDirectlyView.h"
#import "ReleaseCardApplyforView.h"
#import "ReleaseSuccessCardView.h"
#import "ReleaseBankCardModel.h"

@interface MyselfBankViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bankNameImg;  /* 银行名称图片 */
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab; /* 银行名称和尾号 */
@property (weak, nonatomic) IBOutlet UILabel *holdBankLab; /* 持卡人 */

@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;  /* 确定 */
- (IBAction)comfirmBtnAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *unbindBtn;

@property (nonatomic, copy) NSString *myBalance;  /* 我的余额 */
@property (nonatomic, copy) NSString *mySavin_pot;   /* 我的存钱罐 */

@property (nonatomic, strong) NSMutableArray *bankInfoArray;  /* 银行卡信息数组 */
@property (nonatomic, strong) UIBarButtonItem *button;
@property (weak, nonatomic) IBOutlet UIView *cardBottomView;

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, copy) NSString *bankName;//银行名称
@property (nonatomic, copy) NSString *bankNumberTrail;//银行卡尾号
@property (strong, nonatomic) UIButton *watchBankDetail;

@property (nonatomic, copy) NSString *bankCardState;//0 审核中，1 成功，2 失败

@property (nonatomic, strong) ReleaseBankCardModel *releaseBankCardModel;

@end

@implementation MyselfBankViewController



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MyselfBankViewController"];
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
    [MobClick endLogPageView:@"MyselfBankViewController"];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
//    self.title = @"我的银行卡";
    self.view.backgroundColor = RGBA(237, 238, 242, 1.0);
    _cardBottomView.layer.masksToBounds = YES;
    _cardBottomView.layer.cornerRadius = 10;
    _bankInfoArray = [NSMutableArray array];
    
    self.window = [[UIApplication sharedApplication].delegate window];
    /* 获取数据 */
    [self loadRequestData];
    
}

#pragma mark - 查看审核详情
- (void)watchBankState {
    ReleaseBankCardViewController *releaseBankCardViewVC = [[ReleaseBankCardViewController alloc]init];
    releaseBankCardViewVC.title = @"审核详情";
    releaseBankCardViewVC.releaseBankModel = _releaseBankCardModel;
    [self.navigationController pushViewController:releaseBankCardViewVC animated:YES];
}

- (IBAction)jumpToBankDetailMethod:(id)sender {
    
    BankDetailViewController *bankDeatailVC = [[BankDetailViewController alloc]init];
    [self.navigationController pushViewController:bankDeatailVC animated:YES];
    
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
                _bankName = bankName;
                /* 银行尾号 */
                NSString *bankNum = _bankInfoArray[2];
                NSString *bankTail = [bankNum substringWithRange:NSMakeRange(bankNum.length - 4, 4)];
                _bankNumberTrail = bankTail;
                _bankNameLab.text = [NSString stringWithFormat:@"%@尾号%@", bankName, bankTail];
                /* 持卡人 */
                _holdBankLab.text = _bankInfoArray[3];
                
            }
        }
        [self checkBankCardState];
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
- (void)unbindAction {
    NetManager *manager = [[NetManager alloc] init];
    /* 余额不为零,不能解绑 */
    [SVProgressHUD showWithStatus:@"请稍等"];
    [manager postDataWithUrlActionStr:@"User/queryBalance" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"account_type":@"SAVING_POT"} withBlock:^(id obj) {
        if (obj) {
            [SVProgressHUD dismiss];
            NSString *balanceValue = [obj[@"data"] objectForKey:@"available_balance"];
            if ([balanceValue floatValue] > 0) {
//                [[SingletonManager sharedManager] alert1PromptInfo:@"余额不为零,不能解绑"];
//                //余额不为0解绑银行卡的方式
                @weakify(self)
                ReleaseCardApplyforView *releaseCardApplyforView = [[ReleaseCardApplyforView alloc]init];
                releaseCardApplyforView.confirmRelease = ^(){
                    @strongify(self)
                    ReleaseBankCardViewController *releaseBankCardVC = [[ReleaseBankCardViewController alloc]init];
                    releaseBankCardVC.title = @"解绑银行卡";
                    [self.navigationController pushViewController:releaseBankCardVC animated:YES];
                };
                [self.window addSubview:releaseCardApplyforView];
                [releaseCardApplyforView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.window);
                }];
                
                return ;
            } else {
                /* 点击确定,可解绑银行卡 */
                
//                MMPopupItemHandler block = ^(NSInteger index){
//                    if (index == 0) {
//                        return ;
//                    }
//                    if (index == 1) {
//                        NSMutableDictionary *paramMutableDic = [NSMutableDictionary dictionary];
//                        paramMutableDic[@"member_id"] = [SingletonManager sharedManager].uid;
//                        paramMutableDic[@"card_id"] = self.card_id;
//                        NSDictionary *paramDic = (NSDictionary *)paramMutableDic;
//                        [manager postDataWithUrlActionStr:@"Card/unbind" withParamDictionary:paramDic withBlock:^(id obj) {
//                            if ([obj[@"result"] isEqualToString:@"1"]) {
//                                [SVProgressHUD showSuccessWithStatus:@"解绑成功" maskType:(SVProgressHUDMaskTypeNone)];
//
//                                [SingletonManager sharedManager].userModel.card_id = @"0";
//                                [[NSUserDefaults standardUserDefaults] synchronize];
//
//                                [self.navigationController popToRootViewControllerAnimated:YES];
//                            } else {
//                                [[SingletonManager sharedManager] alert1PromptInfo:[obj[@"data"] objectForKey:@"mes"]];
//                            }
//                        }];
//                    }
//                };
//                NSArray *items =
//                @[MMItemMake(@"取消", MMItemTypeNormal, block),
//                  MMItemMake(@"确定", MMItemTypeNormal, block)];
//                MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
//                                                                     detail:@"你确定解绑绑定银行卡?"
//                                                                      items:items];
//                [alertView show];
                
                ReleaseCardDirectlyView *releaseCardDirectView = [[ReleaseCardDirectlyView alloc]initWithBankName:_bankName withBankNumber:_bankNumberTrail];
                releaseCardDirectView.confirmRelease = ^(){
                    NSMutableDictionary *paramMutableDic = [NSMutableDictionary dictionary];
                    paramMutableDic[@"member_id"] = [SingletonManager sharedManager].uid;
                    paramMutableDic[@"card_id"] = self.card_id;
                    NSDictionary *paramDic = (NSDictionary *)paramMutableDic;
                    [SVProgressHUD showWithStatus:@"解绑中"];
                    [manager postDataWithUrlActionStr:@"Card/unbind" withParamDictionary:paramDic withBlock:^(id obj) {
                        if ([obj[@"result"] isEqualToString:@"1"]) {
                            [SVProgressHUD dismiss];
                            [SingletonManager sharedManager].userModel.card_id = @"0";
                            [[NSUserDefaults standardUserDefaults] synchronize];
//                            [[SingletonManager sharedManager] showHUDView:self.view title:@"解绑成功" content:@"" time:1.0 andCodes:^{
//                                [self.navigationController popToRootViewControllerAnimated:YES];
//                            }];
                            ReleaseSuccessCardView *releaseSuccessCardView = [[ReleaseSuccessCardView alloc]init];
                            releaseSuccessCardView.releaseSuccess = ^(){
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            };
                            [self.window addSubview:releaseSuccessCardView];
                            [releaseSuccessCardView mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.edges.equalTo(self.window);
                            }];
                        } else {
                            [[SingletonManager sharedManager] alert1PromptInfo:[obj[@"data"] objectForKey:@"mes"]];
                        }
                    }];
                };
                [self.window addSubview:releaseCardDirectView];
                [releaseCardDirectView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.window);
                }];
                
            }
        }
    }];
    
}

#pragma mark - 银行卡审核状态
- (void)checkBankCardState {
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"Bank/detail" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSDictionary *data = obj[@"data"];
            [ReleaseBankCardModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"release_id" : @"id"};
            }];
            
            _releaseBankCardModel = [ReleaseBankCardModel mj_objectWithKeyValues:data];
            _bankCardState = _releaseBankCardModel.status;
//            _bankCardState = @"4";
            if ([_bankCardState isEqualToString:@"0"]) {
                //审核中
                [_unbindBtn setTitle:@"审核中" forState:UIControlStateNormal];
                [_unbindBtn addTarget:self action:@selector(doNothingMethod) forControlEvents:UIControlEventTouchUpInside];
                UILabel *line1 = [[UILabel alloc]init];
                line1.text = @"解绑申请已经提交成功,原银行卡将在3个工";
                line1.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
                line1.textColor = RGBA(102, 102, 102, 1.0);
                [self.view addSubview:line1];
                [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_cardBottomView.mas_bottom).with.offset(RESIZE_UI(50));
                    make.centerX.equalTo(self.view.mas_centerX);
                }];
                
                UILabel *line2 = [[UILabel alloc]init];
                line2.text = @"作日内完成解绑，请耐心等待；如有疑问";
                line2.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
                line2.textColor = RGBA(102, 102, 102, 1.0);
                [self.view addSubview:line2];
                [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(line1.mas_bottom);
                    make.centerX.equalTo(self.view.mas_centerX);
                }];
                
                UILabel *line3 = [[UILabel alloc]init];
                line3.text = @"请联系客服热线:";
                line3.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
                line3.textColor = RGBA(102, 102, 102, 1.0);
                [self.view addSubview:line3];
                [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(line2.mas_bottom);
                    make.left.equalTo(line2.mas_left).with.offset(RESIZE_UI(20));
                }];
                
                UIButton *phoneButton = [[UIButton alloc]init];
                [phoneButton setTitle:@"400-600-1169" forState:UIControlStateNormal];
                [phoneButton setTitleColor:RGBA(0, 106, 179, 1.0) forState:UIControlStateNormal];
                phoneButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
                [phoneButton addTarget:self action:@selector(callPhoneMethod) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:phoneButton];
                [phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(line3.mas_centerY);
                    make.left.equalTo(line3.mas_right);
                }];
                
                _watchBankDetail = [[UIButton alloc]init];
                [_watchBankDetail setBackgroundColor:RGBA(255, 88, 26, 1.0)];
                [_watchBankDetail setTitle:@"查看详情" forState:UIControlStateNormal];
                [_watchBankDetail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _watchBankDetail.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
                [self.view addSubview:_watchBankDetail];
                [_watchBankDetail addTarget:self action:@selector(watchBankState) forControlEvents:UIControlEventTouchUpInside];
                [_watchBankDetail mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view.mas_bottom);
                    make.left.equalTo(self.view.mas_left);
                    make.right.equalTo(self.view.mas_right);
                    make.height.mas_offset(RESIZE_UI(49));
                }];
            } else if ([_bankCardState isEqualToString:@"1"]) {
                //审核成功
                NSLog(@"ww");
                
            } else if ([_bankCardState isEqualToString:@"2"]) {
                //审核驳回
                [_unbindBtn setTitle:@"审核驳回" forState:UIControlStateNormal];
                [_unbindBtn setTitleColor:RGBA(243, 51, 81, 1.0) forState:UIControlStateNormal];
                [_unbindBtn addTarget:self action:@selector(doNothingMethod) forControlEvents:UIControlEventTouchUpInside];
                _watchBankDetail = [[UIButton alloc]init];
                [_watchBankDetail setBackgroundColor:RGBA(255, 88, 26, 1.0)];
                [_watchBankDetail setTitle:@"查看详情" forState:UIControlStateNormal];
                [_watchBankDetail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _watchBankDetail.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
                [self.view addSubview:_watchBankDetail];
                [_watchBankDetail addTarget:self action:@selector(watchBankState) forControlEvents:UIControlEventTouchUpInside];
                [_watchBankDetail mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view.mas_bottom);
                    make.left.equalTo(self.view.mas_left);
                    make.right.equalTo(self.view.mas_right);
                    make.height.mas_offset(RESIZE_UI(49));
                }];
            } else {
                [_unbindBtn setTitle:@"解绑银行卡" forState:UIControlStateNormal];
                [_unbindBtn addTarget:self action:@selector(unbindAction) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }];
}

#pragma mark - 替代方法
- (void)doNothingMethod {
    NSLog(@"啥也不干");
}

#pragma mark - 打电话
- (void)callPhoneMethod {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"400-600-1169"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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
