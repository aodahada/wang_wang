//
//  MyselfTransCell.m
//  wangmajinrong
//
//  Created by Baimifan on 15/6/29.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "MyselfTransCell.h"

@interface MyselfTransCell ()

@end

@implementation MyselfTransCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithSubViews];
    }
    return self;
}

- (void)initWithSubViews {
    _imgView = [[UIImageView alloc] initWithFrame:RESIZE_FRAME(CGRectMake(15, 15, 40, 40))];
    _imgView.layer.cornerRadius = RESIZE_UI(40) / 2;
    _imgView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imgView];
    _payBankLab = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(65, 15, 120, 20))];
    _payBankLab.textAlignment = NSTextAlignmentLeft;
    _payBankLab.textColor = TITLE_COLOR;
    _payBankLab.font = [UIFont systemFontOfSize:RESIZE_UI(15.0f)];
    [self.contentView addSubview:_payBankLab];
    _payMoney = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(195, 15, 150, 20))];
    _payMoney.textAlignment = NSTextAlignmentRight;
    _payMoney.textColor = TITLE_COLOR;
    _payMoney.font = [UIFont systemFontOfSize:RESIZE_UI(15.0f)];
    [self.contentView addSubview:_payMoney];
    _payTime = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(65, 35, 180, 20))];
    _payTime.textAlignment = NSTextAlignmentLeft;
    _payTime.textColor = AUXILY_COLOR;
    _payTime.font = [UIFont systemFontOfSize:RESIZE_UI(15.0f)];
    [self.contentView addSubview:_payTime];
    _paySuccess = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(245, 35, 100, 20))];
    _paySuccess.textAlignment = NSTextAlignmentRight;
    _paySuccess.textColor = AUXILY_COLOR;
    _paySuccess.font = [UIFont systemFontOfSize:RESIZE_UI(15.0f)];
    [self.contentView addSubview:_paySuccess];
}

- (void)setModel:(TradeModel *)model {
    NSString *payStr = nil;
    if ([model.type isEqualToString:@"1"]) {
        _imgView.image = [UIImage imageNamed:@"icon_chongzhi"];
        payStr = @"向存钱罐充值";
        _payMoney.text = [NSString stringWithFormat:@"+%@元", model.money];
        _paySuccess.text = @"充值成功";
    }
    if ([model.type isEqualToString:@"2"]) {
        if ([model.comment hasPrefix:@"购入"]) {
            _imgView.image = [UIImage imageNamed:@"icon_goumai"];
            _payMoney.text = [NSString stringWithFormat:@"-%@元", model.money];
        }
        if ([model.comment hasPrefix:@"赎回"]) {
            _imgView.image = [UIImage imageNamed:@"icon_shuhui"];
            _payMoney.text = [NSString stringWithFormat:@"+%@元", model.money];
        }
        payStr = [model.comment substringFromIndex:2];
        _paySuccess.text = [NSString stringWithFormat:@"%@成功", [model.comment substringToIndex:2]];
    }
    if ([model.type isEqualToString:@"3"]) {
        _imgView.image = [UIImage imageNamed:@"icon_tixian"];
        payStr = @"向银行卡提现";
        _payMoney.text = [NSString stringWithFormat:@"-%@元", model.money];
        if ([model.state isEqualToString:@"SUCCESS"]) {
            _paySuccess.text = @"提现成功";
        }
        if ([model.state isEqualToString:@"FAILED"]) {
            _paySuccess.text = @"提现失败";
        }
        if ([model.state isEqualToString:@"PROCESSING"] || [model.state isEqualToString:@"RETURNT_TICKET"]) {
            _paySuccess.text = @"处理中";
        }
    }
    _payBankLab.text = payStr;
    _payTime.text = [self returnTime:model.time];
    
}

- (NSString *)returnTime:(NSString *)timeStr {
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@", [timeStr substringWithRange:NSMakeRange(0, 4)], [timeStr substringWithRange:NSMakeRange(4, 2)], [timeStr substringWithRange:NSMakeRange(6, 2)], [timeStr substringWithRange:NSMakeRange(8, 2)], [timeStr substringWithRange:NSMakeRange(10, 2)], [timeStr substringWithRange:NSMakeRange(12, 2)]];
                                                                                                                                                                                                                                                                       
    return dateStr;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
