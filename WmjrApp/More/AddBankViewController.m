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
#import "BankDetailViewController.h"
#import "BankModel.h"

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

@property (nonatomic, strong)NSMutableArray *bankArray;

@end

@implementation AddBankViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)setUpNavigationBar {
    self.title = @"添加银行卡";
    _yanzhengBtn.backgroundColor = RGBA(246, 87, 27, 1.0);
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

/**
 查看银行额度详情

 @param sender sender description
 */
- (IBAction)watchBankDetail:(id)sender {
    BankDetailViewController *bankDetailVC = [[BankDetailViewController alloc]init];
    [self.navigationController pushViewController:bankDetailVC animated:YES];
}

/*  获取验证码 */
- (IBAction)yanzhengBtnAction:(id)sender {
    if ([self checkResult]) {
        NetManager *manager = [[NetManager alloc] init];
        [SVProgressHUD showWithStatus:@"请稍后"];
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"member_id"] = [SingletonManager sharedManager].uid;
        param[@"bank_code"] = _bank_codeStr;
        param[@"bank_account_no"] = _bankNumField.text;
        param[@"card_attribute"] = @"C";
        param[@"province"] = _provinceStr;
        param[@"city"] = _cityStr;
        param[@"mobile"] = _phoneNumField.text;
        NSDictionary *paramDic = (NSDictionary *)param;
        [manager postDataWithUrlActionStr:@"Card/bind" withParamDictionary:paramDic withBlock:^(id obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                
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
                                [strongSelf.yanzhengBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            });
                            timeout--;
                        }
                        
                    }
                });
                dispatch_resume(_timer);
                
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
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    _bankArray = [[NSMutableArray alloc]init];
    NSMutableArray *stringArray = [[NSMutableArray alloc]init];
    [manager postDataWithUrlActionStr:@"Bank/index" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSMutableArray *array = obj[@"data"];
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic = array[i];
                BankModel *bankModel = [BankModel mj_objectWithKeyValues:dic];
                NSString *bankString = [NSString stringWithFormat:@"%@-%@",bankModel.code,bankModel.name];
                [stringArray addObject:bankString];
                [_bankArray addObject:bankModel];
            }
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setBankViewWithItem:(NSArray *)stringArray title:@"银行名称"];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr)
            {
                NSArray *bankArray = [selectedStr componentsSeparatedByString:@"-"];
                _bank_codeStr = [bankArray firstObject];
                _bankNameField.textColor = [UIColor blackColor];
                _bankNameField.text = [bankArray lastObject];
            };
            
            [SVProgressHUD dismiss];
        } else {
            NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            [SVProgressHUD dismiss];
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
            [alertView show];
        }
    }];


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
