//
//  IntegralProductCollectionViewCell.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/10/16.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "IntegralProductCollectionViewCell.h"
#import "IntegralProductModel.h"

@interface IntegralProductCollectionViewCell()

@property (nonatomic, strong) UIImageView *productImage;
@property (nonatomic, strong) UILabel *productNameLabel;
@property (nonatomic, strong) UILabel *integralLabel;
//@property (nonatomic, strong) UIImageView *xiajiaImageView;

@end

@implementation IntegralProductCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _productImage = [[UIImageView alloc]init];
//    _productImage.image = [UIImage imageNamed:@"image_product2"];
    [self addSubview:_productImage];
    [_productImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(RESIZE_UI(140));
    }];
    
//    UIImageView *xiajiaImageView = [[UIImageView alloc]init];
//    xiajiaImageView.image = [UIImage imageNamed:@"icon_yxj"];
//    [_productImage addSubview:xiajiaImageView];
//    [xiajiaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_productImage.mas_top);
//        make.right.equalTo(_productImage.mas_right);
//        make.width.height.mas_offset(RESIZE_UI(60));
//    }];
    
    _productNameLabel = [[UILabel alloc]init];
//    _productNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(14)];
    _productNameLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
//    _productNameLabel.text = @"大疆无人机";
    [self addSubview:_productNameLabel];
    [_productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productImage.mas_bottom).with.offset(RESIZE_UI(2));
        make.centerX.equalTo(_productImage.mas_centerX);
    }];
    
    _integralLabel = [[UILabel alloc]init];
//    _integralLabel.text = @"900积分";
    _integralLabel.textColor = RGBA(252, 85, 30, 1.0);
    _integralLabel.textAlignment = NSTextAlignmentCenter;
    _integralLabel.layer.masksToBounds = YES;
    _integralLabel.layer.cornerRadius = 10.0f;
    _integralLabel.layer.borderWidth = 1.0f;
    _integralLabel.layer.borderColor = RGBA(252, 85, 30, 1.0).CGColor;
//    _integralLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(14)];
    _integralLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    [self addSubview:_integralLabel];
    [_integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_productNameLabel.mas_bottom).with.offset(RESIZE_UI(5));
        make.centerX.equalTo(_productNameLabel.mas_centerX);
        make.width.mas_equalTo(RESIZE_UI(70));
        make.height.mas_equalTo(RESIZE_UI(23));
    }];
}

- (void)setIntegralProductModel:(IntegralProductModel *)integralProductModel {
    [_productImage sd_setImageWithURL:[NSURL URLWithString:integralProductModel.pic]];
    _productNameLabel.text = integralProductModel.name;
    _integralLabel.text = [NSString stringWithFormat:@"%@积分",integralProductModel.need_score];
}

@end
