//
//  ComfirmFastPayView.m
//  wangmajinrong
//
//  Created by Baimifan on 15/11/25.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "ComfirmFastPayView.h"

@interface ComfirmFastPayView ()<UITextFieldDelegate>
{
    NSInteger _count;
    NSTimer *_timer;
}

@end

@implementation ComfirmFastPayView

- (void)awakeFromNib {
    _getVerCerBtn.backgroundColor = BASECOLOR;
    _vercerNumField.keyboardType = UIKeyboardTypeNumberPad;
    [_getVerCerBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerCerBtn setTitleColor:VIEWBACKCOLOR forState:UIControlStateNormal];
    _getVerCerBtn.layer.cornerRadius = 5;
    _getVerCerBtn.layer.masksToBounds = YES;
    _vercerNumField.delegate = self;
    [self registerKeyboard];
}

- (void)callBtnClickEventBlock:(callBtnClickEvent)block {
    self.block = block;
}

/* 获取验证码 */
- (IBAction)getVerCerBtnAction:(id)sender {
    _getVerCerBtn.enabled = NO;
    [_getVerCerBtn setTitleColor:AUXILY_COLOR forState:UIControlStateNormal];
    _count = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTimeAction) userInfo:nil repeats:YES];
    self.block(sender);
}

- (void)countDownTimeAction {
    --_count;
    if (_count == 0) {
        _count = 59;
        [_getVerCerBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getVerCerBtn setTitleColor:AUXILY_COLOR forState:UIControlStateNormal];
        _getVerCerBtn.enabled = YES;
        [_timer invalidate];
        _timer = nil;
    } else {
        NSString *timeStr = [NSString stringWithFormat:@"%ld秒后重发", (long)_count];
        
        [_getVerCerBtn setTitle:timeStr forState:UIControlStateNormal];
    }
}

/* 确定 */
- (IBAction)comfirBtnAction:(id)sender {
    self.block(sender);
}

/* 取消 */
- (IBAction)cancelBtnAction:(id)sender {
    self.block(sender);
}

#pragma mark - UITextFieldDelegate -
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillShowNotification object:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:nil];
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
