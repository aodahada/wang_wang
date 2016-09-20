//
//  ModifyGesPassView.m
//  WmjrApp
//
//  Created by horry on 16/9/5.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "ModifyGesPassView.h"

@interface ModifyGesPassView ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation ModifyGesPassView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *labelForTitle = [[UILabel alloc]init];
        labelForTitle.text = @"修改手势密码";
        labelForTitle.textAlignment = NSTextAlignmentCenter;
        labelForTitle.textColor = RGBA(173, 173, 173, 1.0);
        labelForTitle.font = [UIFont systemFontOfSize:16];
        [self addSubview:labelForTitle];
        [labelForTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left).with.offset(50);
            make.right.equalTo(self.mas_right).with.offset(-50);
            make.height.mas_offset(44);
        }];
        
        UIButton *buttonForCancel = [[UIButton alloc]init];
        [buttonForCancel setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [buttonForCancel addTarget:self action:@selector(buttonForCancelMethod) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonForCancel];
        [buttonForCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(labelForTitle.mas_centerY);
            make.height.width.mas_offset(20);
            make.right.equalTo(self.mas_right).with.offset(-5);
        }];
        
        //分割线
        UILabel *labelForLine = [[UILabel alloc]init];
        labelForLine.backgroundColor = RGBA(234, 234, 234, 1.0);
        [self addSubview:labelForLine];
        [labelForLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(labelForTitle.mas_bottom);
            make.height.mas_offset(1);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }];
        
        //副标题
        UILabel *labelForUnderTitle = [[UILabel alloc]init];
        labelForUnderTitle.text = @"请输入旺马财富登录密码";
        labelForUnderTitle.font = [UIFont systemFontOfSize:16];
        labelForUnderTitle.textAlignment  =NSTextAlignmentCenter;
        [self addSubview:labelForUnderTitle];
        [labelForUnderTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(labelForLine.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_offset(50);
        }];
        
        //输入框
        _textField = [[UITextField alloc]init];
        _textField.layer.borderWidth = 1.0f;
        _textField.layer.borderColor = RGBA(234, 234, 234, 1.0).CGColor;
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.placeholder = @"请输入密码";
        [_textField setSecureTextEntry:YES];
        [self addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(30);
            make.right.equalTo(self.mas_right).with.offset(-30);
            make.height.mas_offset(44);
            make.top.equalTo(labelForUnderTitle.mas_bottom);
        }];
        
        //取消按钮
        UIButton *buttonForDelete = [[UIButton alloc]init];
        buttonForDelete.layer.borderWidth = 0.5f;
        buttonForDelete.layer.borderColor = RGBA(234, 234, 234, 1.0).CGColor;
        [buttonForDelete setTitleColor:RGBA(51, 51, 51, 1.0) forState:UIControlStateNormal];
        [buttonForDelete setTitle:@"取消" forState:UIControlStateNormal];
        buttonForDelete.titleLabel.font = [UIFont systemFontOfSize:17];
        [buttonForDelete addTarget:self action:@selector(buttonForCancelMethod) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:buttonForDelete];
        [buttonForDelete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.width.mas_offset(150);
            make.height.mas_offset(50);
        }];
        
        //确定按钮
        UIButton *buttonForConfirm = [[UIButton alloc]init];
        buttonForConfirm.layer.borderWidth = 0.5f;
        buttonForConfirm.layer.borderColor = RGBA(234, 234, 234, 1.0).CGColor;
        [buttonForConfirm setTitleColor:RGBA(51, 51, 51, 1.0) forState:UIControlStateNormal];
        [buttonForConfirm setTitle:@"确定" forState:UIControlStateNormal];
        buttonForConfirm.titleLabel.font = [UIFont systemFontOfSize:17];
        [buttonForConfirm addTarget:self action:@selector(buttonForConfirmMethod) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonForConfirm];
        [buttonForConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
            make.width.mas_offset(150);
            make.height.mas_offset(50);
        }];
        
    }
    return self;
}

- (void)buttonForCancelMethod {
    
    if (self.cancelModifyView) {
        self.cancelModifyView();
    }
    
}

- (void)buttonForConfirmMethod {
    
    if ([_textField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
    } else {
        NetManager *manager = [[NetManager alloc] init];
        [SVProgressHUD showWithStatus:@"验证密码中"];
        [manager postDataWithUrlActionStr:@"User/login" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"pwd":_textField.text} withBlock:^(id obj) {
            if (obj) {
                if ([obj[@"result"] isEqualToString:@"1"]) {

                    [SVProgressHUD showSuccessWithStatus:@"验证成功"];
                    if (self.canThroughPass) {
                        self.canThroughPass();
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
    
}

@end
