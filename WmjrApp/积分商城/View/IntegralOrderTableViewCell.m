//
//  IntegralOrderTableViewCell.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/10/17.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "IntegralOrderTableViewCell.h"
#import "IntegralProductDetailModel.h"

@implementation IntegralOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithIntegralProductDetailModel:(IntegralProductDetailModel *)integralProductDetailModel {
    self = [super init];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc]init];
        NSString *pic = integralProductDetailModel.pic;
        [imageView sd_setImageWithURL:[NSURL URLWithString:pic]];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(20));
            make.width.height.mas_offset(RESIZE_UI(59));
        }];
        
        UILabel *integralLabel = [[UILabel alloc]init];
        integralLabel.text = [NSString stringWithFormat:@"%@积分",integralProductDetailModel.need_score];
        integralLabel.textColor = RGBA(255, 84, 34, 1.0);
//        integralLabel.backgroundColor = [UIColor redColor];
        integralLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        [self addSubview:integralLabel];
        [integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_top).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(RESIZE_UI(-12));
        }];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = integralProductDetailModel.name;
        titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = RGBA(20, 20, 23, 1.0);
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_top);
            make.left.equalTo(imageView.mas_right).with.offset(RESIZE_UI(19));
            make.right.equalTo(integralLabel.mas_left).with.offset(-RESIZE_UI(46));
        }];
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.text = integralProductDetailModel.created_at;
        timeLabel.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        timeLabel.textColor = RGBA(153, 153, 153, 1.0);
        [self addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(imageView.mas_bottom);
            make.left.equalTo(titleLabel.mas_left);
        }];
        
        UILabel *numberLabel = [[UILabel alloc]init];
//        numberLabel.text = [NSString stringWithFormat:@"x%@",integralProductDetailModel.sort];
        numberLabel.text = @"x1";
        numberLabel.textColor = RGBA(20, 20, 23, 1.0);
        numberLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        [self addSubview:numberLabel];
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(imageView.mas_bottom);
            make.right.equalTo(self.mas_right).with.offset(-RESIZE_UI(12));
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
