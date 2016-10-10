//
//  PhoneChangeView.m
//  wangmajinrong
//
//  Created by Baimifan on 15/7/13.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "PhoneChangeView.h"

@interface PhoneChangeView () <UITextFieldDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, copy) NSString *codeStr;  /* 验证码 */

@end

@implementation PhoneChangeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _codeStr = nil;
        [self initWithSubViews];
        [self registerKeyboard];
    }
    return self;
}

- (void)initWithSubViews {
    UILabel *aLable = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(0, 0, 305, 40))];
    aLable.text = @"修改绑定手机";
    aLable.textAlignment = NSTextAlignmentCenter;
    aLable.textColor = AUXILY_COLOR;
    aLable.font = [UIFont systemFontOfSize:RESIZE_UI(18.0f)];
    [self addSubview:aLable];
    UILabel *aLine = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(8, 40, 289, 1))];
    aLine.backgroundColor = AUXILY_COLOR;
    aLine.alpha = .4;
    [self addSubview:aLine];
    
    UILabel *nPhoneLable = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(8, 50, 70, 20))];
    nPhoneLable.text = @"新手机";
    nPhoneLable.textAlignment = NSTextAlignmentCenter;
    nPhoneLable.textColor = AUXILY_COLOR;
    nPhoneLable.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:nPhoneLable];
    _nPhoneCard = [[UITextField alloc] initWithFrame:RESIZE_FRAME(CGRectMake(80, 45, 219, 30))];
    _nPhoneCard.borderStyle = UITextBorderStyleNone;
    _nPhoneCard.textColor = AUXILY_COLOR;
    _nPhoneCard.tag = 401;
    _nPhoneCard.delegate = self;
    [self addSubview:_nPhoneCard];
    UILabel *bLine = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(8, 80, 289, 1))];
    bLine.backgroundColor = AUXILY_COLOR;
    bLine.alpha = .4;
    [self addSubview:bLine];
    
    UILabel *verfitionLable = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(8, 90, 70, 20))];
    verfitionLable.text = @"验证码";
    verfitionLable.textAlignment = NSTextAlignmentCenter;
    verfitionLable.textColor = AUXILY_COLOR;
    verfitionLable.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:verfitionLable];
    _verfitionNum = [[UITextField alloc] initWithFrame:RESIZE_FRAME(CGRectMake(80, 85, 100, 30))];
    _verfitionNum.borderStyle = UITextBorderStyleNone;
    _verfitionNum.textColor = AUXILY_COLOR;
    _verfitionNum.tag = 402;
    _verfitionNum.delegate = self;
    [self addSubview:_verfitionNum];
    
    UILabel *cLine = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(0, 120, 305, 1))];
    cLine.backgroundColor = AUXILY_COLOR;
    cLine.alpha = .4;
    [self addSubview:cLine];
    
    _getVerfitionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _getVerfitionBtn.frame = RESIZE_FRAME(CGRectMake(219, 90, 70, 20));
    _getVerfitionBtn.backgroundColor = BASECOLOR;
    _getVerfitionBtn.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(12.0f)];
    [_getVerfitionBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerfitionBtn setTitleColor:VIEWBACKCOLOR forState:UIControlStateNormal];
    [_getVerfitionBtn addTarget:self action:@selector(getVerfitionAction:) forControlEvents:UIControlEventTouchUpInside];
    _getVerfitionBtn.tag = 1001;
    _getVerfitionBtn.layer.cornerRadius = 3;
    _getVerfitionBtn.layer.masksToBounds = YES;
    [self addSubview:_getVerfitionBtn];
 
    _determinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _determinBtn.frame = RESIZE_FRAME(CGRectMake(0, 120, 305 / 2, 50));
    _determinBtn.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(18.0f)];
    [_determinBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_determinBtn setTitleColor:[UIColor colorWithRed:0.91f green:0.38f blue:0.33f alpha:1.00f] forState:UIControlStateNormal];
    [_determinBtn addTarget:self action:@selector(clickChangePhoneNumAction:) forControlEvents:UIControlEventTouchUpInside];
    _determinBtn.tag = 301;
    _determinBtn.layer.borderWidth = 1;
    _determinBtn.layer.borderColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f].CGColor;
    [self addSubview:_determinBtn];
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = RESIZE_FRAME(CGRectMake(305 / 2, 120, 305 / 2, 50));
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(18.0f)];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor colorWithRed:0.91f green:0.38f blue:0.33f alpha:1.00f] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(clickChangePhoneNumAction:) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.tag = 302;
    [self addSubview:_cancelBtn];
    
}

