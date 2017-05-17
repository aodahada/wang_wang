//
//  PersonalCategoryCollectionViewCell.m
//  WmjrApp
//
//  Created by Baimifan on 2017/5/15.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "PersonalCategoryCollectionViewCell.h"

@implementation PersonalCategoryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    
    _headImageView = [[UIImageView alloc]init];
    [self addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(17));
        make.height.mas_equalTo(RESIZE_UI(22.5));
        make.width.mas_equalTo(RESIZE_UI(23.3));
    }];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(_headImageView.mas_right).with.offset(RESIZE_UI(16));
    }];

}

@end
