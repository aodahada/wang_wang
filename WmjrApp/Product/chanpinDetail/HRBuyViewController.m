//
//  HRBuyViewController.m
//  WmjrApp
//
//  Created by huorui on 16/8/15.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "HRBuyViewController.h"
#import "AgViewController.h"
#import "BaseNavigationController.h"
#import "WebViewForPayViewController.h"
#import "ProductModel.h"
#import "InvestConfirmView.h"
#import "MMPopupItem.h"
#import "RechargeViewController.h"
#import "LongProductSegment.h"
#import "RedPackageViewController.h"
#import "RedPackageModel.h"

@interface HRBuyViewController ()<RedPackageVCDelegate>

//@property (weak, nonatomic) IBOutlet UIImageView *imageViewForTitle;//标题图片
//@property (weak, nonatomic) IBOutlet UILabel *labelForTitle;//标题名称
@property (weak, nonatomic) IBOutlet UILabel *hongbaoLabel;//红包label
@property (weak, nonatomic) IBOutlet UIButton *hongbaoButton;

@property (weak, nonatomic) IBOutlet UILabel *labelForMoney;//收益金额
@property (weak, nonatomic) IBOutlet UILabel *labelForYearRate;//预期年化率
@property (weak, nonatomic) IBOutlet UILabel *labelForGetLimit;//持有期限
@property (weak, nonatomic) IBOutlet UILabel *labelForRaiseSum;//融资总额
@property (weak, nonatomic) IBOutlet UILabel *labelForSetDate;//结算日期
@property (weak, nonatomic) IBOutlet UITextField *textFieldForBuy;//买入金额
@property (weak, nonatomic) IBOutlet UILabel *labelForSurplus;//当前剩余金额
@property (weak, nonatomic) IBOutlet UIButton *buttonForConfirm;
@property (nonatomic, copy) NSString *personalYuEStr;//个人余额
@property (nonatomic, strong) UIView *viewForBack;//背景View;
@property (nonatomic, strong) UITapGestureRecognizer *tapGes;
@property (nonatomic, strong) InvestConfirmView *investConfirmView;
@property (nonatomic, copy) NSString *redPackageId;//红包id
@property (nonatomic, copy)NSString *red_low_buy;//红包最低购买值

@end

@implementation HRBuyViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"HRBuyViewController"];
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"购买金额";
    _buttonForConfirm.userInteractionEnabled = YES;
    _redPackageId = @"0";
    _red_low_buy = @"";
    
//    NSString *type_id = _productModel.type_id;
//    if ([type_id isEqualToString:@"1"]) {
//        _imageViewForTitle.image = [UIImage imageNamed:@"icon_qtl"];
//    } else if ([type_id isEqualToString:@"2"]) {
//        _imageViewForTitle.image = [UIImage imageNamed:@"icon_wsx"];
//    } else {
//        _imageViewForTitle.image = [UIImage imageNamed:@"icon_yft"];
//    }
//    
//    _labelForTitle.text = _productModel.name;
    
    
    //    NSNumberFormatter *hereNumFormatter = [[NSNumberFormatter alloc] init];
    //    [hereNumFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    //    hereNumFormatter.maximumFractionDigits = 2;
    //    NSString *str = [hereNumFormatter stringFromNumber:[NSNumber numberWithDouble:0.3358]];// 0.3358转33.58%
    LongProductSegment *longProductSegment = _productModel.segment[0];
    CGFloat returnRate = [longProductSegment.returnrate floatValue];
    
    _labelForYearRate.text = [NSString stringWithFormat:@"预期年化率%.2f%%",returnRate*100];
    
    _labelForGetLimit.text = [NSString stringWithFormat:@"持有期限%@天",longProductSegment.duration];
    
    //    _labelForRaiseSum.text = [NSString stringWithFormat:@"融资总额￥%@",@"100000000.00"];
    NSString *endTime = [longProductSegment.segment_time substringToIndex:10];
    _labelForSetDate.text = [NSString stringWithFormat:@"结算日期%@",endTime];
    
    _textFieldForBuy.placeholder = [NSString stringWithFormat:@"建议购买金额%@元以上",_productModel.lowpurchase];
    [_textFieldForBuy addTarget:self action:@selector(configGuessMoneyMethod) forControlEvents:UIControlEventEditingChanged];
    
    NSString *newBalance = [[SingletonManager sharedManager] getQianWeiFenGeFuString:longProductSegment.can_buy];
    _labelForSurplus.text = [NSString stringWithFormat:@"产品可购余额%@元",newBalance];
    
