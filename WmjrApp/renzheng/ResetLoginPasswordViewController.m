//
//  ResetLoginPasswordViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/11/18.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "ResetLoginPasswordViewController.h"

@interface ResetLoginPasswordViewController ()
{
    NSInteger _count;
    NSTimer *_timer;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;/*  手机号 */
@property (weak, nonatomic) IBOutlet UITextField *verificationNum;/*  验证码 */
@property (weak, nonatomic) IBOutlet UITextField *password;/* 新的登录密码 */
@property (weak, nonatomic) IBOutlet UITextField *nPassword;  /* 新的登录密码 */

@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;/*  */
- (IBAction)verificationBtnAction:(id)sender;/*  获取验证码 */

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;/*  提交按钮 */
- (IBAction)submitBtnAction:(id)sender;/* 提交 */

@property (nonatomic, copy) NSString *codeStr; /* 验证码 */

@end

@implementation ResetLoginPasswordViewController

- (void)setUpNavigationBar {
    self.view.backgroundColor = VIEWBACKCOLOR;
    self.title = @"重置密码";
    _verificationBtn.backgroundColor = BASECOLOR;
    _verificationBtn.layer.cornerRadius = 10;
    _verificationBtn.layer.masksToBounds = YES;
    _submitBtn.backgroundColor = BASECOLOR;
    
//    [_phoneNum addTarget:self action:@selector(limitedNumberOfWords) forControlEvents:(UIControlEventEditingChanged)];
//    [_verificationNum addTarget:self action:@selector(limitedNumberOfWords) forControlEvents:(UIControlEventEditingChanged)];
//    [_password addTarget:self action:@selector(limitedNumberOfWords) forControlEvents:(UIControlEventEditingChanged)];
//    [_nPassword addTarget:self action:@selector(limitedNumberOfWords) forControlEvents:(UIControlEventEditingChanged)];
    
}

//- (void)limitedNumberOfWords {
//    if (_phoneNum.text.length >= 11) {
//        _phoneNum.text = [_phoneNum.text substringToIndex:11];
//        NetManager *manager = [[NetManager alloc] init];
//        NSDictionary *paramDic = @{@"mobile":_phoneNum.text, @"pwd":@"",@"verify":_verificationNum.text};
//        [manager postDataWithUrlActionStr:@"User/forget" withParamDictionary:paramDic withBlock:^(id obj) {
//            if ([obj[@"result"] isEqualToString:@"1"]) {
//            } else {
//                [_phoneNum resignFirstResponder];
//                [[SingletonManager sharedManager] alert1PromptInfo:[obj[@"data"] objectForKey:@"mes"]];
//                return ;
//            }
//        }];
//    }
//    if (_verificationNum.text.length > 8) {
//        _verificationNum.text = [_verificationNum.text substringToIndex:8];
//    }
//    if (_password.text.length > 18) {
//        _password.text = [_password.text substringToIndex:18];
//    }
//    if (_nPassword.text.length > 18) {
//        _nPassword.text = [_nPassword.text substringToIndex:18];
//    }
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    
}

- (IBAction)verificationBtnAction:(id)sender {
    /*  判断手机号是否为空或者格式不正确 */
    if (_phoneNum.text.length == 0) {
        [[SingletonManager sharedManager] alert1PromptInfo:@"手机号不能为空"];
        return ;
    }
//    if ([[SingletonManager sharedManager] isValidateMobile:_phoneNum.text] == NO) {
//        [[SingletonManager sharedManager] alert1PromptInfo:@"请输入正确的手机号"];
//        return ;
//    }
    
    _verificationBtn.enabled = NO;
    [_verificationBtn setTitleColor:AUXILY_COLOR forState:UIControlStateNormal];
    _count = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTimeAction) userInfo:nil repeats:YES];
    
    /* 获取验证码 */
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"App/verify" withParamDictionary:@{@"mobile":_phoneNum.text} withBlock:^(id obj) {
        if (obj) {
            _codeStr = [obj[@"data"] objectForKey:@"code"];
            NSLog(@"%@", _codeStr);
        }
    }];
}

- (void)countDownTimeAction {
    --_count;
    if (_count <= 0) {
        _count = 59;
        [_verificationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _verificationBtn.enabled = YES;
        [_verificationBtn setTitleColor:VIEWBACKCOLOR forState:UIControlStateNormal];
        [_timer invalidate];
        _timer = nil;
    } else {
        NSString *timeStr = [NSString stringWithFormat:@"%ld秒后重发", (unsigned long)_count];
        [_verificationBtn setTitle:timeStr forState:UIControlStateNormal];
    }
}

- (IBAction)submitBtnAction:(id)sender {
    if ([self checkResult]) {
        [self getDataWithNetManager];
    }
}

#pragma mark - 数据处理 －
- (void)getDataWithNetManager {
    NetManager *manager = [[NetManager alloc] init];
    NSDictionary *paramDic = @{@"mobile":_phoneNum.text, @"pwd":_nPassword.text,@"verify":_verificationNum.text};
    [manager postDataWithUrlActionStr:@"User/forget" withParamDictionary:paramDic withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:@"登录密码修改成功" maskType:(SVProgressHUDMaskTypeNone)];
            //当所有判断都通过以后直接返回登录界面重新登录
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [[SingletonManager sharedManager] alert1PromptInfo:[obj[@"data"] objectForKey:@"mes"]];
        }
    }];
}

- (BOOL)checkResult {
    if (_phoneNum.text.length == 0 || _nPassword.text.length == 0 || _nPassword.text.length == 0 || _verificationNum.text.length == 0) {
        if (_phoneNum.text.length == 0) {
            [[SingletonManager sharedManager] alert1PromptInfo:@"手机号不能为空"];
            return NO;
        } else if (_nPassword.text.length == 0) {
            [[SingletonManager sharedManager] alert1PromptInfo:@"密码不能为空"];
            return NO;
        } else if (_nPassword.text.length == 0) {
            [[SingletonManager sharedManager] alert1PromptInfo:@"请再次输入密码"];
            return NO;
        } else if (_verificationNum.text.length == 0) {
            [[SingletonManager sharedManager] alert1PromptInfo:@"验证码不能为空"];
            return NO;
        }
        else {
            return YES;
        }
    } else {
//        if ([[SingletonManager sharedManager] isValidateMobile:_phoneNum.text] == NO) {
//            [[SingletonManager sharedManager] alert1PromptInfo:@"请输入正确的手机号"];
//            return NO;
//        } else
        if (_nPassword.text.length < 6 || _nPassword.text.length > 18) {
            [[SingletonManager sharedManager] alert1PromptInfo:@"密码格式不正确"];
            return NO;
        }
        else if ([_password.text isEqualToString:_nPassword.text] == NO) {
            [[SingletonManager sharedManager] alert1PromptInfo:@"两次登录密码不一致"];
            return NO;
        } else if (![_codeStr isEqualToString:_verificationNum.text]) {
            [[SingletonManager sharedManager] alert1PromptInfo:@"验证码错误"];
            return NO;
        }  else {
            return YES;
        }
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
