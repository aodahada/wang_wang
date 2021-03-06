//
//  RegisterViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/6/30.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "RegisterModel.h"
#import "MMPopupWindow.h"
#import "RegisterAgreeViewController.h"
#import "AliGesturePasswordViewController.h"
//#import "KeychainData.h"
#import "JPUSHService.h"

@interface RegisterViewController ()<UITextFieldDelegate, UIScrollViewDelegate>
{
    NSMutableArray *_dataSource;
    
    NSInteger _count;
    NSTimer *_timer;
}

//@property (strong, nonatomic) IBOutlet UITextField *userName; /* 昵称 */
@property (strong, nonatomic) IBOutlet UITextField *phoneNum;  /* 手机号 */
@property (strong, nonatomic) IBOutlet UITextField *password;  /*  登录密码 */
@property (strong, nonatomic) IBOutlet UITextField *nPassword;  /* 登录密码 */

@property (strong, nonatomic) IBOutlet UITextField *verificatword;  //验证码
@property (strong, nonatomic) IBOutlet UITextField *invitedNum;  //邀请码

@property (strong, nonatomic) IBOutlet UIButton *getVerificatwordBtn; /* 获取验证码 */
@property (strong, nonatomic) IBOutlet UIButton *completeBtn;  /* 完成 */

@property (copy, nonatomic) NSString *codeStr;  /* 验证码 */

@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
- (IBAction)agreeBtnAction:(id)sender;


@end

@implementation RegisterViewController

/* 设置导航条 */
- (void)configNagationBar {
    self.view.backgroundColor = VIEWBACKCOLOR;
    self.title = @"手机快速注册";
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:VIEWBACKCOLOR};
//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backBtnAction)];
//    self.navigationItem.leftBarButtonItem = backBtn;
//    self.navigationController.navigationBar.barTintColor = GERENCOLOR;
//    self.navigationController.navigationBar.tintColor = VIEWBACKCOLOR;
//    self.navigationController.navigationBar.translucent = NO;
    [_agreeBtn setTitleColor:BASECOLOR forState:UIControlStateNormal];
    
    if ([UIScreen mainScreen].bounds.size.height > 470 && [UIScreen mainScreen].bounds.size.height < 490) {
        CGRect completeP = _verificatword.frame;
        completeP.origin.y += 15;
        _completeBtn.frame = completeP;
    }
    
    _getVerificatwordBtn.backgroundColor = GERENCOLOR;
    [_getVerificatwordBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerificatwordBtn setTitleColor:VIEWBACKCOLOR forState:UIControlStateNormal];
    _getVerificatwordBtn.layer.cornerRadius = 5;
    _getVerificatwordBtn.layer.masksToBounds = YES;
    
    _completeBtn.backgroundColor = GERENCOLOR;
    
    
    [_phoneNum addTarget:self action:@selector(limitedNumberOfWords) forControlEvents:(UIControlEventEditingChanged)];
    [_nPassword addTarget:self action:@selector(limitedNumberOfWords) forControlEvents:(UIControlEventEditingChanged)];
    [_password addTarget:self action:@selector(limitedNumberOfWords) forControlEvents:(UIControlEventEditingChanged)];
    [_verificatword addTarget:self action:@selector(limitedNumberOfWords) forControlEvents:(UIControlEventEditingChanged)];
    
    if (self.codeTextCanEdit) {
        _invitedNum.userInteractionEnabled = YES;
    } else {
        _invitedNum.userInteractionEnabled = NO;
        [self getCopyBoardMethod];
    }
    
}

#pragma mark - 获取剪贴板内容
- (void)getCopyBoardMethod {
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    NSString *content = [pasteboard string];
    if ([content rangeOfString:@"wmcf-"].location !=NSNotFound) {
        NSArray *contentArray = [content componentsSeparatedByString:@"-"];
        _invitedNum.text = contentArray[1];
    }
}

