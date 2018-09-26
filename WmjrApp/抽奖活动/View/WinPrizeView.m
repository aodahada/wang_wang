//
//  WinPrizeView.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/12/14.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "WinPrizeView.h"
#import "LotteryModel.h"

@interface WinPrizeView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *prizeImageView;
@property (nonatomic, strong) UIButton *exchangeButton;
@property (nonatomic, strong) UIButton *justSaveButton;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation WinPrizeView

- (instancetype)initWithLotteryModel:(LotteryModel *)lotteryModel {
    self = [super init];
    if (self) {
        
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [self addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(justSaveMethod)];
        [_backView addGestureRecognizer:_tap];
        
        _prizeImageView = [[UIImageView alloc]init];
        _prizeImageView.userInteractionEnabled = YES;
        _prizeImageView.image = [UIImage imageNamed:@"兑换弹窗"];
        [_backView addSubview:_prizeImageView];
        [_prizeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_backView.mas_centerX);
            make.centerY.equalTo(_backView.mas_centerY);
            make.width.height.mas_offset(RESIZE_UI(288));
        }];
        
        UILabel *gongxiLabel = [[UILabel alloc]init];
        gongxiLabel.text = @"恭喜您";
        [gongxiLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(28)]];
        gongxiLabel.textColor = RGBA(252, 232, 78, 1.0);
        [_prizeImageView addSubview:gongxiLabel];
        [gongxiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_prizeImageView.mas_centerX);
            make.top.equalTo(_prizeImageView.mas_top).with.offset(RESIZE_UI(70));
        }];
        
        UILabel *huodeLabel = [[UILabel alloc]init];
        NSString *type;//1.现金红包 2.全国流量 3.尊享积分
        if ([lotteryModel.type isEqualToString:@"1"]) {
            type = @"现金红包";
        } else if ([lotteryModel.type isEqualToString:@"2"]) {
            type = @"全国流量";
        } else {
            type = @"尊享积分";
        }
        NSString *huodeLabelContent = [NSString stringWithFormat:@"获得%@%@",lotteryModel.value,type];
        huodeLabel.attributedText =  [self changeStringWithString:huodeLabelContent withFrontColor:[UIColor whiteColor] WithBehindColor:RGBA(252, 232, 78, 1.0) withFrontFont:[UIFont systemFontOfSize:RESIZE_UI(20)] WithBehindFont:[UIFont systemFontOfSize:RESIZE_UI(28)]];
        [_prizeImageView addSubview:huodeLabel];
        [huodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(gongxiLabel.mas_bottom).with.offset(RESIZE_UI(30));
            make.centerX.equalTo(_prizeImageView.mas_centerX);
        }];
        
        _exchangeButton = [[UIButton alloc]init];
        [_exchangeButton setBackgroundImage:[UIImage imageNamed:@"btn_ljdh"] forState:UIControlStateNormal];
        [_exchangeButton addTarget:self action:@selector(exchangPrizeMethod) forControlEvents:UIControlEventTouchUpInside];
        [_prizeImageView addSubview:_exchangeButton];
        [_exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(RESIZE_UI(98));
            make.height.mas_offset(RESIZE_UI(30));
            make.left.equalTo(_prizeImageView.mas_left).with.offset(RESIZE_UI(30));
            make.bottom.equalTo(_prizeImageView.mas_bottom).with.offset(-RESIZE_UI(40));
        }];
        
        _justSaveButton = [[UIButton alloc]init];
        [_justSaveButton setBackgroundImage:[UIImage imageNamed:@"btn_xcz"] forState:UIControlStateNormal];
        [_justSaveButton addTarget:self action:@selector(justSaveMethod) forControlEvents:UIControlEventTouchUpInside];
        [_prizeImageView addSubview:_justSaveButton];
        [_justSaveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(RESIZE_UI(98));
            make.height.mas_offset(RESIZE_UI(30));
            make.right.equalTo(_prizeImageView.mas_right).with.offset(-RESIZE_UI(30));
            make.bottom.equalTo(_prizeImageView.mas_bottom).with.offset(-RESIZE_UI(40));
        }];
        
    }
    return self;
}

- (NSAttributedString *)changeStringWithString:(NSString *)string withFrontColor:(UIColor *)frontColor WithBehindColor:(UIColor *)behindColor withFrontFont:(UIFont *)frontFont WithBehindFont:(UIFont *)behindFont {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:frontColor range:NSMakeRange(0, 2)];
    [str addAttribute:NSForegroundColorAttributeName value:frontColor range:NSMakeRange(string.length-4, 4)];
    [str addAttribute:NSForegroundColorAttributeName value:behindColor range:NSMakeRange(2, string.length-6)];
    [str addAttribute:NSFontAttributeName value:frontFont range:NSMakeRange(0, 2)];
    [str addAttribute:NSFontAttributeName value:frontFont range:NSMakeRange(string.length-4, 4)];
    [str addAttribute:NSFontAttributeName value:behindFont range:NSMakeRange(2, string.length-6)];
    return str;
}


#pragma mark - 兑奖
- (void)exchangPrizeMethod {
    [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        [self justSaveMethod];
    } title:@"兑换成功!" message:@"" cancelButtonName:@"好的" otherButtonTitles:nil, nil];
}

#pragma mark - 先存着
- (void)justSaveMethod {
    [_justSaveButton removeFromSuperview];
    _justSaveButton = nil;
    [_exchangeButton removeFromSuperview];
    _exchangeButton = nil;
    [_prizeImageView removeFromSuperview];
    _prizeImageView = nil;
    [_backView removeGestureRecognizer:_tap];
    _tap = nil;
    [_backView removeFromSuperview];
    _backView = nil;
    [self removeFromSuperview];
}

@end
