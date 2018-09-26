//
//  ReleaseCardDirectlyView.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/12/26.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "ReleaseCardDirectlyView.h"

@interface ReleaseCardDirectlyView ()

@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation ReleaseCardDirectlyView

- (instancetype)initWithBankName:(NSString *)bankName withBankNumber:(NSString *)bankNumber {
    self = [super init];
    if (self) {
        _blackView = [[UIView alloc]init];
        _blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
        [self addSubview:_blackView];
        [_blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeAllControl)];
        [_blackView addGestureRecognizer:_tap];
        
        _whiteView = [[UIView alloc]init];
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.layer.masksToBounds = YES;
        _whiteView.layer.cornerRadius = RESIZE_UI(10);
        [_blackView addSubview:_whiteView];
        [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_blackView.mas_centerX);
            make.centerY.equalTo(_blackView.mas_centerY);
            make.height.mas_offset(RESIZE_UI(224));
            make.width.mas_offset(RESIZE_UI(304));
        }];
        
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.text = [NSString stringWithFormat:@"您将要解绑尾号为%@的%@卡，解绑后不可进行出借，确认要解绑?",bankNumber,bankName];
        _tipLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
        _tipLabel.numberOfLines = 3;
        _tipLabel.textColor = RGBA(102, 102, 102, 1.0);
        [_whiteView addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(RESIZE_UI(268));
            make.height.mas_offset(RESIZE_UI(72));
            make.top.equalTo(_whiteView.mas_top).with.offset(RESIZE_UI(44));
            make.centerX.equalTo(_whiteView.mas_centerX);
        }];
        
        _leftButton = [[UIButton alloc]init];
        [_leftButton setTitle:@"取消" forState:UIControlStateNormal];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
        [_leftButton setTitleColor:RGBA(0, 104, 178, 1.0) forState:UIControlStateNormal];
        [_leftButton setBackgroundColor:RGBA(230, 245, 255, 1.0)];
        _leftButton.layer.borderWidth = 1.0;
        _leftButton.layer.borderColor = RGBA(0, 104, 178, 1.0).CGColor;
        [_leftButton addTarget:self action:@selector(removeAllControl) forControlEvents:UIControlEventTouchUpInside];
        [_whiteView addSubview:_leftButton];
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_whiteView.mas_bottom).with.offset(RESIZE_UI(-15));
            make.left.equalTo(_whiteView.mas_left).with.offset(RESIZE_UI(20));
            make.width.mas_offset(RESIZE_UI(115));
            make.height.mas_offset(RESIZE_UI(44));
        }];
        
        _rightButton = [[UIButton alloc]init];
        [_rightButton setBackgroundColor:RGBA(0, 104, 178, 1.0)];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton setTitle:@"确认解绑" forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
        [_rightButton addTarget:self action:@selector(confirmReleaseMethod) forControlEvents:UIControlEventTouchUpInside];
        [_whiteView addSubview:_rightButton];
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_whiteView.mas_bottom).with.offset(RESIZE_UI(-15));
            make.right.equalTo(_whiteView.mas_right).with.offset(RESIZE_UI(-20));
            make.width.mas_offset(RESIZE_UI(115));
            make.height.mas_offset(RESIZE_UI(44));
        }];
        
        
        
    }
    return self;
}

#pragma mark - 确认解绑
- (void)confirmReleaseMethod {
    [self removeAllControl];
    if (self.confirmRelease) {
        self.confirmRelease();
    }
}

- (void)removeAllControl {
    [_rightButton removeFromSuperview];
    _rightButton = nil;
    [_leftButton removeFromSuperview];
    _leftButton = nil;
    [_tipLabel removeFromSuperview];
    _tipLabel = nil;
    [_whiteView removeFromSuperview];
    _whiteView = nil;
    [_blackView removeGestureRecognizer:_tap];
    _tap = nil;
    [_blackView removeFromSuperview];
    _blackView = nil;
    [self removeFromSuperview];
}

@end
