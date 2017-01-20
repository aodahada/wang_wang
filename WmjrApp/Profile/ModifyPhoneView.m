//
//  ModifyPhoneView.m
//  WmjrApp
//
//  Created by horry on 2016/12/8.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "ModifyPhoneView.h"

@interface ModifyPhoneView()

@property (nonatomic, strong)UITextField *textFieldForPhone;
@property (nonatomic, strong)UITextField *textFieldForCaptcha;
@property (nonatomic, strong)UIButton *buttonForGetCaptcha;

//@property (nonatomic, strong) NSTimer *timer;//界面倒计时
//@property (nonatomic, assign) int second;//界面倒计时秒数

@property (nonatomic, strong)UIView *viewForHa;

@end

@implementation ModifyPhoneView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.68];
        _viewForHa = [[UIView alloc]init];
        _viewForHa.backgroundColor = [UIColor whiteColor];
        _viewForHa.layer.masksToBounds = YES;
        _viewForHa.layer.cornerRadius = 10.0f;
        [self addSubview:_viewForHa];
        [_viewForHa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_offset(RESIZE_UI(257));
            make.width.mas_offset(RESIZE_UI(306));
        }];
        
        
        UILabel *labelForTitle = [[UILabel alloc]init];
        labelForTitle.text = @"修改绑定手机号";
        labelForTitle.textColor = RGBA(153, 153, 153, 1.0);
        labelForTitle.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
        labelForTitle.textAlignment = NSTextAlignmentCenter;
        [_viewForHa addSubview:labelForTitle];
        [labelForTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_viewForHa.mas_top).with.offset(RESIZE_UI(17));
            make.left.equalTo(_viewForHa.mas_left);
            make.right.equalTo(_viewForHa.mas_right);
            make.height.mas_offset(RESIZE_UI(24));
        }];
        
        UILabel *labelForLine1 = [[UILabel alloc]init];
        labelForLine1.backgroundColor = RGBA(233, 233, 233, 1.0);
        [_viewForHa addSubview:labelForLine1];
        [labelForLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(labelForTitle.mas_bottom).with.offset(RESIZE_UI(16));
            make.left.equalTo(_viewForHa.mas_left).with.offset(RESIZE_UI(12));
            make.right.equalTo(_viewForHa.mas_right).with.offset(RESIZE_UI(-12));
            make.height.mas_offset(1);
        }];
        
        UILabel *labelForPhone = [[UILabel alloc]init];
        labelForPhone.text = @"新手机号";
        labelForPhone.textColor = RGBA(153, 153, 153, 1.0);
        labelForPhone.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
        [_viewForHa addSubview:labelForPhone];
        [labelForPhone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(labelForLine1.mas_bottom).with.offset(RESIZE_UI(24));
            make.left.equalTo(_viewForHa.mas_left).with.offset(RESIZE_UI(12));
        }];
        
        _textFieldForPhone = [[UITextField alloc]init];
        _textFieldForPhone.placeholder = @"请输入新的手机号";
        _textFieldForPhone.textColor = RGBA(153, 153, 153, 1.0);
        _textFieldForPhone.layer.borderWidth = 1;
        _textFieldForPhone.layer.borderColor = RGBA(233, 233, 233, 1.0).CGColor;
        _textFieldForPhone.keyboardType = UIKeyboardTypeNumberPad;
        _textFieldForPhone.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
        [_viewForHa addSubview:_textFieldForPhone];
        [_textFieldForPhone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(labelForPhone.mas_centerY);
            make.left.equalTo(labelForPhone.mas_right).with.offset(RESIZE_UI(12));
            make.width.mas_offset(RESIZE_UI(200));
            make.height.mas_offset(RESIZE_UI(49));
        }];
        
        UILabel *labelForCaptcha = [[UILabel alloc]init];
        labelForCaptcha.text = @"验证码";
        labelForCaptcha.textColor = RGBA(153, 153, 153, 1.0);
        labelForCaptcha.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
        [_viewForHa addSubview:labelForCaptcha];
        [labelForCaptcha mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(labelForPhone.mas_bottom).with.offset(RESIZE_UI(32));
            make.left.equalTo(labelForPhone.mas_left);
        }];
        
        _buttonForGetCaptcha = [[UIButton alloc]init];
        [_buttonForGetCaptcha setTitle:@"获取验证码" forState:UIControlStateNormal];
        _buttonForGetCaptcha.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        [_buttonForGetCaptcha setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonForGetCaptcha setBackgroundColor:RGBA(245, 89, 21, 1.0)];
        [_buttonForGetCaptcha addTarget:self action:@selector(getCaptchaMethod) forControlEvents:UIControlEventTouchUpInside];
        [_viewForHa addSubview:_buttonForGetCaptcha];
        [_buttonForGetCaptcha mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(labelForCaptcha.mas_centerY);
            make.right.equalTo(_viewForHa.mas_right).with.offset(RESIZE_UI(-12));
            make.height.mas_offset(RESIZE_UI(40));
            make.width.mas_offset(RESIZE_UI(89));
        }];
        
        _textFieldForCaptcha = [[UITextField alloc]init];