//    [_hongbaoButton addTarget:self action:@selector(jumpToRedPackageVC) forControlEvents:UIControlEventTouchUpInside];
    [self getRedPackMethod];
    
}

#pragma mark - 红包按钮
- (void)jumpToRedPackageVC {
    RedPackageViewController *redPackageVC = [[RedPackageViewController alloc]init];
    redPackageVC.delegate = self;
    redPackageVC.productId = _productModel.proIntro_id;
    [self.navigationController pushViewController:redPackageVC animated:YES];
}

#pragma mark - 获取红包信息
- (void)getRedPackMethod {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Redpacket/my" withParamDictionary:@{@"member_id":@"90221",@"status":@"2",@"product_id":_productModel.proIntro_id} withBlock:^(id obj) {
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                NSArray *dataArray = obj[@"data"];
                if (dataArray.count == 0) {
                    _hongbaoLabel.text = @"没有可使用的红包";
                    [_hongbaoButton addTarget:self action:@selector(nibName) forControlEvents:UIControlEventTouchUpInside];
                } else {
                    _hongbaoLabel.text = @"有可使用的红包";
                    [_hongbaoButton addTarget:self action:@selector(jumpToRedPackageVC) forControlEvents:UIControlEventTouchUpInside];
                }
                [SVProgressHUD dismiss];
                return ;
            } else {
                NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
                alertConfig.defaultTextOK = @"确定";
                [SVProgressHUD dismiss];
                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
                [alertView show];
            }
        }
    }];
}

#pragma mark - 计算预计收益
- (void)configGuessMoneyMethod {
    LongProductSegment *longProductSegment = _productModel.segment[0];
    CGFloat returnRate = [longProductSegment.returnrate floatValue];
    CGFloat day = [longProductSegment.duration floatValue];
    CGFloat buyMoney = [_textFieldForBuy.text floatValue];
    CGFloat sumRaise = buyMoney*returnRate*day/365;
    _labelForMoney.text = [NSString stringWithFormat:@"%.2f",sumRaise];
}

#pragma mark - 获取当前余额
- (void)getCurrentRest {
    
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"User/queryBalance" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"account_type":@"SAVING_POT"} withBlock:^(id obj) {
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                
                NSDictionary *dataDic = obj[@"data"];
                self.personalYuEStr = dataDic[@"balance"];
                
                _investConfirmView = [[InvestConfirmView alloc]initWithInvestMoney:_textFieldForBuy.text restMoney:_personalYuEStr];
                @weakify(self)
                _investConfirmView.closeViewMethod = ^(){
                    @strongify(self)
                    [self tapGesMethod];
                };
                _investConfirmView.jumToReadDelegate = ^(){
                    @strongify(self)
                    [self watchDelegateMethod];
                };
                _investConfirmView.buttonNextMethod = ^(BOOL canPay){
                    @strongify(self)
                    if (canPay) {
                        [self useInterfaceForPay];
                    } else {
                        MMPopupItemHandler block = ^(NSInteger index){
                            if (index == 0) {
                                return ;
                            }
                            if (index == 1) {
                                [self tapGesMethod];
                                /*  充值 */
                                RechargeViewController *rechangeVC = [[RechargeViewController alloc] init];
                                rechangeVC.isPayJump = @"yes";
                                [self.navigationController pushViewController:rechangeVC animated:YES];
                                return;
                            }
                        };
                        NSArray *items =
                        @[MMItemMake(@"取消", MMItemTypeNormal, block),
                          MMItemMake(@"确定", MMItemTypeNormal, block)];
                        MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
                                                                             detail:@"您的余额不足，请先去充值"
                                                                              items:items];
                        [alertView show];
                    }
                };
                [self.view addSubview:_investConfirmView];
                [_investConfirmView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view.mas_bottom);
                    make.height.mas_offset(319);
                    make.left.equalTo(self.view.mas_left);
                    make.right.equalTo(self.view.mas_right);
                }];
                
                _viewForBack = [[UIView alloc]init];
                _viewForBack.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.36];
                [self.view addSubview:_viewForBack];
                [_viewForBack mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view.mas_top);
                    make.left.equalTo(self.view.mas_left);
                    make.right.equalTo(self.view.mas_right);
                    make.bottom.equalTo(_investConfirmView.mas_top);
                }];
                
                _tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesMethod)];
                [_viewForBack addGestureRecognizer:_tapGes];

                
                [SVProgressHUD dismiss];
                return ;
            } else {
                NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
                alertConfig.defaultTextOK = @"确定";
                [SVProgressHUD dismiss];
                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
                [alertView show];
            }
        }
    }];
    
}

