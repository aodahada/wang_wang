//
//  IntegralOrderListCell.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/10/19.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "IntegralOrderListCell.h"
#import "IntegralOrderModel.h"

@implementation IntegralOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithIntegralOrderModel:(IntegralOrderModel *)integralOrderModel {
    self = [super init];
    if (self) {
        self.backgroundColor = RGBA(238, 240, 242, 1.0);
        UIView *topView = [[UIView alloc]init];
        topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_offset(RESIZE_UI(44));
        }];
        
        UILabel *orderNumTitle = [[UILabel alloc]init];
        orderNumTitle.text = @"订单号:";
        orderNumTitle.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        orderNumTitle.textColor = RGBA(153, 153, 153, 1.0);
        [topView addSubview:orderNumTitle];
        [orderNumTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topView.mas_centerY);
            make.left.equalTo(topView.mas_left).with.offset(RESIZE_UI(12));
        }];
        
        UILabel *orderNum = [[UILabel alloc]init];
        orderNum.text = integralOrderModel.id;
        orderNum.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        [topView addSubview:orderNum];
        [orderNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(orderNumTitle.mas_centerY);
            make.left.equalTo(orderNumTitle.mas_right).with.offset(RESIZE_UI(5));
        }];
        
        UILabel *orderStatus = [[UILabel alloc]init];
        if ([integralOrderModel.status isEqualToString:@"1"]) {
            orderStatus.text = @"已发货";
            orderStatus.textColor = RGBA(255, 85, 35, 1.0);
        } else {
            orderStatus.text = @"待发货";
            orderStatus.textColor = RGBA(153, 153, 153, 1.0);
        }
        [topView addSubview:orderStatus];
        [orderStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topView.mas_centerY);
            make.right.equalTo(topView.mas_right).with.offset(RESIZE_UI(-14));
        }];
        
        UIView *bottomView = [[UIView alloc]init];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom).with.offset(1);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_offset(RESIZE_UI(105));
        }];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        NSString *pic = integralOrderModel.pic;
        [imageView sd_setImageWithURL:[NSURL URLWithString:pic]];
        [bottomView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomView.mas_centerY);
            make.left.equalTo(bottomView.mas_left).with.offset(RESIZE_UI(20));
            make.width.height.mas_offset(RESIZE_UI(59));
        }];
        
        UILabel *integralLabel = [[UILabel alloc]init];
        integralLabel.text = [NSString stringWithFormat:@"%@积分",integralOrderModel.score];
        integralLabel.textColor = RGBA(255, 84, 34, 1.0);
        integralLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        [bottomView addSubview:integralLabel];
        [integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_top);
            make.right.equalTo(bottomView.mas_right).with.offset(RESIZE_UI(-12));
        }];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = integralOrderModel.goods_name;
        titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = RGBA(20, 20, 23, 1.0);
        [bottomView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_top);
            make.left.equalTo(imageView.mas_right).with.offset(RESIZE_UI(19));
            make.right.equalTo(integralLabel.mas_left).with.offset(-RESIZE_UI(46));
        }];
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.text = integralOrderModel.created_at;
        timeLabel.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        timeLabel.textColor = RGBA(153, 153, 153, 1.0);
        [bottomView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(imageView.mas_bottom);
            make.left.equalTo(titleLabel.mas_left);
        }];
        
        UILabel *numberLabel = [[UILabel alloc]init];
        numberLabel.text = [NSString stringWithFormat:@"x%@",integralOrderModel.num];
        numberLabel.textColor = RGBA(20, 20, 23, 1.0);
        numberLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        [bottomView addSubview:numberLabel];
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(imageView.mas_bottom);
            make.right.equalTo(bottomView.mas_right).with.offset(-RESIZE_UI(12));
        }];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
