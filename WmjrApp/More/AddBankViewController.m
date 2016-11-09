//
//  AddBankViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/11/24.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "AddBankViewController.h"
#import "MyselfBankViewController.h"
#import "ZHPickView.h"

@interface AddBankViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _count;
//    NSTimer *_timer;
}

@property (weak, nonatomic) IBOutlet UITextField *holdCardField; /* 持卡人 */
@property (weak, nonatomic) IBOutlet UITextField *bankNumField; /* 银行卡号 */
@property (weak, nonatomic) IBOutlet UITextField *phoneNumField; /*  手机号码 */

@property (weak, nonatomic) IBOutlet UILabel *bankNameField; /* 银行名称 */
@property (weak, nonatomic) IBOutlet UILabel *bank_PC;  /* 银行卡所在省市 */
- (IBAction)bankNameTap:(UITapGestureRecognizer *)sender;
- (IBAction)bank_PCTap:(UITapGestureRecognizer *)sender;


@property (weak, nonatomic) IBOutlet UITextField *yanzhengNum; /* 输入验证码 */
@property (weak, nonatomic) IBOutlet UIButton *yanzhengBtn;/*  获取验证码 */
- (IBAction)yanzhengBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *nextLab; /*  下一步 */

@property (nonatomic, copy) NSString *bank_codeStr;  /* 银行代码 */
@property (nonatomic, copy) NSString *provinceStr;  /* 省份 */
@property (nonatomic, copy) NSString *cityStr;  /* 城市 */
@property (nonatomic, copy) NSString *ticket;  /* 绑卡时返回字段 */

@end

@implementation AddBankViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)setUpNavigationBar {
    self.title = @"添加银行卡";
    _yanzhengBtn.backgroundColor = BASECOLOR;
    _yanzhengBtn.layer.cornerRadius = 10;
    _yanzhengBtn.layer.masksToBounds = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    
    /*  初始化 */
    _bank_codeStr = nil;
    _provinceStr = nil;
    _cityStr  =nil;
    _ticket = nil;
    
    [_bankNumField addTarget:self action:@selector(limitedNumberOfWords) forControlEvents:(UIControlEventEditingChanged)];
    [_phoneNumField addTarget:self action:@selector(limitedNumberOfWords) forControlEvents:(UIControlEventEditingChanged)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)limitedNumberOfWords {
    
    if (_phoneNumField.text.length >= 11) {
        _phoneNumField.text = [_phoneNumField.text substringToIndex:11];
    }
    if (_bankNumField.text.length > 19) {
        _bankNumField.text = [_bankNumField.text substringToIndex:19];
    }
}

/*  获取验证码 */
- (IBAction)yanzhengBtnAction:(id)sender {
    if ([self checkResult]) {
        _yanzhengBtn.enabled = NO;
        __block int timeout = 60; //倒计时时间
        __weak typeof(self) weakSelf = self;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [strongSelf.yanzhengBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
                        [strongSelf.yanzhengBtn setTitleColor:AUXILY_COLOR forState:UIControlStateNormal];
                        strongSelf.yanzhengBtn.enabled = YES;
                    });
                }else{
                    int seconds = timeout % 60;
                    if (timeout == 60) {
                        seconds = 60;
                    }
                    NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重发", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [strongSelf.yanzhengBtn setTitle:strTime forState:(UIControlStateNormal)];
                        [strongSelf.yanzhengBtn setTitleColor:AUXILY_COLOR forState:UIControlStateNormal];
                    });
                    timeout--;
                }

            }
        });
        dispatch_resume(_timer);
        
        NetManager *manager = [[NetManager alloc] init];
        [SVProgressHUD showWithStatus:@"请稍后"];
        [manager postDataWithUrlActionStr:@"Card/bind" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"bank_code":_bank_codeStr, @"bank_account_no":_bankNumField.text, @"card_attribute":@"C", @"province":_provinceStr, @"city":_cityStr, @"mobile":_phoneNumField.text} withBlock:^(id obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
//                [_yanzhengBtn setTitleColor:AUXILY_COLOR forState:UIControlStateNormal];
//                _count = 60;
//                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTimeAction) userInfo:nil repeats:YES];
                
                _ticket = [obj[@"data"] objectForKey:@"ticket"];
                [SVProgressHUD dismiss];
            } else {
                NSString *mes = [obj[@"data"] objectForKey:@"mes"];
                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
                alertConfig.defaultTextOK = @"确定";
                [SVProgressHUD dismiss];
                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:mes];
                [alertView show];
            }
        }];
    }
}

