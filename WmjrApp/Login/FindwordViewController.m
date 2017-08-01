//
//  FindwordViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/6/30.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "FindwordViewController.h"
#import <MMPopupWindow.h>

@interface FindwordViewController ()<UITextFieldDelegate>
{
    NSInteger _count;
    NSTimer *_timer;
}

@property (strong, nonatomic) IBOutlet UITextField *phoneNum;   /* 手机号 */
@property (strong, nonatomic) IBOutlet UITextField *verificatWord;  /* 验证码 */
@property (strong, nonatomic) IBOutlet UITextField *nPassword;   //新密码
@property (strong, nonatomic) IBOutlet UITextField *confimPassword;   //确认密码

@property (strong, nonatomic) IBOutlet UIButton *getVerificatBtn;  /* 获取验证码 */
@property (strong, nonatomic) IBOutlet UIButton *completeBtn;   /* 完成 */

@property (nonatomic, copy) NSString *codeStr; /* 验证码 */



@end

@implementation FindwordViewController

/* 设置导航条 */
- (void)configNagationBar {
    self.view.backgroundColor = VIEWBACKCOLOR;
    self.title = @"找回密码";
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:VIEWBACKCOLOR};
//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backBtnAction)];
//    self.navigationItem.leftBarButtonItem = backBtn;
//    self.navigationController.navigationBar.barTintColor = GERENCOLOR;
//    self.navigationController.navigationBar.tintColor = VIEWBACKCOLOR;
//    self.navigationController.navigationBar.translucent = NO;
    
    [[MMPopupWindow sharedWindow] cacheWindow];
    
    /* 设置获取验证码按钮 */
    _getVerificatBtn.backgroundColor = GERENCOLOR;
    [_getVerificatBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerificatBtn setTitleColor:VIEWBACKCOLOR forState:UIControlStateNormal];
    _getVerificatBtn.layer.cornerRadius = 5;
    _getVerificatBtn.layer.masksToBounds = YES;
    _completeBtn.backgroundColor = GERENCOLOR;
    
//    [_phoneNum addTarget:self action:@selector(limitedNumberOfWords) forControlEvents:(UIControlEventEditingChanged)];
//    [_verificatWord addTarget:self action:@selector(limitedNumberOfWords) forControlEvents:(UIControlEventEditingChanged)];
//    [_nPassword addTarget:self action:@selector(limitedNumberOfWords) forControlEvents:(UIControlEventEditingChanged)];
//    [_confimPassword addTarget:self action:@selector(limitedNumberOfWords) forControlEvents:(UIControlEventEditingChanged)];
    
}

//- (void)limitedNumberOfWords {
//    if (_phoneNum.text.length >= 11) {
//        _phoneNum.text = [_phoneNum.text substringToIndex:11];
//        NetManager *manager = [[NetManager alloc] init];
//        NSDictionary *paramDic = @{@"mobile":_phoneNum.text, @"pwd":@""};
//        [manager postDataWithUrlActionStr:@"User/forget" withParamDictionary:paramDic withBlock:^(id obj) {
//            if ([obj[@"result"] isEqualToString:@"1"]) {
//            } else {
//                [_phoneNum resignFirstResponder];
//                [[SingletonManager sharedManager] alert1PromptInfo:[obj[@"data"] objectForKey:@"mes"]];
//                return ;
//            }
//        }];
//
//    }
//    if (_verificatWord.text.length > 8) {
//        _verificatWord.text = [_verificatWord.text substringToIndex:8];
//    }
//    if (_nPassword.text.length > 18) {
//        _nPassword.text = [_nPassword.text substringToIndex:18];
//    }
//    if (_confimPassword.text.length > 18) {
//        _confimPassword.text = [_confimPassword.text substringToIndex:18];
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNagationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)getVerificatAction:(id)sender {
    /*  判断手机号是否为空或者格式不正确 */
    if (_phoneNum.text.length == 0) {
        [[SingletonManager sharedManager] alert1PromptInfo:@"手机号不能为空"];
        return ;
    }
//    if ([[SingletonManager sharedManager] isValidateMobile:_phoneNum.text] == NO) {
//        [[SingletonManager sharedManager] alert1PromptInfo:@"请输入正确的手机号"];
//        return ;
//    }
    
    _getVerificatBtn.enabled = NO;
    [_getVerificatBtn setTitleColor:AUXILY_COLOR forState:UIControlStateNormal];
    _count = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTimeAction) userInfo:nil repeats:YES];
    
    /* 获取验证码 */
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"App/verify" withParamDictionary:@{@"mobile":_phoneNum.text} withBlock:^(id obj) {
        if (obj) {
            _codeStr = [obj[@"data"] objectForKey:@"code"];
            NSLog(@"=================  %@", _codeStr);
        }
    }];
}

- (void)countDownTimeAction {
    --_count;
    if (_count <= 0) {
        _count = 59;
        [_getVerificatBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getVerificatBtn.enabled = YES;
        [_getVerificatBtn setTitleColor:VIEWBACKCOLOR forState:UIControlStateNormal];
        [_timer invalidate];
        _timer = nil;
    } else {
        NSString *timeStr = [NSString stringWithFormat:@"%ld秒后重发", (unsigned long)_count];
        [_getVerificatBtn setTitle:timeStr forState:UIControlStateNormal];
    }
}

/* 修改完成 */
- (IBAction)completeAction:(id)sender {
    if ([self checkResult]) {
        [self getDataWithNetManager];
    }
}

#pragma mark - 数据处理 －
- (void)getDataWithNetManager {
    NetManager *manager = [[NetManager alloc] init];
    NSDictionary *paramDic = @{@"mobile":_phoneNum.text, @"pwd":_nPassword.text,@"verify":_verificatWord.text};
    [manager postDataWithUrlActionStr:@"User/forget" withParamDictionary:paramDic withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功" maskType:(SVProgressHUDMaskTypeNone)];
            //当所有判断都通过以后直接返回登录界面重新登录
            [self.navigationController popViewControllerAnimated:YES];
        } else {
             [[SingletonManager sharedManager] alert1PromptInfo:[obj[@"data"] objectForKey:@"mes"]];
        }
    }];
}

- (BOOL)checkResult {
    if (_phoneNum.text.length == 0 || _confimPassword.text.length == 0 || _nPassword.text.length == 0 || _verificatWord.text.length == 0) {
        if (_phoneNum.text.length == 0) {
            [[SingletonManager sharedManager] alert1PromptInfo:@"手机号不能为空"];
            return NO;
        } else if (_nPassword.text.length == 0) {
            [[SingletonManager sharedManager] alert1PromptInfo:@"登录密码不能为空"];
            return NO;
        } else if (_confimPassword.text.length == 0) {
            [[SingletonManager sharedManager] alert1PromptInfo:@"请再次输入密码"];
            return NO;
        } else if (_verificatWord.text.length == 0) {
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
        } else if ([_nPassword.text isEqualToString:_confimPassword.text] == NO) {
            [[SingletonManager sharedManager] alert1PromptInfo:@"两次登录密码不一致"];
            return NO;
        } else if (![_codeStr isEqualToString:_verificatWord.text]) {
            [[SingletonManager sharedManager] alert1PromptInfo:@"验证码错误"];
            return NO;
        } else {
            return YES;
        }
    }
}

#pragma mark - UITextFieldDelegate -
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    return YES;
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
