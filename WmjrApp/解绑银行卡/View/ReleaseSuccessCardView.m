//
//  ReleaseSuccessCardView.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/3.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "ReleaseSuccessCardView.h"

@interface ReleaseSuccessCardView ()

@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation ReleaseSuccessCardView

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
            make.height.mas_offset(RESIZE_UI(304));
            make.width.mas_offset(RESIZE_UI(304));
        }];
        
        _topImageView = [[UIImageView alloc]init];
        _topImageView.image = [UIImage imageNamed:@"Group"];
        [_whiteView addSubview:_topImageView];
        [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_whiteView.mas_top).with.offset(RESIZE_UI(35));
            make.width.mas_offset(RESIZE_UI(104));
            make.height.mas_offset(RESIZE_UI(140));
            make.centerX.equalTo(_whiteView.mas_centerX);
        }];
        
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.text = @"解绑成功!";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        _tipLabel.numberOfLines = 3;
        _tipLabel.textColor = RGBA(102, 102, 102, 1.0);
        [_whiteView addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topImageView.mas_bottom).with.offset(RESIZE_UI(9));
            make.centerX.equalTo(_whiteView.mas_centerX);
        }];
        
        _leftButton = [[UIButton alloc]init];
        [_leftButton setTitle:@"确定" forState:UIControlStateNormal];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
        [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftButton setBackgroundColor:RGBA(0, 104, 178, 1.0)];
        [_leftButton addTarget:self action:@selector(confirMethod) forControlEvents:UIControlEventTouchUpInside];
        [_whiteView addSubview:_leftButton];
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_whiteView.mas_bottom).with.offset(RESIZE_UI(-15));
            make.centerX.equalTo(_whiteView.mas_centerX);
            make.width.mas_offset(RESIZE_UI(264));
            make.height.mas_offset(RESIZE_UI(44));
        }];
        
    }
    return self;
}

#pragma mark - 确定按钮
- (void)confirMethod {
    [self removeAllControl];
    [self performSelector:@selector(relaeaseSuccessMethod) withObject:nil afterDelay:0.1];
}

- (void)relaeaseSuccessMethod {
    if (self.releaseSuccess) {
        self.releaseSuccess();
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
