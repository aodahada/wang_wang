//
//  PrizeRecordTableViewCell.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/12/14.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "PrizeRecordTableViewCell.h"
#import "PrizeRecordModel.h"

@interface PrizeRecordTableViewCell ()

@property (nonatomic, strong) PrizeRecordModel *currentPrizeModel;

@end

@implementation PrizeRecordTableViewCell

- (instancetype)initWithPrizeRecordModel:(PrizeRecordModel *)prizeRecordModel {
    self = [super init];
    if (self) {
        _currentPrizeModel = prizeRecordModel;
        UILabel *label1 = [[UILabel alloc]init];
        label1.text = prizeRecordModel.prizeRecordId;
        label1.textColor = RGBA(249, 153, 1, 1.0);
        label1.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
        [self addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_offset(RESIZE_UI(20));
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(10));
        }];
        
        //已兑换  btn_ydh
        UIButton *exchangeButton = [[UIButton alloc]init];
        if ([prizeRecordModel.state isEqualToString:@"1"]) {
            [exchangeButton setBackgroundImage:[UIImage imageNamed:@"btn_dh"] forState:UIControlStateNormal];
        } else {
            [exchangeButton setBackgroundImage:[UIImage imageNamed:@"btn_ydh"] forState:UIControlStateNormal];
        }
        [exchangeButton addTarget:self action:@selector(exchangePrizeMethod) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:exchangeButton];
        [exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(RESIZE_UI(48));
            make.height.mas_offset(RESIZE_UI(21));
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).with.offset(-RESIZE_UI(10));
        }];
        
        UILabel *label3 = [[UILabel alloc]init];
        label3.text = prizeRecordModel.created_at;
        label3.textAlignment = NSTextAlignmentCenter;
        label3.textColor = RGBA(249, 153, 1, 1.0);
        label3.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
        [self addSubview:label3];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_offset(RESIZE_UI(110));
            make.right.equalTo(exchangeButton.mas_left).with.offset(-RESIZE_UI(5));
        }];
        
        NSString *type;//1.现金红包 2.全国流量 3.尊享积分
        if ([prizeRecordModel.type isEqualToString:@"1"]) {
            type = @"现金红包";
        } else if ([prizeRecordModel.type isEqualToString:@"2"]) {
            type = @"全国流量";
        } else {
            type = @"尊享积分";
        }
        UILabel *label2 = [[UILabel alloc]init];
        label2.text = [NSString stringWithFormat:@"%@%@",prizeRecordModel.value,type];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.textColor = RGBA(249, 153, 1, 1.0);
        label2.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
        [self addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(label3.mas_left).with.offset(-RESIZE_UI(5));
            make.left.equalTo(label1.mas_right);
        }];
        
        
        
    }
    return self;
}

- (void)exchangePrizeMethod {
    if ([_currentPrizeModel.state isEqualToString:@"1"]) {
        if (self.exchangePrize) {
            self.exchangePrize(_currentPrizeModel.prizeRecordId);
        }
    }
}

@end
