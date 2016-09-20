//
//  OpenFastPaymentController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/11/18.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "OpenFastPaymentController.h"
#import <MMPopupItem.h>
#import <MMSheetView.h>
#import "PopMenu.h"
#import "ComfirmFastPayView.h"
#import "MMPopupWindow.h"
#import "ZHPickView.h"
#import "AgreementViewController.h"
#import "UserInfoModel.h"

@interface OpenFastPaymentController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cardHoldField; /* 持卡人姓名 */
@property (weak, nonatomic) IBOutlet UITextField *bankCardField; /* 银行卡号 */
@property (weak, nonatomic) IBOutlet UILabel *bankName;   /* 银行名称 */
@property (weak, nonatomic) IBOutlet UILabel *proCityField;  /* 省份城市 */
- (IBAction)bankNameTap:(id)sender;
- (IBAction)proCityFieldTap:(UITapGestureRecognizer *)sender;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumField; /* 预留手机号 */

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
- (IBAction)checkBtnAction:(id)sender;/*  图标按钮 */
@property (weak, nonatomic) IBOutlet UIButton *acceptAgreeBtn;
- (IBAction)acceptAgreeBtnAction:(id)sender;/* 协议 */
@property (weak, nonatomic) IBOutlet UIButton *confirmOpenBtn;
- (IBAction)confirmOpenBtnAction:(id)sender; /* 确认开通 */

@property (nonatomic, strong) PopMenu *popMenu;

@property (nonatomic, copy) NSString *bank_codeStr;  /* 银行代码 */
@property (nonatomic, copy) NSString *provinceStr;  /* 省份 */
@property (nonatomic, copy) NSString *cityStr;  /* 城市 */
@property (nonatomic, copy) NSString *ticket;  /* 标示 */

@end

@implementation OpenFastPaymentController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    self.transferModel.price = 100000;
}

// test
//-(void)createSmart{
//    UIButton *smartButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [smartButton addTarget:self action:@selector(sdkjfhasdk) forControlEvents:UIControlEventTouchUpInside];
//    smartButton.frame = CGRectMake(100, 100, 100, 100);
//    smartButton.backgroundColor = [UIColor redColor];
//    [self.view addSubview:smartButton];
//}

//-(void)sdkjfhasdk{
//    self.smartManager(45634563546);
//    [self.navigationController popViewControllerAnimated: YES];
//}

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开通快捷支付";
    [[MMPopupWindow sharedWindow] cacheWindow];
    _confirmOpenBtn.backgroundColor = BASECOLOR;
    
    _bankCardField.delegate = self;
    
    /* 初始化 */
    _bank_codeStr = nil;
    _provinceStr = nil;
    _cityStr  =nil;
    _ticket = nil;
//    [self createSmart];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

/* 接受协议 */
- (IBAction)acceptAgreeBtnAction:(id)sender {
    MMPopupItemHandler block = ^(NSInteger index){
        AgreementViewController *agreeVC = [[AgreementViewController alloc] init];
        if (index == 0) {
            agreeVC.title = @"新浪支付快捷支付服务协议";
            agreeVC.selectIndex = @"0";
        }
        if (index == 1) {
            agreeVC.title = @"汇添富基金服务协议";
            agreeVC.selectIndex = @"1";
        }
        if (index == 2) {
            agreeVC.title = @"快速取现协议";
            agreeVC.selectIndex = @"2";
        }
        if (index == 3) {
            agreeVC.title = @"存钱罐服务协议";
            agreeVC.selectIndex = @"3";
        }
        if (index == 4) {
            agreeVC.title = @"新浪支付用户协议";
            agreeVC.selectIndex = @"4";
        }
        [self.navigationController pushViewController:agreeVC animated:YES];
    };
    MMPopupBlock completeBlock = ^(MMPopupView *popupView){
    };
    NSArray *items =
    @[MMItemMake(@"新浪支付快捷支付服务协议", MMItemTypeNormal, block),
      MMItemMake(@"汇添富基金服务协议", MMItemTypeNormal, block),
      MMItemMake(@"快速取现协议", MMItemTypeNormal, block),
      MMItemMake(@"存钱罐服务协议", MMItemTypeNormal, block),
      MMItemMake(@"新浪支付用户协议", MMItemTypeNormal, block)];
    [[[MMSheetView alloc] initWithTitle:nil
                                  items:items] showWithBlock:completeBlock];
    
}

