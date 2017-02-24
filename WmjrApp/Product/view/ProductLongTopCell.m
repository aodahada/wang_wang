//
//  ProductLongTopCell.m
//  WmjrApp
//
//  Created by horry on 2017/2/22.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "ProductLongTopCell.h"
#import "ProductModel.h"

@implementation ProductLongTopCell

- (instancetype)initWithProductModel:(ProductModel *)productModel {
    self = [super init];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"icon_tb"];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(15));
            make.height.mas_offset(RESIZE_UI(18));
            make.width.mas_offset(RESIZE_UI(19));
        }];
        
        UILabel *labelForTitle = [[UILabel alloc]init];
        labelForTitle.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
        labelForTitle.text = productModel.name;
        [self addSubview:labelForTitle];
        [labelForTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(imageView.mas_right).with.offset(RESIZE_UI(8));
        }];
        
        UILabel *lineLabel = [[UILabel alloc]init];
        lineLabel.backgroundColor = RGBA(239, 239, 239, 1.0);
        [self addSubview:lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_offset(1);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
