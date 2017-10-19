//
//  OrderAddressTableViewCell.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/10/19.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "OrderAddressTableViewCell.h"
#import "IntegralAddressModel.h"

@implementation OrderAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithIntegralAddressModel:(IntegralAddressModel *)integralAddressModel {
    
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
            make.height.mas_offset(RESIZE_UI(111.5));
        }];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text = integralAddressModel.name;
        nameLabel.textColor = RGBA(20, 20, 23, 1.0);
        nameLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
        [topView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(14));
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(12));
        }];
        
        UILabel *phoneLabel = [[UILabel alloc]init];
        phoneLabel.text = integralAddressModel.mobile;
        phoneLabel.textColor = RGBA(102, 102, 102, 1.0);
        [topView addSubview:phoneLabel];
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_top).with.offset(RESIZE_UI(14));
            make.right.equalTo(topView.mas_right).with.offset(RESIZE_UI(-14));
        }];
        
        UILabel *addressLabel = [[UILabel alloc]init];
        addressLabel.numberOfLines = 2;
        addressLabel.text = integralAddressModel.address;
        addressLabel.textColor = RGBA(102, 102, 102, 1.0);
        addressLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        [topView addSubview:addressLabel];
        [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).with.offset(RESIZE_UI(9));
            make.left.equalTo(nameLabel.mas_left);
            make.right.equalTo(topView.mas_right).with.offset(-RESIZE_UI(14));
            make.height.mas_offset(RESIZE_UI(52));
        }];
        
    }
    return self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
