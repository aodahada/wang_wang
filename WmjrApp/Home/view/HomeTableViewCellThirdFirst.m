//
//  HomeTableViewCellThirdFirst.m
//  WmjrApp
//
//  Created by horry on 2017/1/15.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "HomeTableViewCellThirdFirst.h"
#import "ProductModel.h"
#import "LongProductSegment.h"

@implementation HomeTableViewCellThirdFirst

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithProductModel:(ProductModel *)productModel {
    self = [super init];
    if (self) {
        
        UIView *leftView = [[UIView alloc]init];
        leftView.backgroundColor = [UIColor whiteColor];
        [self addSubview:leftView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.bottom.equalTo(self.mas_bottom);
            make.width.mas_offset(SCREEN_WIDTH/2-0.5);
        }];
        
        NSArray *segmentArray = productModel.segment;
        LongProductSegment *segFirst = segmentArray[0];
        NSInteger count = segmentArray.count;
        LongProductSegment *segLast = segmentArray[count-1];
        
        UILabel *labelForRate = [[UILabel alloc]init];
        double longRateFloatFirst = [segFirst.returnrate doubleValue] * 100;
        double longRateFloatLast = [segLast.returnrate doubleValue] * 100;
        NSNumber *longRateNumberFirst = [NSNumber numberWithDouble:longRateFloatFirst];
        NSNumber *longRateNumberLast = [NSNumber numberWithDouble:longRateFloatLast];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.roundingMode = NSNumberFormatterRoundFloor;
        formatter.minimumFractionDigits = 1;
        labelForRate.text = [NSString stringWithFormat:@"%@-%@%%",[formatter stringFromNumber:longRateNumberFirst],[formatter stringFromNumber:longRateNumberLast]];
        labelForRate.textAlignment = NSTextAlignmentCenter;
        if ([productModel.isdown isEqualToString:@"0"]) {
            labelForRate.textColor = RGBA(255, 88, 26, 1.0);
        } else {
            labelForRate.textColor = RGBA(237, 237, 237, 1.0);
        }
        labelForRate.font = [UIFont systemFontOfSize:RESIZE_UI(26)];
        [leftView addSubview:labelForRate];
        [labelForRate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(leftView.mas_top).with.offset(RESIZE_UI(31));
            make.centerX.equalTo(leftView.mas_centerX);
        }];
        
        UILabel *labelForRateTitle = [[UILabel alloc]init];
        labelForRateTitle.text = @"预期年化收益率";
        labelForRate.textAlignment = NSTextAlignmentCenter;
        labelForRateTitle.textColor = RGBA(153, 153, 153, 1.0);
        labelForRateTitle.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        [leftView addSubview:labelForRateTitle];
//        [labelForRateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(labelForRate.mas_bottom).with.offset(RESIZE_UI(16));
//            make.centerX.equalTo(labelForRate.mas_centerX);
//        }];
        
        UIView *rightView = [[UIView alloc]init];
        rightView.backgroundColor = [UIColor whiteColor];
        [self addSubview:rightView];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.width.mas_offset(SCREEN_WIDTH/2-0.5);
        }];
        
        UILabel *lineLabel = [[UILabel alloc]init];
        lineLabel.backgroundColor = RGBA(239, 239, 239, 1.0);
        [self addSubview:lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftView.mas_right);
            make.right.equalTo(rightView.mas_left);
            make.height.mas_offset(RESIZE_UI(64));
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        UILabel *sumInvestLabel = [[UILabel alloc]init];
        sumInvestLabel.text = [NSString stringWithFormat:@"%@投资额",productModel.purchasable];
        sumInvestLabel.textAlignment = NSTextAlignmentCenter;
        sumInvestLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
        if ([productModel.isdown isEqualToString:@"0"]) {
            sumInvestLabel.textColor = [UIColor blackColor];
        } else {
            sumInvestLabel.textColor = RGBA(237, 237, 237, 1.0);
        }
        [rightView addSubview:sumInvestLabel];
        [sumInvestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(rightView.mas_top).with.offset(RESIZE_UI(26));
            make.centerX.equalTo(rightView.mas_centerX);
        }];
        
        UILabel *tipLabel = [[UILabel alloc]init];
        tipLabel.text = productModel.risk;
        tipLabel.textColor = RGBA(158, 158, 158, 1.0);
        tipLabel.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [rightView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sumInvestLabel.mas_bottom).with.offset(RESIZE_UI(8));
            make.centerX.equalTo(rightView.mas_centerX);
        }];
        
        UILabel *durationLabel = [[UILabel alloc]init];
        durationLabel.text = [NSString stringWithFormat:@"理财期限%@-%@天",segFirst.duration,segLast.duration];
        if ([productModel.isdown isEqualToString:@"0"]) {
            durationLabel.textColor = RGBA(0, 104, 178, 1.0);
        } else {
            durationLabel.textColor = RGBA(237, 237, 237, 1.0);
        }
        durationLabel.textAlignment = NSTextAlignmentCenter;
        durationLabel.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        [rightView addSubview:durationLabel];
        [durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipLabel.mas_bottom).with.offset(RESIZE_UI(7));
            make.centerX.equalTo(rightView.mas_centerX);
        }];
        
        UIImageView *endImageView = [[UIImageView alloc]init];
        endImageView.image = [UIImage imageNamed:@"icon_ysq"];
        [self addSubview:endImageView];
        [endImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right);
            make.height.mas_offset(RESIZE_UI(53));
            make.width.mas_offset(RESIZE_UI(61));
        }];
        if ([productModel.isdown isEqualToString:@"0"]) {
            endImageView.hidden = YES;
        } else {
            endImageView.hidden = NO;
        }
        
        UIView *bottomLineView = [[UIView alloc]init];
        bottomLineView.backgroundColor = RGBA(239, 239, 239, 1.0);
        [self addSubview:bottomLineView];
        [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_offset(1);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }];
        
        [labelForRateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(labelForRate.mas_bottom).with.offset(RESIZE_UI(16));
            make.centerY.equalTo(durationLabel.mas_centerY);
            make.centerX.equalTo(labelForRate.mas_centerX);
        }];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
