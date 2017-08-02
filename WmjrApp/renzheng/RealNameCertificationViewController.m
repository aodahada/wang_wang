//
//  RealNameCertificationViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/11/18.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "RealNameCertificationViewController.h"
#import "NetManager.h"

@interface RealNameCertificationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;/*  姓名 */
@property (weak, nonatomic) IBOutlet UITextField *selfCardField;/*  身份证 */

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
- (IBAction)nextBtnAction:(id)sender;

@end

@implementation RealNameCertificationViewController

/*  设置导航条 */
- (void)setUpNavigationBar {
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = VIEWBACKCOLOR;
    self.title = @"实名安全认证";
    _nextBtn.backgroundColor = BASECOLOR;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    
    
    [_selfCardField addTarget:self action:@selector(selfCardFieldAction) forControlEvents:(UIControlEventEditingChanged)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"RealNameCertificationViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RealNameCertificationViewController"];
}

- (void)selfCardFieldAction {
    if (_selfCardField.text.length > 18) {
        _selfCardField.text = [_selfCardField.text substringToIndex:18];
    }
}

/* 认证通过 */
- (IBAction)nextBtnAction:(id)sender {
    [_nameField resignFirstResponder];
    [_selfCardField resignFirstResponder];
    
    if ([self checkResult]) {
        [self loadRequestData];
    }
}

/* 获取认证数据 */
- (void)loadRequestData {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"正在提交认证信息"];
    [manager postDataWithUrlActionStr:@"User/realName" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"real_name":_nameField.text, @"cert_no":_selfCardField.text} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [SVProgressHUD dismiss];
            /*  改变实名认证状态 */
            [SingletonManager sharedManager].userModel.is_real_name = @"1";
            [[NSUserDefaults standardUserDefaults] synchronize];
//            /* 是否显示警示框 */
//            if (_isShowAlert == YES) {
//                self.block();
//            }
            [[SingletonManager sharedManager] showHUDView:self.view title:@"实名认证成功" content:@"" time:1.0 andCodes:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        } else {
            [SVProgressHUD dismiss];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:[obj[@"data"] objectForKey:@"mes"]];
            [alertView show];
        }
    }];
}

- (BOOL)checkResult {
    if ([_nameField.text isEqualToString:@""]) {
        MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
        alertConfig.defaultTextOK = @"确定";
        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"请输入名字"];
        [alertView show];
        return NO;
    } else if ([_selfCardField.text isEqualToString:@""]) {
        MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
        alertConfig.defaultTextOK = @"确定";
        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"请输入身份证号"];
        [alertView show];
        return NO;
    } else if (![[SingletonManager sharedManager] validateIdentityCard:_selfCardField.text]) {
        MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
        alertConfig.defaultTextOK = @"确定";
        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"身份证号码错误"];
        [alertView show];
        return NO;
    } else {
        return YES;
    }
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