//获取验证码
- (void)getVerfitionAction:(UIButton *)sender {
//    NSLog(@"获取验证码");
    [_nPhoneCard resignFirstResponder];
    _nPhoneCard.textColor = AUXILY_COLOR;
    if ([_nPhoneCard.text isEqualToString:@""]) {
        _nPhoneCard.textColor = BASECOLOR;
        _nPhoneCard.text = @"手机号不能为空";
        _nPhoneCard.clearsOnBeginEditing = YES;
        _nPhoneCard.font = [UIFont systemFontOfSize:13.0];
        return;
    }
//    if (![[SingletonManager sharedManager] isValidateMobile:_nPhoneCard.text]) {
//        _nPhoneCard.textColor = BASECOLOR;
//        _nPhoneCard.text = @"手机号不正确";
//        _nPhoneCard.font = [UIFont systemFontOfSize:13.0];
//        _nPhoneCard.clearsOnBeginEditing = YES;
//        return;
//    }
    /* 手机号验证成功后,点击获取验证码后让手机号输入框不可编辑 */
    _nPhoneCard.enabled = NO;
    _getVerfitionBtn.enabled = NO;
    [_getVerfitionBtn setTitleColor:AUXILY_COLOR forState:UIControlStateNormal];
    _count = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTimeAction) userInfo:nil repeats:YES];
    
    /* 获取验证码 */
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"App/verify" withParamDictionary:@{@"mobile":_nPhoneCard.text} withBlock:^(id obj) {
        if (obj) {
            _codeStr = [obj[@"data"] objectForKey:@"code"];
            NSLog(@"%@", _codeStr);
        }
    }];
    
}

/* 倒计时 */
- (void)countDownTimeAction {
    --_count;
    if (_count <= 0) {
        _count = 59;
        [_getVerfitionBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getVerfitionBtn.enabled = YES;
        [_getVerfitionBtn setTitleColor:VIEWBACKCOLOR forState:UIControlStateNormal];
        [_timer invalidate];
        _timer = nil;
    } else {
        NSString *timeStr = [NSString stringWithFormat:@"%ld秒后重发", (unsigned long)_count];
        [_getVerfitionBtn setTitle:timeStr forState:UIControlStateNormal];
//        NSLog(@"%@", _getVerfitionBtn.titleLabel.text);
    }
}

- (void)callBtnEventBlock:(callChoiceEvent)block {
    self.block = block;
}

//选择
- (void)clickChangePhoneNumAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        /* 点击确定后先验证 手机号和验证码是否正确 */
        if (![_verfitionNum.text isEqualToString:_codeStr]) {
            _verfitionNum.text = @"验证码输入错误";
            _verfitionNum.textColor = BASECOLOR;
            _verfitionNum.clearsOnBeginEditing = YES;
            _verfitionNum.font = [UIFont systemFontOfSize:13.0];
            return;
        }
        if ([self checkResult]) {
            self.block(sender, _nPhoneCard.text);
        }
    } else {
        self.block(sender, @"");
    }
}

#pragma mark - UITextFieldDelegate -
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillShowNotification object:nil];
    textField.textColor = AUXILY_COLOR;
    NSInteger index = textField.tag;
    switch (index) {
        case 401:
            [_nPhoneCard becomeFirstResponder];
            break;
        case 402:
            [_verfitionNum becomeFirstResponder];
            break;
            
        default:
            break;
    }
}

- (BOOL)checkResult {
    if (_nPhoneCard.text.length == 0 || _verfitionNum.text.length == 0) {
        if (_nPhoneCard.text.length == 0) {
            ALERTVIEW_SHOW(@"手机号不能为空");
            return NO;
        } else if (_verfitionNum.text.length == 0) {
            ALERTVIEW_SHOW(@"验证码不能为空");
            return NO;
        } else {
            return YES;
        }
    } else {
//        if ([[SingletonManager sharedManager] isValidateMobile:_nPhoneCard.text] == NO) {
//            //                textField.text = @"";
//            ALERTVIEW_SHOW(@"请输入正确的手机号");
//            return NO;
//        }
        if ([[SingletonManager sharedManager] isPureInt:_verfitionNum.text] == NO) {
            //            _password.text = @"";
            ALERTVIEW_SHOW(@"验证码不正确");
            return NO;
        } else {
            return YES;
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger index = textField.tag;
    switch (index) {
        case 401:
            [_nPhoneCard resignFirstResponder];
            break;
        case 402:
            [_verfitionNum resignFirstResponder];
            break;
            
        default:
            break;
    }
    return YES;
}

#pragma mark -- 监听键盘的出现和消失

- (void)registerKeyboard
{
    //键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //键盘退出
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

// 监听键盘弹出
- (void)keyboardWillShow:(NSNotification *)notification
{
    // 1.键盘弹出需要的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
//        CGRect keyboardF = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        CGFloat keyboardH = keyboardF.size.height;
//        NSLog(@"keyboardH == %lf", keyboardH);
        self.transform = CGAffineTransformMakeTranslation(0, -100);
    }];
}

// 监听键盘收回
- (void)keyboardWillHide:(NSNotification *)notification
{
    // 当用户完成编辑评论内容的时候，让评论工具条下去
    //    if (self.isChangingKeyboard) return;
    
    // 1.键盘弹出需要的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}
// 移除监听
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
