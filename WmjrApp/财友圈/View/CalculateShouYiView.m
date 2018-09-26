//
//  CalculateShouYiView.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/29.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "CalculateShouYiView.h"

@interface CalculateShouYiView()

@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UIImageView *calculateImage;
@property (nonatomic, strong)UILabel *calculateTitle;
@property (nonatomic, strong)UIButton *closeButton;
@property (nonatomic, strong)UITapGestureRecognizer *tap;
@property (nonatomic, strong)UILabel *haoyoutouziLabel;
@property (nonatomic, strong)UITextField *haoyoutouziContent;
@property (nonatomic, strong)UILabel *yujitouziLabel;
@property (nonatomic, strong)UITextField *yujitouziContent;
@property (nonatomic, strong)UILabel *yujicaiyouLabel;
@property (nonatomic, strong)UILabel *yujicaiyouContent;
@property (nonatomic, strong)UILabel *lineLabel;
@property (nonatomic, strong)UILabel *tipLabel;
@property (nonatomic, strong)UIButton *calculateButton;

@end

@implementation CalculateShouYiView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
        
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endSelfMethod)];
        [self addGestureRecognizer:_tap];
        
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_offset(RESIZE_UI(375));
        }];
        
        _calculateImage = [[UIImageView alloc]init];
        _calculateImage.image = [UIImage imageNamed:@"icon_syjsq"];
        [_bottomView addSubview:_calculateImage];
        [_calculateImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomView.mas_top).with.offset(RESIZE_UI(23));
            make.left.equalTo(_bottomView.mas_left).with.offset(RESIZE_UI(130));
            make.width.mas_offset(RESIZE_UI(23));
            make.height.mas_offset(RESIZE_UI(26));
        }];
        
        _calculateTitle = [[UILabel alloc]init];
        _calculateTitle.text = @"收益计算器";
        _calculateTitle.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
        [_bottomView addSubview:_calculateTitle];
        [_calculateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_calculateImage.mas_centerY);
            make.left.equalTo(_calculateImage.mas_right).with.offset(RESIZE_UI(14.5));
        }];
        
        _closeButton = [[UIButton alloc]init];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"caiyouquanclose"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(endSelfMethod) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomView.mas_top).with.offset(RESIZE_UI(15));
            make.right.equalTo(_bottomView.mas_right).with.offset(-RESIZE_UI(15));
            make.height.width.mas_offset(RESIZE_UI(15));
        }];
        
        _haoyoutouziLabel = [[UILabel alloc]init];
        _haoyoutouziLabel.text = @"好友出借金额";
        _haoyoutouziLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
        [_bottomView addSubview:_haoyoutouziLabel];
        [_haoyoutouziLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomView.mas_top).with.offset(RESIZE_UI(100));
            make.left.equalTo(_bottomView.mas_left).with.offset(RESIZE_UI(54));
        }];
        
        _haoyoutouziContent = [[UITextField alloc]init];
        _haoyoutouziContent.layer.borderColor = NAVBARCOLOR.CGColor;
        _haoyoutouziContent.layer.borderWidth = 1.0f;
        [_haoyoutouziContent.layer setMasksToBounds:YES];
        _haoyoutouziContent.layer.cornerRadius = RESIZE_UI(5);
        _haoyoutouziContent.keyboardType = UIKeyboardTypeDecimalPad;
        [_bottomView addSubview:_haoyoutouziContent];
        [_haoyoutouziContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_haoyoutouziLabel.mas_centerY);
            make.right.equalTo(_bottomView.mas_right).with.offset(-RESIZE_UI(41));
            make.width.mas_offset(RESIZE_UI(130));
            make.height.mas_offset(RESIZE_UI(28));
        }];
        
        _yujitouziLabel = [[UILabel alloc]init];
        _yujitouziLabel.text = @"预计出借天数";
        _yujitouziLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
        [_bottomView addSubview:_yujitouziLabel];
        [_yujitouziLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_haoyoutouziLabel.mas_bottom).with.offset(RESIZE_UI(35));
            make.left.equalTo(_haoyoutouziLabel.mas_left);
        }];
        
        _yujitouziContent = [[UITextField alloc]init];
        _yujitouziContent.layer.borderColor = NAVBARCOLOR.CGColor;
        _yujitouziContent.layer.borderWidth = 1.0f;
        [_yujitouziContent.layer setMasksToBounds:YES];
        _yujitouziContent.layer.cornerRadius = RESIZE_UI(5);
        _yujitouziContent.keyboardType = UIKeyboardTypeDecimalPad;
        [_bottomView addSubview:_yujitouziContent];
        [_yujitouziContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_yujitouziLabel.mas_centerY);
            make.right.equalTo(_haoyoutouziContent.mas_right);
            make.width.mas_offset(RESIZE_UI(130));
            make.height.mas_offset(RESIZE_UI(28));
        }];
        
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = RGBA(215, 216, 217, 1.0);
        [_bottomView addSubview:_lineLabel];
        [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_yujitouziContent.mas_bottom).with.offset(RESIZE_UI(24));
            make.left.equalTo(_bottomView.mas_left).with.offset(RESIZE_UI(50));
            make.right.equalTo(_bottomView.mas_right).with.offset(-RESIZE_UI(50));
            make.height.mas_offset(1);
        }];
        
        _yujicaiyouLabel = [[UILabel alloc]init];
        _yujicaiyouLabel.text = @"预计财友收益";
        _yujicaiyouLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
        [_bottomView addSubview:_yujicaiyouLabel];
        [_yujicaiyouLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_lineLabel.mas_bottom).with.offset(RESIZE_UI(20.5));
            make.left.equalTo(_haoyoutouziLabel.mas_left);
        }];
        
        _yujicaiyouContent = [[UILabel alloc]init];
        _yujicaiyouContent.text = @"0.00";
        _yujicaiyouContent.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
        _yujicaiyouContent.textColor = NAVBARCOLOR;
        [_bottomView addSubview:_yujicaiyouContent];
        [_yujicaiyouContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_yujicaiyouLabel.mas_centerY);
            make.right.equalTo(_bottomView.mas_right).with.offset(-RESIZE_UI(78));
        }];
        
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.numberOfLines = 2;
        _tipLabel.text = @"提示：计算结果仅作为预计获得的理论财友收益参考，具体以实际获得为准～";
        _tipLabel.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        _tipLabel.textColor = RGBA(191, 194, 195, 1.0);
        [_bottomView addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_yujicaiyouLabel.mas_bottom).with.offset(RESIZE_UI(24));
            make.left.equalTo(_haoyoutouziLabel.mas_left);
            make.right.equalTo(_haoyoutouziContent.mas_right);
            make.height.mas_offset(RESIZE_UI(32));
        }];
        
        _calculateButton = [[UIButton alloc]init];
        [_calculateButton setBackgroundColor:NAVBARCOLOR];
        [_calculateButton setTitle:@"计算" forState:UIControlStateNormal];
        [_calculateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _calculateButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
        [_calculateButton addTarget:self action:@selector(calculateMethod) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_calculateButton];
        [_calculateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_bottomView.mas_bottom).with.offset(-RESIZE_UI(21));
            make.centerX.equalTo(_bottomView.mas_centerX);
            make.width.mas_offset(RESIZE_UI(170));
            make.height.mas_offset(RESIZE_UI(31));
        }];
        
    }
    return self;
}