//        _textFieldForCaptcha.placeholder = @"请输入验证码";
        _textFieldForCaptcha.layer.borderWidth = 1;
        _textFieldForCaptcha.layer.borderColor = RGBA(233, 233, 233, 1.0).CGColor;
        _textFieldForCaptcha.keyboardType = UIKeyboardTypeNumberPad;
        _textFieldForCaptcha.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
        [_viewForHa addSubview:_textFieldForCaptcha];
        [_textFieldForCaptcha mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(labelForCaptcha.mas_centerY);
            make.left.equalTo(_textFieldForPhone.mas_left);
            make.right.equalTo(_buttonForGetCaptcha.mas_left).with.offset(RESIZE_UI(-16));
            make.height.mas_offset(RESIZE_UI(49));
        }];
        
        UILabel *labelForLine2 = [[UILabel alloc]init];
        labelForLine2.backgroundColor = RGBA(233, 233, 233, 1.0);
        [_viewForHa addSubview:labelForLine2];
        [labelForLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textFieldForCaptcha.mas_bottom).with.offset(17);
            make.left.equalTo(_viewForHa.mas_left).with.offset(RESIZE_UI(12));
            make.right.equalTo(_viewForHa.mas_right).with.offset(RESIZE_UI(-12));
            make.height.mas_offset(1);
        }];
        
        UIButton *buttonForCancel = [[UIButton alloc]init];
        [buttonForCancel setTitle:@"取消" forState:UIControlStateNormal];
        [buttonForCancel setTitleColor:RGBA(153, 153, 153, 1.0) forState:UIControlStateNormal];
        buttonForCancel.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
        [buttonForCancel addTarget:self action:@selector(cancelMethod) forControlEvents:UIControlEventTouchUpInside];
        [_viewForHa addSubview:buttonForCancel];
        [buttonForCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_viewForHa.mas_bottom);
            make.left.equalTo(_viewForHa.mas_left);
            make.width.mas_offset(RESIZE_UI(306)/2);
            make.height.mas_offset(RESIZE_UI(57));
        }];
        
        UILabel *labelForLine3 = [[UILabel alloc]init];
        labelForLine3.backgroundColor = RGBA(233, 233, 233, 1.0);
        [_viewForHa addSubview:labelForLine3];
        [labelForLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(1);
            make.top.equalTo(labelForLine2.mas_top).with.offset(RESIZE_UI(6));
            make.bottom.equalTo(buttonForCancel.mas_bottom).with.offset(RESIZE_UI(-7));
            make.centerX.equalTo(_viewForHa.mas_centerX);
        }];
        
        UIButton *buttonForComfirm = [[UIButton alloc]init];
        [buttonForComfirm setTitle:@"确定" forState:UIControlStateNormal];
        [buttonForComfirm setTitleColor:RGBA(51, 51, 51, 1.0) forState:UIControlStateNormal];
        buttonForComfirm.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
        [buttonForComfirm addTarget:self action:@selector(confirmMethod) forControlEvents:UIControlEventTouchUpInside];
        [_viewForHa addSubview:buttonForComfirm];
        [buttonForComfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_viewForHa.mas_bottom);
            make.right.equalTo(_viewForHa.mas_right);
            make.width.mas_offset(RESIZE_UI(306)/2);
            make.height.mas_offset(RESIZE_UI(57));
        }];
        
    }
    return self;
}

- (void)getCaptchaMethod {
    if ([_textFieldForPhone.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
    }
    [_textFieldForPhone resignFirstResponder];
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"App/verify" withParamDictionary:@{@"mobile":_textFieldForPhone.text} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [SVProgressHUD dismiss];
            _buttonForGetCaptcha.enabled = NO;
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
                            [strongSelf.buttonForGetCaptcha setTitle:@"获取验证码" forState:(UIControlStateNormal)];
                            [strongSelf.buttonForGetCaptcha setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            [strongSelf.buttonForGetCaptcha setBackgroundColor:RGBA(216, 45, 50, 1.0)];
                            strongSelf.buttonForGetCaptcha.enabled = YES;
                        });
                    }else{
                        int seconds = timeout % 60;
                        if (timeout == 60) {
                            seconds = 60;
                        }
                        NSString *strTime = [NSString stringWithFormat:@"%.2d秒后重发", seconds];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //设置界面的按钮显示 根据自己需求设置
                            [strongSelf.buttonForGetCaptcha setTitle:strTime forState:(UIControlStateNormal)];
                            [strongSelf.buttonForGetCaptcha setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                            [strongSelf.buttonForGetCaptcha setBackgroundColor:RGBA(179, 179, 179, 1.0)];
                        });
                        timeout--;
                    }
                    
                }
            });
            dispatch_resume(_timer);
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

- (void)confirmMethod{
    if ([_textFieldForPhone.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
        return;
    }
    if ([_textFieldForCaptcha.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
        return;
    }
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"User/chanMob" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid,@"new_mobile":_textFieldForPhone.text} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [_viewForHa removeFromSuperview];
            if (self.modifyPhoneDelegate && [self.modifyPhoneDelegate respondsToSelector:@selector(changeUserPhoneSuccessMethod:)]) {
                [self.modifyPhoneDelegate changeUserPhoneSuccessMethod:_textFieldForPhone.text];
            }
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

- (void)cancelMethod{
    [_viewForHa removeFromSuperview];
    [self removeFromSuperview];
}

@end
