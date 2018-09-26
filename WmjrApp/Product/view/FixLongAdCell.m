//
//  FixLongAdCell.m
//  WmjrApp
//
//  Created by horry on 2017/2/22.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "FixLongAdCell.h"
#import "AdModel.h"

@implementation FixLongAdCell

- (instancetype)initWithAdModel:(AdModel *)adModel {
    self = [super init];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:adModel.picurl]];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