#pragma mark - 计算器
- (void)calculateMethod {
    CGFloat investMoney = [_haoyoutouziContent.text floatValue];
    CGFloat investDay = [_yujitouziContent.text floatValue];
//    100000 * 300/365 * 2% * 7/11 =
    CGFloat result = investMoney*investDay/365*0.02*7/11;
    _yujicaiyouContent.text = [SingletonManager notRounding:result afterPoint:2];
}

- (void)endSelfMethod {
    [_closeButton removeFromSuperview];
    _closeButton = nil;
    [_calculateTitle removeFromSuperview];
    _calculateTitle = nil;
    [_calculateImage removeFromSuperview];
    _calculateImage = nil;
    [_bottomView removeFromSuperview];
    _bottomView = nil;
    [self removeGestureRecognizer:_tap];
    _tap = nil;
    [_haoyoutouziLabel removeFromSuperview];
    _haoyoutouziLabel = nil;
    [_haoyoutouziContent removeFromSuperview];
    _haoyoutouziContent = nil;
    [_yujitouziLabel removeFromSuperview];
    _yujitouziLabel = nil;
    [_yujitouziContent removeFromSuperview];
    _yujitouziContent = nil;
    [_lineLabel removeFromSuperview];
    _lineLabel = nil;
    [_yujicaiyouLabel removeFromSuperview];
    _yujicaiyouLabel = nil;
    [_yujicaiyouContent removeFromSuperview];
    _yujicaiyouContent = nil;
    [_tipLabel removeFromSuperview];
    _tipLabel = nil;
    [_calculateButton removeFromSuperview];
    _calculateButton = nil;
    [self removeFromSuperview];
}

@end