#pragma mark - 确认支付按钮
- (IBAction)buttonForConfirmMethod:(id)sender {
    
    [_textFieldForBuy resignFirstResponder];
    if ([_textFieldForBuy.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请输入投资金额"];
        return;
    }
    float investMoney = [_textFieldForBuy.text floatValue];
    float lowMoney = [_productModel.lowpurchase floatValue];
    if (investMoney<lowMoney) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"该产品起购金额为%@元",_productModel.lowpurchase]];
        return;
    }
    
    float redLowMoney = [_red_low_buy floatValue];
    if (investMoney<redLowMoney) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"该红包起购金额为%@元",_red_low_buy]];
        return;
    }
    
    //获取当前余额
    [self getCurrentRest];
    
}

#pragma mark - 支付接口调用
- (void)useInterfaceForPay {
    NetManager *manager = [[NetManager alloc] init];
    LongProductSegment *longSegPro = _productModel.segment[0];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Finance/order" withParamDictionary:@{@"member_id":@"90221", @"product_id":_productModel.proIntro_id,@"segment_id":longSegPro.segment_id,@"money":_textFieldForBuy.text,@"returnrate":longSegPro.returnrate,@"redpacket_member_id":_redPackageId} withBlock:^(id obj) {
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                NSDictionary *dataDic = obj[@"data"];
                WebViewForPayViewController *webViewForPayVC = [[WebViewForPayViewController alloc]initWithNibName:@"WebViewForPayViewController" bundle:nil];
                webViewForPayVC.htmlString = dataDic[@"html"];
                webViewForPayVC.title = @"支付界面";
                [self.navigationController pushViewController:webViewForPayVC animated:YES];
                [SVProgressHUD dismiss];
                return ;
            } else {
                NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
                alertConfig.defaultTextOK = @"确定";
                [SVProgressHUD dismiss];
                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
                [alertView show];
            }
        }
    }];
}

- (void)tapGesMethod {
    [_viewForBack removeFromSuperview];
    [_viewForBack removeGestureRecognizer:_tapGes];
    _tapGes = nil;
    _viewForBack = nil;
    [_investConfirmView removeFromSuperview];
    _investConfirmView = nil;
}

#pragma mark - 查看合同
- (void)watchDelegateMethod{
    
    AgViewController *agVC =[[AgViewController alloc] init];
//    BaseNavigationController *baseNa = [[BaseNavigationController alloc] initWithRootViewController:agVC];
    agVC.title = @"交易协议";
    agVC.webUrl = @"http://api.wmjr888.com/home/page/app/id/11";
    [self.navigationController pushViewController:agVC animated:YES];
//    [self presentViewController:baseNa animated:YES completion:^{
//    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"HRBuyViewController"];
    [_textFieldForBuy resignFirstResponder];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_textFieldForBuy resignFirstResponder];
    
}

#pragma mark - RedPackageVCDelegate方法
- (void)selecNoRedPackage {
    _hongbaoLabel.text = @"不使用红包";
    _hongbaoLabel.textColor = RGBA(255, 88, 26, 1.0);
    _redPackageId = @"0";
    _red_low_buy = @"";
}

- (void)selectRedPackage:(RedPackageModel *)redPackageModel {
    _hongbaoLabel.text = [NSString stringWithFormat:@"%@¥%@",redPackageModel.name,redPackageModel.money];
    _hongbaoLabel.textColor = RGBA(255, 88, 26, 1.0);
    _redPackageId = redPackageModel.redpacket_member_id;
    _red_low_buy = redPackageModel.low_use;
    
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
