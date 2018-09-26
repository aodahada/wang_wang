//
//  NationalActivityView.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/9/25.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "NationalActivityView.h"

@interface NationalActivityView ()
{
    UIImageView *activityImageView;
    UIButton *qiangButton;
}

@end

@implementation NationalActivityView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
        
        activityImageView = [[UIImageView alloc]init];
        activityImageView.image = [UIImage imageNamed:@"guoqing_tanchuan01"];
        activityImageView.userInteractionEnabled = YES;
        [self addSubview:activityImageView];
        [activityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_offset(RESIZE_UI(279));
            make.height.mas_offset(RESIZE_UI(321));
        }];
        
        qiangButton = [[UIButton alloc]init];
        [qiangButton setBackgroundImage:[UIImage imageNamed:@"guoqing_button"] forState:UIControlStateNormal];
        [qiangButton addTarget:self action:@selector(likeqiangMethod) forControlEvents:UIControlEventTouchUpInside];
        [activityImageView addSubview:qiangButton];
        [qiangButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(activityImageView.mas_bottom).with.offset(-RESIZE_UI(25));
            make.centerX.equalTo(activityImageView.mas_centerX);
            make.width.mas_offset(RESIZE_UI(138));
            make.height.mas_offset(RESIZE_UI(42));
        }];
        
        UIButton *closeButton = [[UIButton alloc]init];
        [closeButton setImage:[UIImage imageNamed:@"guoqing_guanbianniu"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeMethod) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(activityImageView.mas_bottom).with.offset(RESIZE_UI(20));
            make.centerX.equalTo(self.mas_centerX);
            make.width.height.mas_offset(RESIZE_UI(40));
        }];
        
    }
    return self;
}

- (void)likeqiangMethod {
    activityImageView.image = [UIImage imageNamed:@"guoqing_tanchuang02"];
    [qiangButton removeFromSuperview];
}

- (void)closeMethod {
    [self removeFromSuperview];
}

@end
