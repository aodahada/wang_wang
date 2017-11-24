//
//  ApplySmallMessView.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/11/21.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "ApplySmallMessView.h"

@implementation ApplySmallMessView

- (instancetype)initWithTitle:(NSString *)title Content:(NSString *)content andUnit:(NSString *)unit{
    self = [super init];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        titleLabel.textColor = RGBA(102, 102, 102, 1.0);
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(19));
        }];
        
        UILabel *contentLabel = [[UILabel alloc]init];
        contentLabel.text = [NSString stringWithFormat:@"%@%@",content,unit];
        contentLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        contentLabel.textColor = RGBA(20, 20, 23, 1.0);
        [self addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_bottom).with.offset(-RESIZE_UI(18));
        }];
    }
    return self;
}

@end
