//
//  MyselfManageFinanceCell.m
//  wangmajinrong
//
//  Created by Baimifan on 15/6/29.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "MyselfManageFinanceCell.h"

@interface MyselfManageFinanceCell ()
{
    UILabel *_fundWealth;//基金财富宝
    UILabel *_holdNum;//持有数量
    UILabel *_redBallEarn;//红包收益
//    UILabel *_ydayEarn;//昨日收益
    UILabel *_accountEarn;//累计收益
    UILabel *_weekOfYield;//仅七日年化收益率
    UILabel *_earnOfWan;//万份收益
    UILabel *_jiaxiLabel;//加息label
}

@end

@implementation MyselfManageFinanceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initWithSubViews];
    }
    return self;
}

- (void)initWithSubViews {

    _fundWealth = [[UILabel alloc] init];
    _fundWealth.textAlignment = NSTextAlignmentLeft;
    _fundWealth.textColor = [UIColor colorWithRed:0.17f green:0.45f blue:0.82f alpha:1.00f];
    _fundWealth.font = [UIFont boldSystemFontOfSize:RESIZE_UI(18.0f)];
    [self.contentView addSubview:_fundWealth];
    [_fundWealth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(20));
        make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(10));
    }];
    
    _holdNum = [[UILabel alloc] init];
    _holdNum.textAlignment = NSTextAlignmentLeft;
    _holdNum.textColor = AUXILY_COLOR;
    _holdNum.font = [UIFont systemFontOfSize:RESIZE_UI(13.0f)];
    [self.contentView addSubview:_holdNum];
    [_holdNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fundWealth.mas_bottom).with.offset(RESIZE_UI(5));
        make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    _ydayEarn = [[UILabel alloc] init];
    _ydayEarn.textAlignment = NSTextAlignmentRight;
    _ydayEarn.textColor = AUXILY_COLOR;
    _ydayEarn.font = [UIFont systemFontOfSize:RESIZE_UI(13.0f)];
    [self.contentView addSubview:_ydayEarn];
    [_ydayEarn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(200));
        make.top.equalTo(_fundWealth.mas_bottom).with.offset(RESIZE_UI(5));
    }];
    
    _redBallEarn = [[UILabel alloc]init];
    _redBallEarn.textColor = AUXILY_COLOR;
    _redBallEarn.font = [UIFont systemFontOfSize:RESIZE_UI(13.0f)];
    [self.contentView addSubview:_redBallEarn];
    [_redBallEarn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_fundWealth.mas_centerY);
        make.right.equalTo(_ydayEarn.mas_right);
    }];
    
    UILabel *grayLine = [[UILabel alloc] init];
    grayLine.alpha = .4;
    grayLine.backgroundColor = AUXILY_COLOR;
    [self.contentView addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(20));
        make.right.equalTo(self.mas_right).with.offset(-RESIZE_UI(20));
        make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(70));
        make.height.mas_offset(1);
    }];
    
    _weekOfYield = [[UILabel alloc] init];
    _weekOfYield.textAlignment = NSTextAlignmentLeft;
    _weekOfYield.textColor = AUXILY_COLOR;
    _weekOfYield.font = [UIFont systemFontOfSize:RESIZE_UI(13.0f)];
    [self.contentView addSubview:_weekOfYield];
    [_weekOfYield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(20));
        make.top.equalTo(grayLine.mas_bottom).with.offset(RESIZE_UI(12));
    }];
    
    _jiaxiLabel = [[UILabel alloc]init];
    _jiaxiLabel.textColor = [UIColor redColor];
    _jiaxiLabel.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
    [self addSubview:_jiaxiLabel];
    [_jiaxiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_weekOfYield.mas_centerY);
        make.left.equalTo(_weekOfYield.mas_right).with.offset(RESIZE_UI(5));
    }];
    
    _earnOfWan = [[UILabel alloc] init];
    _earnOfWan.textAlignment = NSTextAlignmentRight;
    _earnOfWan.textColor = AUXILY_COLOR;
    _earnOfWan.font = [UIFont systemFontOfSize:RESIZE_UI(13.0f)];
    [self.contentView addSubview:_earnOfWan];
    [_earnOfWan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(200));
        make.centerY.equalTo(_weekOfYield.mas_centerY);
    }];
}

- (void)setModel:(FinancialModel *)model {
    _fundWealth.text = model.name;
    if ([model.redpacket isEqualToString:@"0"]) {
        _redBallEarn.hidden = YES;
    } else {
        _redBallEarn.hidden = NO;
        _redBallEarn.text = [NSString stringWithFormat:@"使用红包 %@元",model.redpacket];
    }
    _holdNum.text = [NSString stringWithFormat:@"持有%@元", model.money];
    _ydayEarn.text = [NSString stringWithFormat:@"日收＋%.2f元", [model.day_income doubleValue]];
    double returnratefloat = [model.returnrate doubleValue];
    double returnrate_plus = [model.returnrate_plus doubleValue];
    _weekOfYield.text = [NSString stringWithFormat:@"年化率%.2f%@", (returnratefloat-returnrate_plus) *100, @"%"];
    if ([[SingletonManager convertNullString:model.returnrate_plus] isEqualToString:@"0"]) {
        _jiaxiLabel.hidden = YES;
    } else {
        _jiaxiLabel.hidden = NO;
//        NSNumber *returnrate_plusNumber = [NSNumber numberWithDouble:returnrate_plus*100];
//        NSString *returnrate_plusStr = [NSString stringWithFormat:@"%@％",returnrate_plusNumber];
        _jiaxiLabel.text = [NSString stringWithFormat:@"+%g％",returnrate_plus*100];
    }
    _earnOfWan.text = [NSString stringWithFormat:@"万元收益%.2f元", [model.returnrate doubleValue] * 10000 / 365];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
