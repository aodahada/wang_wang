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

@interface HRBuyViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewForTitle;//标题图片
@property (weak, nonatomic) IBOutlet UILabel *labelForTitle;//标题名称
@property (weak, nonatomic) IBOutlet UILabel *labelForYearRate;//预期年化率
@property (weak, nonatomic) IBOutlet UILabel *labelForGetLimit;//持有期限
@property (weak, nonatomic) IBOutlet UILabel *labelForRaiseSum;//融资总额
@property (weak, nonatomic) IBOutlet UILabel *labelForSetDate;//结算日期
@property (weak, nonatomic) IBOutlet UITextField *textFieldForBuy;//买入金额
@property (weak, nonatomic) IBOutlet UILabel *labelForSurplus;//当前剩余金额
@property (weak, nonatomic) IBOutlet UIButton *buttonForConfirm;
@property (weak, nonatomic) IBOutlet UIButton *buttonForIsAgree;//是否同意协议按钮
@property (weak, nonatomic) IBOutlet UIButton *buttonForDelegate;//产看合同按钮

@property (nonatomic, assign) BOOL isAgree;//是否同意协议标识

@end

@implementation HRBuyViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    //获取当前余额
    [self getCurrentRest];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"购买金额";
    _isAgree = YES;
    _buttonForConfirm.userInteractionEnabled = YES;
    
    NSString *type_id = _productModel.type_id;
    if ([type_id isEqualToString:@"1"]) {
        _imageViewForTitle.image = [UIImage imageNamed:@"icon_qtl"];
    } else if ([type_id isEqualToString:@"2"]) {
        _imageViewForTitle.image = [UIImage imageNamed:@"icon_wsx"];
    } else {
        _imageViewForTitle.image = [UIImage imageNamed:@"icon_yft"];
    }
    
    _labelForTitle.text = _productModel.name;
    
    CGFloat returnRate = [_productModel.returnrate floatValue];
    
    //    NSNumberFormatter *hereNumFormatter = [[NSNumberFormatter alloc] init];
    //    [hereNumFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    //    hereNumFormatter.maximumFractionDigits = 2;
    //    NSString *str = [hereNumFormatter stringFromNumber:[NSNumber numberWithDouble:0.3358]];// 0.3358转33.58%
    
    _labelForYearRate.text = [NSString stringWithFormat:@"预期年化率%.2f%%",returnRate*100];
    
    _labelForGetLimit.text = [NSString stringWithFormat:@"持有期限%@天",_productModel.day];
    
    //    _labelForRaiseSum.text = [NSString stringWithFormat:@"融资总额￥%@",@"100000000.00"];
    
    _labelForSetDate.text = [NSString stringWithFormat:@"结算日期%@",_productModel.expirydate];
    
    _textFieldForBuy.placeholder = [NSString stringWithFormat:@"建议购买金额%@元以上",_productModel.lowpurchase];
    
}

#pragma mark - 获取当前余额
- (void)getCurrentRest {
    
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"User/queryBalance" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"account_type":@"SAVING_POT"} withBlock:^(id obj) {
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                
                NSDictionary *dataDic = obj[@"data"];
                _labelForSurplus.text = [NSString stringWithFormat:@"当前剩余金额%@元",dataDic[@"balance"]];
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
    
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Trade/new_collect" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"product_id":_productModel.proIntro_id,@"product_name":_productModel.name,@"money":_textFieldForBuy.text} withBlock:^(id obj) {
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
//            if ([obj[@"result"] isEqualToString:@"1000"]) {
//                NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
//                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
//                alertConfig.defaultTextOK = @"确定";
//                [SVProgressHUD dismiss];
//                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
//                [alertView show];
//            }
        }
    }];
    
}

#pragma mark - 是否同意协议按钮
- (IBAction)buttonForIsAgreeMethod:(id)sender {
    
    if (!_isAgree) {
        
        _isAgree = YES;
        [_buttonForIsAgree setBackgroundImage:[UIImage imageNamed:@"icon_dagou"] forState:UIControlStateNormal];
        _buttonForConfirm.userInteractionEnabled = YES;
        [_buttonForConfirm setBackgroundColor:RGBA(243, 40, 0, 1.0)];
        
    } else {
        
        _isAgree = NO;
        [_buttonForIsAgree setBackgroundImage:[UIImage imageNamed:@"icon_round_nor"] forState:UIControlStateNormal];
        _buttonForConfirm.userInteractionEnabled = NO;
        [_buttonForConfirm setBackgroundColor:RGBA(201, 201, 201, 1.0)];
        
    }
    
}

#pragma mark - 查看合同
- (IBAction)watchDelegateMethod:(id)sender {
    
    AgViewController *agVC =[[AgViewController alloc] init];
    BaseNavigationController *baseNa = [[BaseNavigationController alloc] initWithRootViewController:agVC];
    agVC.title = @"交易协议";
    agVC.webUrl = @"http://api.wmjr888.com/home/page/app/id/11";
    [self presentViewController:baseNa animated:YES completion:^{
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [_textFieldForBuy resignFirstResponder];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_textFieldForBuy resignFirstResponder];
    
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