- (void)limitedNumberOfWords {
    if (_phoneNum.text.length > 11) {
        _phoneNum.text = [_phoneNum.text substringToIndex:11];
    }
    if (_verificatword.text.length > 8) {
        _verificatword.text = [_verificatword.text substringToIndex:8];
    }
    if (_nPassword.text.length > 18) {
        _nPassword.text = [_nPassword.text substringToIndex:18];
    }
    if (_password.text.length > 18) {
        _password.text = [_password.text substringToIndex:18];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backToLogin) name:@"backToRoot" object:nil];
    [self configNagationBar];
    [[MMPopupWindow sharedWindow] cacheWindow];
    
    UIImage *image;
    UIBarButtonItem *backButton;
    NSString *app_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *userId = [self convertNullString:[SingletonManager sharedManager].uid];
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"appVersion"] isEqualToString:app_version]&&[userId isEqualToString:@""]){
        image = [[UIImage imageNamed:@"icon_backwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(closeClick)];
    } else {
        image = [[UIImage imageNamed:@"arrow_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    }
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)closeClick {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"addHomeGudie" object:nil];
    }];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 判断字符串是否为空
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

#pragma mark - 完成手势密码部分
- (void)backToLogin {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"RegisterViewController"];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RegisterViewController"];
}

/* 获取验证码 */
- (IBAction)getVerificatAction:(id)sender {
//    if ([_phoneNum.text isEqualToString:@"18357027828"] || [_phoneNum.text isEqualToString:@"18357028828"] || [_phoneNum.text isEqualToString:@"18758361020"]) {
//        _codeStr = @"123456";
//        _verificatword.text = @"123456";
//        return;
//    }
    
    /*  判断手机号是否为空或者格式不正确 */
    if (_phoneNum.text.length == 0) {
        [[SingletonManager sharedManager] alert1PromptInfo:@"手机号不能为空"];
        return ;
    }
//    if ([[SingletonManager sharedManager] isValidateMobile:_phoneNum.text] == NO) {
//        [[SingletonManager sharedManager] alert1PromptInfo:@"请输入正确的手机号"];
//        [_phoneNum resignFirstResponder];
//        return ;
//    }
    _getVerificatwordBtn.enabled = NO;
    [_getVerificatwordBtn setTitleColor:AUXILY_COLOR forState:UIControlStateNormal];
    _count = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTimeAction) userInfo:nil repeats:YES];
    
    /* 获取验证码 */
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"App/verify" withParamDictionary:@{@"mobile":_phoneNum.text} withBlock:^(id obj) {
        if (obj) {
            _codeStr = [obj[@"data"] objectForKey:@"code"];
            
        }
    }];
    
}

- (void)countDownTimeAction {
    --_count;
    if (_count == 0) {
        _count = 59;
        [_getVerificatwordBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getVerificatwordBtn setTitleColor:VIEWBACKCOLOR forState:UIControlStateNormal];
        _getVerificatwordBtn.enabled = YES;
        [_timer invalidate];
        _timer = nil;
    } else {
        NSString *timeStr = [NSString stringWithFormat:@"%ld秒后重发", (long)_count];
        [_getVerificatwordBtn setTitle:timeStr forState:UIControlStateNormal];
    }
}

/* 注册完成  */
- (IBAction)completeAction:(id)sender {
//    if (![_codeStr isEqualToString:_verificatword.text]) {
//        [[SingletonManager sharedManager] alert1PromptInfo:@"验证码错误"];
//        return;
//    }
    

//    BOOL isSave = [[SingletonManager sharedManager]isSave];
//    if (isSave) {
//        [self dismissViewControllerAnimated:YES completion:^{
//            
//        }];
//    } else {
//        [[SingletonManager sharedManager]removeHandGestureInfoDefault];
//        AliGesturePasswordViewController *aliGesVC = [[AliGesturePasswordViewController alloc]init];
//        aliGesVC.string = @"重置密码";
//        aliGesVC.type = @"注册";
//        [self presentViewController:aliGesVC animated:YES completion:^{
//            
//        }];
//    }
    
    
//    [self loginMethod];
    if ([self checkResult]) {
        /*验证验证码是否正确*/
        [self getDataWithNetManager];
    }
}

