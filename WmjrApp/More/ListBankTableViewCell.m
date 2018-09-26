//
//  ListBankTableViewCell.m
//  WmjrApp
//
//  Created by Baimifan on 2017/5/17.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "ListBankTableViewCell.h"
#import "BankModel.h"

@implementation ListBankTableViewCell

- (instancetype)initWithBankModel:(BankModel *)bankModel {
    self = [super init];
    if (self) {
        UILabel *bankName = [[UILabel alloc]init];
        bankName.text = bankModel.name;
        bankName.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        bankName.textColor = [UIColor blackColor];
        [self addSubview:bankName];
        [bankName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(24));
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        UILabel *firstPay = [[UILabel alloc]init];
        firstPay.text = bankModel.first_pay;
        firstPay.textColor  = [UIColor blackColor];
        firstPay.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        [self addSubview:firstPay];
        [firstPay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(150));
        }];
        
        UILabel *alreadyPay = [[UILabel alloc]init];
        alreadyPay.text = bankModel.day_pay;
        alreadyPay.textColor = [UIColor blackColor];
        alreadyPay.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        [self addSubview:alreadyPay];
        [alreadyPay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).with.offset(-RESIZE_UI(40));
        }];
    }
    return  self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
