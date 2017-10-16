//
//  IntegralProductCollectionViewCell.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/10/16.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "IntegralProductCollectionViewCell.h"

@implementation IntegralProductCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIImageView *productImage = [[UIImageView alloc]init];
    productImage.image = [UIImage imageNamed:@"image_product2"];
    [self addSubview:productImage];
    [productImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(RESIZE_UI(140));
    }];
    
    UILabel *productNameLabel = [[UILabel alloc]init];
    productNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(14)];
    productNameLabel.text = @"大疆无人机";
    [self addSubview:productNameLabel];
    [productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(productImage.mas_bottom).with.offset(RESIZE_UI(2));
        make.centerX.equalTo(productImage.mas_centerX);
    }];
    
    UILabel *integralLabel = [[UILabel alloc]init];
    integralLabel.text = @"900积分";
    integralLabel.textColor = RGBA(252, 85, 30, 1.0);
    integralLabel.textAlignment = NSTextAlignmentCenter;
    integralLabel.layer.masksToBounds = YES;
    integralLabel.layer.cornerRadius = 10.0f;
    integralLabel.layer.borderWidth = 2.0f;
    integralLabel.layer.borderColor = RGBA(252, 85, 30, 1.0).CGColor;
    integralLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(14)];
    [self addSubview:integralLabel];
    [integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(productNameLabel.mas_bottom).with.offset(RESIZE_UI(5));
        make.centerX.equalTo(productNameLabel.mas_centerX);
        make.width.mas_equalTo(RESIZE_UI(70));
        make.height.mas_equalTo(RESIZE_UI(23));
    }];
}

@end
