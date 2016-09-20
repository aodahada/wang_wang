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
//    UILabel *_ydayEarn;//昨日收益
    UILabel *_accountEarn;//累计收益
    UILabel *_weekOfYield;//仅七日年化收益率
    UILabel *_earnOfWan;//万份收益
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

    _fundWealth = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(20, 10, 150, 20))];
    
    _fundWealth.textAlignment = NSTextAlignmentLeft;
    _fundWealth.textColor = [UIColor colorWithRed:0.17f green:0.45f blue:0.82f alpha:1.00f];
    _fundWealth.font = [UIFont boldSystemFontOfSize:RESIZE_UI(18.0f)];
    [self.contentView addSubview:_fundWealth];
    
    _holdNum = [[UILabel alloc] initWithFrame:RESIZE_FRAME(RESIZE_FRAME(CGRectMake(20, 40, 150, 20)))];
    
    _holdNum.textAlignment = NSTextAlignmentLeft;
    _holdNum.textColor = AUXILY_COLOR;
    _holdNum.font = [UIFont systemFontOfSize:RESIZE_UI(13.0f)];
    [self.contentView addSubview:_holdNum];
    
    _ydayEarn = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(200, 40, 120, 20))];
    
    _ydayEarn.textAlignment = NSTextAlignmentRight;
    _ydayEarn.textColor = AUXILY_COLOR;
    _ydayEarn.font = [UIFont systemFontOfSize:RESIZE_UI(13.0f)];
    [self.contentView addSubview:_ydayEarn];
    
    UILabel *grayLine = [[UILabel alloc] initWithFrame:RESIZE_FRAME(RESIZE_FRAME(CGRectMake(20, 70, 300, 1)))];
    grayLine.alpha = .4;
    grayLine.backgroundColor = AUXILY_COLOR;
    [self.contentView addSubview:grayLine];
    
    _weekOfYield = [[UILabel alloc] initWithFrame:RESIZE_FRAME(RESIZE_FRAME(CGRectMake(20, 80, 150, 20)))];
    _weekOfYield.textAlignment = NSTextAlignmentLeft;
    _weekOfYield.textColor = AUXILY_COLOR;
    _weekOfYield.font = [UIFont systemFontOfSize:RESIZE_UI(13.0f)];
    [self.contentView addSubview:_weekOfYield];
    
    _earnOfWan = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(200, 80, 120, 20))];
    
    _earnOfWan.textAlignment = NSTextAlignmentRight;
    _earnOfWan.textColor = AUXILY_COLOR;
    _earnOfWan.font = [UIFont systemFontOfSize:RESIZE_UI(13.0f)];
    [self.contentView addSubview:_earnOfWan];
}

- (void)setModel:(FinancialModel *)model {
    _fundWealth.text = model.name;
    _holdNum.text = [NSString stringWithFormat:@"持有%@元", model.money];
    _ydayEarn.text = [NSString stringWithFormat:@"日收＋%.2f元", [model.day_income floatValue]];
    _weekOfYield.text = [NSString stringWithFormat:@"年化率%.2f%@", [model.returnrate floatValue] *100, @"%"];
    _earnOfWan.text = [NSString stringWithFormat:@"万元收益%.2f元", [model.returnrate floatValue] * 10000 / 365];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
