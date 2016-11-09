//
//  LoginViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/6/29.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "FindwordViewController.h"
#import "AppDelegate.h"
#import "MMPopupItem.h"
#import "MMAlertView.h"
#import "MMPopupWindow.h"
#import "JPUSHService.h"
#import "AliGesturePasswordViewController.h"
#import "UserInfoModel.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *passWord;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIButton *forgetPasswodBtn;
@property (strong, nonatomic) IBOutlet UIButton *quickRegisterBtn;
//@property (strong, nonatomic) IBOutlet UIButton *lookBtn;

@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;
- (IBAction)dismissBtnAction:(id)sender;  /* 隐藏视图 */

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[MMPopupWindow sharedWindow] cacheWindow];
    /* 视图的背景色 */
//    self.view.backgroundColor = GERENCOLOR;
    self.view.backgroundColor = [UIColor whiteColor];
    [_loginBtn setBackgroundColor:RGBA(0, 104, 178, 1.0)];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginBtn.titleLabel.alpha = .6;
    _loginBtn.enabled = NO;
    
    _phoneNum.textColor = [UIColor blackColor];
    _passWord.textColor = [UIColor blackColor];
    
    [_phoneNum addTarget:self action:@selector(limitedNumberOfWords) forControlEvents:(UIControlEventEditingChanged)];
    [_passWord addTarget:self action:@selector(limitedNumberOfWords) forControlEvents:(UIControlEventEditingChanged)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginDissmissMethod) name:@"backToRoot" object:nil];
    
}

- (void)loginDissmissMethod {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)limitedNumberOfWords {
    if (_phoneNum.text.length > 11) {
        _phoneNum.text = [_phoneNum.text substringToIndex:11];
    }
    if (_passWord.text.length > 18) {
        _passWord.text = [_passWord.text substringToIndex:18];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    /* 当页面消失的时候让输入框的内容也清空 */
    _phoneNum.text = @"";
    _passWord.text = @"";
    self.navigationController.navigationBar.hidden = NO;
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"loginDissmiss" object:nil];
}

/* 登录 */
- (IBAction)loginBtnAction:(id)sender {
    if ([self checkResult]) {
        [self getDataWithNetManager];
    }
}

/* 忘记密码 */
- (IBAction)forgetPasswordAction:(id)sender {
    FindwordViewController *findwordVC = [[FindwordViewController alloc] init];
    [self.navigationController pushViewController:findwordVC animated:YES];
}

/* 快速注册 */
- (IBAction)quickRegisterAction:(id)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

/* 隐藏视图 */
- (IBAction)dismissBtnAction:(id)sender {
//    NSLog(@"loginIden ====  %@", self.loginIden);
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([self.loginIden isEqualToString:@"login"] || [self.loginIden isEqualToString:@"login"]) {
        [AppDelegate sharedInstance].tabbarC.selectedIndex = 0;
        self.loginIden = nil;
    }
}

#pragma mark - 数据处理 －
- (void)getDataWithNetManager {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"登录中"];
    [manager postDataWithUrlActionStr:@"User/login" withParamDictionary:@{@"mobile":_phoneNum.text, @"pwd":_passWord.text} withBlock:^(id obj) {
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                [SVProgressHUD showSuccessWithStatus:@"登录成功" maskType:(SVProgressHUDMaskTypeNone)];
                NSDictionary *dataDic = obj[@"data"];
                [UserInfoModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"user_id" : @"id"};
                }];
                UserInfoModel *userModel = [UserInfoModel mj_objectWithKeyValues:dataDic];
                [SingletonManager sharedManager].uid = dataDic[@"id"];
                [SingletonManager sharedManager].userModel = userModel;
                [[NSUserDefaults standardUserDefaults] setObject:[SingletonManager sharedManager].uid forKey:@"uid"];
                [[NSUserDefaults standardUserDefaults] setObject:_phoneNum.text forKey:@"mobile"];
                [[NSUserDefaults standardUserDefaults] setObject:_passWord.text forKey:@"passWord"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [_phoneNum resignFirstResponder];
                [_passWord resignFirstResponder];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccess" object:nil];
                [JPUSHService setAlias:[SingletonManager sharedManager].uid callbackSelector:nil object:self];
                
                BOOL isSave = [[SingletonManager sharedManager]isSave];
                if (isSave) {
                    [self dismissViewControllerAnimated:YES completion:^{
            
                    }];
                } else {
                    [[SingletonManager sharedManager]removeHandGestureInfoDefault];
                    AliGesturePasswordViewController *aliGesVC = [[AliGesturePasswordViewController alloc]init];
                    aliGesVC.string = @"重置密码";
                    aliGesVC.type = @"注册";
                    [self presentViewController:aliGesVC animated:YES completion:^{
                        
                    }];
                }
                
                return ;
            }
            if ([obj[@"result"] isEqualToString:@"1000"]) {
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

#pragma mark - UITextFieldDelegate -
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSInteger index = textField.tag;
    switch (index) {
        case 201:
            [_phoneNum becomeFirstResponder];
            break;
        case 202:
            _loginBtn.enabled = YES;
            [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _loginBtn.titleLabel.alpha = 1.0;
            [_passWord becomeFirstResponder];
            break;
            
        default:
            break;
    }
}

- (BOOL)checkResult {
    if (_phoneNum.text.length == 0) {
        MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
        alertConfig.defaultTextOK = @"确定";
        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"手机号不能为空"];
        [alertView show];
        return NO;
    } else if (_passWord.text.length == 0) {
        MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
        alertConfig.defaultTextOK = @"确定";
        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"密码不能为空"];
        [alertView show];
        return NO;
    } else {
        return YES;
    }
}
//    else {
//        if ([[SingletonManager sharedManager] isValidateMobile:_phoneNum.text] == NO) {
//            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
//            alertConfig.defaultTextOK = @"确定";
//            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"手机号输入错误"];
//            [alertView show];
//            return NO;
//        } else if (_passWord.text.length < 6 && _passWord.text.length > 18) {
//            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
//            alertConfig.defaultTextOK = @"确定";
//            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"密码错误"];
//            [alertView show];
//            return NO;
//        }
////        else if ([[SingletonManager sharedManager] checkPassword:_passWord.text] == NO) {
////            ALERTVIEW_SHOW(@"密码格式不正确");
////            return NO;
////        }
//        else {
//            return YES;
//        }
//    }
//}

- (void)textFieldDidEndEditing:(UITextField *)textField {
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger index = textField.tag;
    switch (index) {
        case 201:
            [_phoneNum resignFirstResponder];
            break;
        case 202:
            [_passWord resignFirstResponder];
            break;
            
        default:
            break;
    }
    return YES;
}


/*手势解锁*/
//- (void)gestureToLockAction {
//    BOOL hasPwd = [CLLockVC hasPwd];
//    if(!hasPwd){
//        NSLog(@"你还没有设置密码，请先设置密码");
//    }else {
//        [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
//            NSLog(@"忘记密码");
//        } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
//            NSLog(@"密码正确");
//            [lockVC dismiss:1.0f];
//        }];
//    }
//}

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
