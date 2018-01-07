//
//  ConfirmReleaseCardView.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/3.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "ConfirmReleaseCardView.h"

@interface ConfirmReleaseCardView ()

@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *tipLabel2;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation ConfirmReleaseCardView

- (instancetype)init {
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
            make.height.mas_offset(RESIZE_UI(321));
            make.width.mas_offset(RESIZE_UI(304));
        }];
        
        _topImageView = [[UIImageView alloc]init];
        _topImageView.image = [UIImage imageNamed:@"image_tj"];
        [_whiteView addSubview:_topImageView];
        [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_whiteView.mas_top).with.offset(RESIZE_UI(50));
            make.width.mas_offset(RESIZE_UI(160));
            make.height.mas_offset(RESIZE_UI(110));
            make.centerX.equalTo(_whiteView.mas_centerX);
        }];
        
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.text = @"申请提交后将不可撤销";
        _tipLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        _tipLabel.numberOfLines = 3;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = RGBA(102, 102, 102, 1.0);
        [_whiteView addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(RESIZE_UI(184));
            make.top.equalTo(_topImageView.mas_bottom).with.offset(RESIZE_UI(16));
            make.centerX.equalTo(_whiteView.mas_centerX);
        }];
        
        _tipLabel2 = [[UILabel alloc]init];
        _tipLabel2.text = @"请谨慎选择";
        _tipLabel2.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        _tipLabel2.textAlignment = NSTextAlignmentCenter;
        _tipLabel2.numberOfLines = 3;
        _tipLabel2.textColor = RGBA(102, 102, 102, 1.0);
        [_whiteView addSubview:_tipLabel2];
        [_tipLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(RESIZE_UI(184));
            make.top.equalTo(_tipLabel.mas_bottom);
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
