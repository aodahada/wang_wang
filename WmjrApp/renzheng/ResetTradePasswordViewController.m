//
//  ResetTradePasswordViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/11/18.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "ResetTradePasswordViewController.h"

@interface ResetTradePasswordViewController ()
{
    NSInteger _count;
    NSTimer *_timer;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;/*  手机号 */
@property (weak, nonatomic) IBOutlet UITextField *verificationNum;/*  验证码 */
@property (weak, nonatomic) IBOutlet UITextField *trendPassword;/* 新的交易密码 */
@property (weak, nonatomic) IBOutlet UITextField *nTrendPassword;/* 新的交易密码 */

@property (weak, nonatomic) IBOutlet UIButton *verificationBtn; /*  获取验证码 */
- (IBAction)verificationBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn; /*  提交按钮  */
- (IBAction)submitBtnAction:(id)sender;

@property (nonatomic, copy) NSString *codeStr; /* 验证码 */

@end

@implementation ResetTradePasswordViewController

- (void)setUpNavigationBar {
    self.view.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    self.title = @"重置交易密码";
    _verificationBtn.backgroundColor = BASECOLOR;
    _verificationBtn.layer.cornerRadius = 10;
    _verificationBtn.layer.masksToBounds = YES;
    _submitBtn.backgroundColor = BASECOLOR;
    
    [_phoneNum addTarget:self action:@selector(limitedNumberOfWords) forControlEvents:(UIControlEventEditingChanged)];
    [_verificationNum addTarget:self action:@selector(limitedNumberOfWords) forControlEvents:(UIControlEventEditingChanged)];
    [_trendPassword addTarget:self action:@selector(limitedNumberOfWords) forControlEvents:(UIControlEventEditingChanged)];
    [_nTrendPassword addTarget:self action:@selector(limitedNumberOfWords) forControlEvents:(UIControlEventEditingChanged)];
    
}

- (void)limitedNumberOfWords {
    if (_phoneNum.text.length >= 11) {
        _phoneNum.text = [_phoneNum.text substringToIndex:11];
        NetManager *manager = [[NetManager alloc] init];
        NSDictionary *paramDic = @{@"mobile":_phoneNum.text, @"pwd":@""};
        [manager postDataWithUrlActionStr:@"User/forget" withParamDictionary:paramDic withBlock:^(id obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
            } else {
                [_phoneNum resignFirstResponder];
                [[SingletonManager sharedManager] alert1PromptInfo:[obj[@"data"] objectForKey:@"mes"]];
                return ;
            }
        }];

    }
    if (_verificationNum.text.length > 8) {
        _verificationNum.text = [_verificationNum.text substringToIndex:8];
    }
    if (_trendPassword.text.length > 18) {
        _trendPassword.text = [_trendPassword.text substringToIndex:18];
    }
    if (_nTrendPassword.text.length > 18) {
        _nTrendPassword.text = [_nTrendPassword.text substringToIndex:18];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpNavigationBar];
    
}

/* 获取验证码 */
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
    if (_trendPassword.text.length < 6 || _nTrendPassword.text.length < 6) {
        [[SingletonManager sharedManager] alert1PromptInfo:@"密码格式不正确"];
        return ;
    }
    if (![_trendPassword.text isEqualToString:_nTrendPassword.text]) {
        [[SingletonManager sharedManager] alert1PromptInfo:@"密码输入不一致"];
        return;
    }
    [self getDataWithNetManager];
}

#pragma mark - 数据处理 －
- (void)getDataWithNetManager {
    NetManager *manager = [[NetManager alloc] init];
    NSDictionary *paramDic = @{@"mobile":_phoneNum.text, @"pwd_trade":_trendPassword.text};
    [SVProgressHUD showWithStatus:@"正在提交" maskType:(SVProgressHUDMaskTypeNone)];
    [manager postDataWithUrlActionStr:@"User/forget" withParamDictionary:paramDic withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:@"交易密码修改成功" maskType:(SVProgressHUDMaskTypeNone)];
            //当所有判断都通过以后直接返回登录界面重新登录
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
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
