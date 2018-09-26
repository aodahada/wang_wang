//
//  InvestConfirmView.m
//  WmjrApp
//
//  Created by horry on 2016/10/13.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "InvestConfirmView.h"

@interface InvestConfirmView ()

@property (nonatomic, assign) BOOL isAgree;//是否同意协议标识
@property (nonatomic, strong) UIButton *buttonForNext;
@property (nonatomic, assign) BOOL canPay;

@end

@implementation InvestConfirmView

- (instancetype)initWithInvestMoney:(NSString *)investMoney restMoney:(NSString *)restMoney {
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _isAgree = YES;
        CGFloat investMoneyFlo = [investMoney floatValue];
        CGFloat restMoneyFlo = [restMoney floatValue];
        if (restMoneyFlo>=investMoneyFlo) {
            self.canPay = YES;
        } else {
            self.canPay = NO;
        }
        
        UILabel *labelForTitle = [[UILabel alloc]init];
        labelForTitle.text = @"出借确认";
        labelForTitle.font = [UIFont systemFontOfSize:19];
        [self addSubview:labelForTitle];
        [labelForTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(21);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        UIButton *imageViewForClose = [[UIButton alloc]init];
        [imageViewForClose setBackgroundImage:[UIImage imageNamed:@"icon_investback"] forState:UIControlStateNormal];
        [imageViewForClose addTarget:self action:@selector(closeButtonMethod) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:imageViewForClose];
        [imageViewForClose mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(labelForTitle.mas_centerY);
            make.left.equalTo(self.mas_left).with.offset(18);
            make.height.width.mas_offset(19.7);
        }];
        
        UILabel *labelForLine1 = [[UILabel alloc]init];
        labelForLine1.backgroundColor = RGBA(240, 240, 240, 1.0);
        [self addSubview:labelForLine1];
        [labelForLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(69);
            make.height.mas_offset(1);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }];
        
        UILabel *labelForInvesMoneyTitle = [[UILabel alloc]init];
        labelForInvesMoneyTitle.text = @"出借金额";
        labelForInvesMoneyTitle.textColor = RGBA(102, 102, 102, 1.0);
        labelForInvesMoneyTitle.font = [UIFont systemFontOfSize:16];
        [self addSubview:labelForInvesMoneyTitle];
        [labelForInvesMoneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(86);
            make.left.equalTo(self.mas_left).with.offset(14);
        }];
        
        UILabel *labelForInvestMoney = [[UILabel alloc]init];
        labelForInvestMoney.text = [NSString stringWithFormat:@"￥%@",investMoney];
        labelForInvestMoney.font = [UIFont systemFontOfSize:16];
        labelForInvestMoney.textColor = RGBA(51, 51, 51, 1.0);
        [self addSubview:labelForInvestMoney];
        [labelForInvestMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(labelForInvesMoneyTitle.mas_centerY);
            make.right.equalTo(self.mas_right).with.offset(-24);
        }];
        
        UILabel *labelForLine2 = [[UILabel alloc]init];
        labelForLine2.backgroundColor = RGBA(240, 240, 240, 1.0);
        [self addSubview:labelForLine2];
        [labelForLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(117.5);
            make.height.mas_offset(1);
            make.left.equalTo(self.mas_left).with.offset(12.5);
            make.right.equalTo(self.mas_right);
        }];
        
        UILabel *labelForPayMethod = [[UILabel alloc]init];
        labelForPayMethod.text = @"付款方式";
        labelForPayMethod.textColor = RGBA(102, 102, 102, 1.0);
        labelForPayMethod.font = [UIFont systemFontOfSize:16];
        [self addSubview:labelForPayMethod];
        [labelForPayMethod mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(144);
            make.left.equalTo(self.mas_left).with.offset(14);
        }];
        
        UILabel *labelForRestPay = [[UILabel alloc]init];
        labelForRestPay.text = @"余额支付";
        labelForRestPay.textColor = RGBA(102, 102, 102, 1.0);
        labelForRestPay.font = [UIFont systemFontOfSize:17];
        [self addSubview:labelForRestPay];
        [labelForRestPay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(136);
            make.right.equalTo(self.mas_right).with.offset(-24);
        }];
        
        UILabel *labelForCurrentRestMoenty = [[UILabel alloc]init];
        labelForCurrentRestMoenty.textColor = RGBA(75, 151, 217, 1.0);
        labelForCurrentRestMoenty.font = [UIFont systemFontOfSize:12];
        labelForCurrentRestMoenty.text = [NSString stringWithFormat:@"￥%@",restMoney];
        [self addSubview:labelForCurrentRestMoenty];
        [labelForCurrentRestMoenty mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(157);
            make.right.equalTo(self.mas_right).with.offset(-24);
        }];
        
        UILabel *labelForCurrentRestTitle = [[UILabel alloc]init];
        labelForCurrentRestTitle.textColor = RGBA(153, 153, 153, 1.0);
        labelForCurrentRestTitle.text = @"当前余额";
        labelForCurrentRestTitle.font = [UIFont systemFontOfSize:12];
        [self addSubview:labelForCurrentRestTitle];
        [labelForCurrentRestTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(labelForCurrentRestMoenty.mas_top);
            make.bottom.equalTo(labelForCurrentRestMoenty.mas_bottom);
            make.right.equalTo(labelForCurrentRestMoenty.mas_left);
        }];
        
        UILabel *labelForLine3 = [[UILabel alloc]init];
        labelForLine3.backgroundColor = RGBA(240, 240, 240, 1.0);
        [self addSubview:labelForLine3];
        [labelForLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(184.5);
            make.height.mas_offset(1);
            make.left.equalTo(self.mas_left).with.offset(12.5);
            make.right.equalTo(self.mas_right);
        }];
        
        UIButton *buttonForGou = [[UIButton alloc]init];
        [buttonForGou setBackgroundImage:[UIImage imageNamed:@"icon_investdagou"] forState:UIControlStateNormal];
        [buttonForGou addTarget:self action:@selector(buttonForIsAgreeMethod:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonForGou];
        [buttonForGou mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(222);
            make.left.equalTo(self.mas_left).with.offset(14);
            make.height.width.mas_offset(16);
        }];
        
        UILabel *labelForReadDelegate = [[UILabel alloc]init];
        labelForReadDelegate.text = @"我已阅读并同意平台";
        labelForReadDelegate.font = [UIFont systemFontOfSize:12];
        [self addSubview:labelForReadDelegate];
        [labelForReadDelegate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(38);
            make.centerY.equalTo(buttonForGou.mas_centerY);
        }];
        
        UIButton *buttonForDelegate = [[UIButton alloc]init];
        [buttonForDelegate setTitle:@"《交易协议》" forState:UIControlStateNormal];
        [buttonForDelegate setTitleColor:RGBA(75, 151, 217, 1.0) forState:UIControlStateNormal];
        buttonForDelegate.titleLabel.font = [UIFont systemFontOfSize:12];
        [buttonForDelegate addTarget:self action:@selector(readDelegateMethod) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonForDelegate];
        [buttonForDelegate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(labelForReadDelegate.mas_centerY);
            make.left.equalTo(labelForReadDelegate.mas_right);
            make.height.mas_equalTo(labelForReadDelegate.mas_height);
            make.width.mas_offset(80);
        }];
        
        _buttonForNext = [[UIButton alloc]init];
        [_buttonForNext setTitle:@"下一步" forState:UIControlStateNormal];
        [_buttonForNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buttonForNext.titleLabel.font = [UIFont systemFontOfSize:17];
        [_buttonForNext setBackgroundColor:RGBA(245, 89, 21, 1.0)];
        [_buttonForNext addTarget:self action:@selector(nextButtonMethod) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_buttonForNext];
        [_buttonForNext mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(257);
            make.bottom.equalTo(self.mas_bottom).with.offset(-18);
            make.left.equalTo(self.mas_left).with.offset(12);
            make.right.equalTo(self.mas_right).with.offset(-12);
        }];

    }
    return self;
    
}

- (void)closeButtonMethod {
    if (self.closeViewMethod) {
        self.closeViewMethod();
    }
}

- (void)readDelegateMethod {
    if (self.jumToReadDelegate) {
        self.jumToReadDelegate();
    }
}

#pragma mark - 是否同意协议按钮
- (void)buttonForIsAgreeMethod:(id)sender {
    
    if (!_isAgree) {
        
        _isAgree = YES;
        [sender setBackgroundImage:[UIImage imageNamed:@"icon_investdagou"] forState:UIControlStateNormal];
        _buttonForNext.userInteractionEnabled = YES;
        [_buttonForNext setBackgroundColor:RGBA(245, 89, 21, 1.0)];
        
    } else {
        
        _isAgree = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"icon_investquan"] forState:UIControlStateNormal];
        _buttonForNext.userInteractionEnabled = NO;
        [_buttonForNext setBackgroundColor:RGBA(201, 201, 201, 1.0)];
        
    }
    
}

- (void)nextButtonMethod {
    if (self.buttonNextMethod) {
        self.buttonNextMethod(self.canPay);
    }
}

@end
