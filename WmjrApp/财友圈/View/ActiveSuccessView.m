//
//  ActiveSuccessView.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/29.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "ActiveSuccessView.h"

@interface ActiveSuccessView ()

@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *tipContentLabel;

@end

@implementation ActiveSuccessView

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
        _topImageView.image = [UIImage imageNamed:@"icon_done"];
        [_whiteView addSubview:_topImageView];
        [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_whiteView.mas_top).with.offset(RESIZE_UI(44));
            make.width.height.mas_offset(RESIZE_UI(100));
            make.centerX.equalTo(_whiteView.mas_centerX);
        }];
        
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.text = @"领取成功!";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:RESIZE_UI(22)];
        _tipLabel.textColor = RGBA(52, 43, 43, 1.0);
        [_whiteView addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topImageView.mas_bottom).with.offset(RESIZE_UI(29));
            make.centerX.equalTo(_whiteView.mas_centerX);
        }];
        
        _tipContentLabel = [[UILabel alloc]init];
        _tipContentLabel.text = @"请前往账户中心,可用余额查看";
        _tipContentLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        _tipContentLabel.textColor = RGBA(153, 153, 153, 1.0);
        [_whiteView addSubview:_tipContentLabel];
        [_tipContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tipLabel.mas_bottom).with.offset(RESIZE_UI(15));
            make.centerX.equalTo(_tipLabel.mas_centerX);
        }];
        
        [self performSelector:@selector(removeAllControl) withObject:nil afterDelay:2];
        
    }
    return self;
}

- (void)removeAllControl {
    [_tipContentLabel removeFromSuperview];
    _tipContentLabel = nil;
    [_tipLabel removeFromSuperview];
    _tipLabel = nil;
    [_whiteView removeFromSuperview];
    _whiteView = nil;
    [_blackView removeGestureRecognizer:_tap];
    _tap = nil;
    [_blackView removeFromSuperview];
    _blackView = nil;
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(backToRoot)]) {
        [self.delegate backToRoot];
    }
}


@end