- (BOOL)checkResult {
    if ([_holdCardField.text isEqualToString:@""]) {
        [[SingletonManager sharedManager] alert1PromptInfo:@"请输入持卡人姓名"];
        return NO;
    } else if ([_bankNumField.text isEqualToString:@""]) {
        [[SingletonManager sharedManager] alert1PromptInfo:@"请输入银行卡号"];
        return NO;
    } else if ([_bankNameField.text isEqualToString:@""]) {
        [[SingletonManager sharedManager] alert1PromptInfo:@"请选择银行卡名称"];
        return NO;
    } else if ([_bank_PC.text isEqualToString:@""]) {
        [[SingletonManager sharedManager] alert1PromptInfo:@"请选择银行卡所在省市"];
        return NO;
    } else if ([_phoneNumField.text isEqualToString:@""]) {
        [[SingletonManager sharedManager] alert1PromptInfo:@"请输入银行预留手机号"];
        return NO;
    } else {
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    } else {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (![[SingletonManager sharedManager].userModel.card_id isEqualToString:@"0"]) {
            return;
        }
        if ([_yanzhengNum.text isEqualToString:@""]) {
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"验证码不可为空"];
            [alertView show];
            return;
        }
        /* 下一步 */
        NetManager *manager = [[NetManager alloc] init];
        [SVProgressHUD showWithStatus:@"正在绑卡" maskType:(SVProgressHUDMaskTypeNone)];
        [manager postDataWithUrlActionStr:@"Card/advance" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"valid_code":_yanzhengNum.text, @"ticket":_ticket} withBlock:^(id obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                [SVProgressHUD showSuccessWithStatus:@"银行卡绑定成功" maskType:(SVProgressHUDMaskTypeNone)];
                NSString *card_id = [obj[@"data"] objectForKey:@"card_id"];
                [SingletonManager sharedManager].userModel.card_id = card_id;
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                MyselfBankViewController *myselfBankVC = [[MyselfBankViewController alloc] init];
                myselfBankVC.card_id = card_id;  /* 钱包系统卡ID */
                [self.navigationController pushViewController:myselfBankVC animated:YES];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *aView = [[UIView alloc] init];
        UILabel *aLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
        aLable.text = @"请绑定持卡人本人的银行卡";
        aLable.textColor = [UIColor blackColor];
        aLable.font = [UIFont systemFontOfSize:13.0f];
        [aView addSubview:aLable];
        
        return aView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1;
}

- (IBAction)bankNameTap:(UITapGestureRecognizer *)sender {
    [_bankNumField resignFirstResponder];
    ZHPickView *pickView = [[ZHPickView alloc] init];
    [pickView setBankViewWithItem:@[@"ABC-农业银行", @"BOC-中国银行", @"BOS-上海银行", @"HXB-华夏银行", @"CCB-建设银行", @"ICBC-工商银行", @"CEB-光大银行", @"CIB-兴业银行", @"PSBC-中国邮储银行", @"CITIC-中信银行", @"CMB-招商银行", @"CMBC-民生银行", @"SZPAB-平安银行", @"GDB-广东发展银行"] title:@"银行名称"];
    [pickView showPickView:self];
    pickView.block = ^(NSString *selectedStr)
    {
        NSArray *bankArray = [selectedStr componentsSeparatedByString:@"-"];
        _bank_codeStr = [bankArray firstObject];
        _bankNameField.textColor = [UIColor blackColor];
        _bankNameField.text = [bankArray lastObject];
    };

}

- (IBAction)bank_PCTap:(UITapGestureRecognizer *)sender {
    [_phoneNumField resignFirstResponder];
    ZHPickView *pickView = [[ZHPickView alloc] init];
    [pickView setAddressViewWithTitle:@"选择:省份-城市"];
    [pickView showPickView:self];
    pickView.block = ^(NSString *selectedStr)
    {
        NSArray *bankArray = [selectedStr componentsSeparatedByString:@"-"];
        _provinceStr = [bankArray firstObject];
        _cityStr = [bankArray lastObject];
        _bank_PC.textColor = [UIColor blackColor];
        _bank_PC.text = selectedStr;
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