/*  确认开通 */
- (IBAction)confirmOpenBtnAction:(id)sender {
    /* 判断输入框不可空 */
    if (![self checkResult]) {
        return;
    }
    
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
    fastPay.promptLab.text = @"开通快捷支付";
    NetManager *manager = [[NetManager alloc] init];
    fastPay.phoneTailLab.text = [NSString stringWithFormat:@"输入手机尾号%@接受的验证码", [_phoneNumField.text substringFromIndex:7]];
//    NSDictionary *paramDic4 = @{@"member_id":[SingletonManager sharedManager].uid};
//    [manager postDataWithUrlActionStr:@"User/que" withParamDictionary:paramDic4 withBlock:^(id obj) {
//        if (obj) {
//            UserInfoModel *model = [[UserInfoModel alloc] init];
//            [model setValuesForKeysWithDictionary:obj[@"data"]];
//            /* 手机尾号 */
//            NSString *phoneBind = model.mobile_bind;
//            
//        }
//    }];

    [fastPay callBtnClickEventBlock:^(UIButton *sender) {
        if (sender.tag == 1000) {
            /* 获取验证码 */
            [manager postDataWithUrlActionStr:@"Card/bind" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"bank_code":_bank_codeStr, @"bank_account_no":_bankCardField.text, @"card_attribute":@"C", @"province":_provinceStr, @"city":_cityStr, @"mobile":_phoneNumField.text} withBlock:^(id obj) {
                if ([obj[@"result"] isEqualToString:@"1"]) {
                    _ticket = [obj[@"data"] objectForKey:@"ticket"];
                } else {
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
            /* 验证验证码 */
            if ([fastPay.vercerNumField.text isEqualToString:@""]) {
                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
                alertConfig.defaultTextOK = @"确定";
                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"请输入验证码"];
                [alertView show];
                return;
            }
            [SVProgressHUD showWithStatus:@"正在绑卡" maskType:(SVProgressHUDMaskTypeNone)];
            [manager postDataWithUrlActionStr:@"Card/advance" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"valid_code":fastPay.vercerNumField.text, @"ticket":_ticket} withBlock:^(id obj) {
                if ([obj[@"result"] isEqualToString:@"1"]) {
                    [_popMenu dismissMenu];
                    [SVProgressHUD showSuccessWithStatus:@"已开通快捷支付" maskType:(SVProgressHUDMaskTypeNone)];
                    NSString *card_id = [obj[@"data"] objectForKey:@"card_id"];
                    
                    /* 开通快捷支付和绑定银行卡等同 */
                    [SingletonManager sharedManager].isCard_id = card_id;
                    [[NSUserDefaults standardUserDefaults] setObject:[SingletonManager sharedManager].isCard_id forKey:@"isCard_id"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
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

- (BOOL)checkResult {
    if ([_cardHoldField.text isEqualToString:@""]) {
        [[SingletonManager sharedManager] alert1PromptInfo:@"请输入持卡人姓名"];
        return NO;
    } else if ([_bankCardField.text isEqualToString:@""]) {
        [[SingletonManager sharedManager] alert1PromptInfo:@"请输入银行卡号"];
        return NO;
    } else if ([_bankName.text isEqualToString:@""]) {
        [[SingletonManager sharedManager] alert1PromptInfo:@"请选择银行卡名称"];
        return NO;
    } else if ([_proCityField.text isEqualToString:@""]) {
        [[SingletonManager sharedManager] alert1PromptInfo:@"请选择银行卡所在省市"];
        return NO;
    } else if ([_phoneNumField.text isEqualToString:@""]) {
        [[SingletonManager sharedManager] alert1PromptInfo:@"请输入银行预留手机号"];
        return NO;
    } else {
        return YES;
    }
}

/*  选择按钮 */
- (IBAction)checkBtnAction:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 4;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 15;
    } else {
        return 5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1;
}

/* 点击选择银行名称 */
- (IBAction)bankNameTap:(id)sender {
    [_bankCardField resignFirstResponder];
    ZHPickView *pickView = [[ZHPickView alloc] init];
    [pickView setBankViewWithItem:@[@"ABC-农业银行", @"BOC-中国银行", @"BOS-上海银行", @"HXB-华夏银行", @"CCB-建设银行", @"ICBC-工商银行", @"CEB-光大银行", @"CIB-兴业银行", @"PSBC-中国邮储银行", @"CITIC-中信银行", @"CMB-招商银行", @"CMBC-民生银行", @"SZPAB-平安银行", @"GDB-广东发展银行"] title:@"银行名称"];
    [pickView showPickView:self];
    pickView.block = ^(NSString *selectedStr)
    {
        NSArray *bankArray = [selectedStr componentsSeparatedByString:@"-"];
        _bank_codeStr = [bankArray firstObject];
        _bankName.textColor = [UIColor blackColor];
        _bankName.text = [bankArray lastObject];
    };
}

/* 点击选择银行省份城市 */
- (IBAction)proCityFieldTap:(UITapGestureRecognizer *)sender {
    [_bankCardField resignFirstResponder];
    ZHPickView *pickView = [[ZHPickView alloc] init];
    [pickView setAddressViewWithTitle:@"选择:省份-城市"];
    [pickView showPickView:self];
    pickView.block = ^(NSString *selectedStr)
    {
        NSArray *bankArray = [selectedStr componentsSeparatedByString:@"-"];
        _provinceStr = [bankArray firstObject];
        _cityStr = [bankArray lastObject];
        _proCityField.textColor = [UIColor blackColor];
        _proCityField.text = selectedStr;
    };
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