#pragma mark - 数据处理 －
- (void)getDataWithNetManager {
    NetManager *manager = [[NetManager alloc] init];
    NSDictionary *paramDic = @{@"pwd":_nPassword.text,@"invitationcode":_invitedNum.text,@"mobile":_phoneNum.text,@"verify":_verificatword.text};
    [manager postDataWithUrlActionStr:@"User/register" withParamDictionary:paramDic withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSDictionary *dataDic = obj[@"data"];
            [SingletonManager sharedManager].uid = dataDic[@"id"];
            [[NSUserDefaults standardUserDefaults] setObject:[SingletonManager sharedManager].uid forKey:@"uid"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            RegisterModel *model = [[RegisterModel alloc] init];
            [model setValuesForKeysWithDictionary:dataDic];
            [_dataSource addObject:model];
            
            [SVProgressHUD showSuccessWithStatus:@"注册成功" maskType:(SVProgressHUDMaskTypeNone)];
            
//            [self.navigationController popViewControllerAnimated:YES];
            
//            BOOL isSave = [[SingletonManager sharedManager]isSave];
//            if (isSave) {
//                [self.navigationController popViewControllerAnimated:YES];
//            } else {
//                [[SingletonManager sharedManager]removeHandGestureInfoDefault];
//                AliGesturePasswordViewController *aliGesVC = [[AliGesturePasswordViewController alloc]init];
//                aliGesVC.string = @"重置密码";
//                aliGesVC.type = @"注册";
//                [self presentViewController:aliGesVC animated:YES completion:^{
//                    
//                }];
//            }
            //登录接口
            [self loginMethod];
            
        } else {
            [[SingletonManager sharedManager] alert1PromptInfo:[obj[@"data"] objectForKey:@"mes"]];
        }
    }];
}

#pragma mark - 登录接口
- (void)loginMethod {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"登录中"];
    [manager postDataWithUrlActionStr:@"User/login" withParamDictionary:@{@"mobile":_phoneNum.text, @"pwd":_nPassword.text,} withBlock:^(id obj) {
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
                [[NSUserDefaults standardUserDefaults] setObject:_nPassword.text forKey:@"passWord"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [_phoneNum resignFirstResponder];
                [_nPassword resignFirstResponder];
                
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
    textField.textColor = AUXILY_COLOR;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)checkResult {
    if (_phoneNum.text.length == 0 || _password.text.length == 0 || _nPassword.text.length == 0 || _verificatword.text.length == 0) {
        if (_phoneNum.text.length == 0) {
             [[SingletonManager sharedManager] alert1PromptInfo:@"手机号不能为空"];
            return NO;
        } else if (_password.text.length == 0) {
            [[SingletonManager sharedManager] alert1PromptInfo:@"登录密码不能为空"];
            return NO;
        } else if (_nPassword.text.length == 0) {
             [[SingletonManager sharedManager] alert1PromptInfo:@"请再次输入登录密码"];
            return NO;
        } else if (_verificatword.text.length == 0) {
            [[SingletonManager sharedManager] alert1PromptInfo:@"验证码不能为空"];
            return NO;
        } else {
            return YES;
        }
    } else {
        
//        else if ([[SingletonManager sharedManager] isValidateMobile:_phoneNum.text] == NO) {
//            [[SingletonManager sharedManager] alert1PromptInfo:@"请输入正确的手机号"];
//            return NO;
//        }
        if (_password.text.length < 6 || _password.text.length > 18) {
            [[SingletonManager sharedManager] alert1PromptInfo:@"登录密码格式不正确"];
            return NO;
        } else if (![[SingletonManager sharedManager] checkPassword:_password.text]) {
            [[SingletonManager sharedManager] alert1PromptInfo:@"登录密码必须包含数字和字母"];
            return NO;
        } else if ([_nPassword.text isEqualToString:_password.text] == NO) {
            [[SingletonManager sharedManager] alert1PromptInfo:@"两次登录密码不一致"];
            return NO;
        } else if (![_codeStr isEqualToString:_verificatword.text]) {
            [[SingletonManager sharedManager] alert1PromptInfo:@"验证码错误"];
            return NO;
        } else {
            return YES;
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
}

/* 查看协议 */
- (IBAction)agreeBtnAction:(id)sender {
    RegisterAgreeViewController *registerAgreeVC = [[RegisterAgreeViewController alloc] init];
    [self.navigationController pushViewController:registerAgreeVC animated:YES];
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
