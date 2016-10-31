//
//  HomeTableViewCellFirst.m
//  WmjrApp
//
//  Created by horry on 2016/10/31.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "HomeTableViewCellFirst.h"

@implementation HomeTableViewCellFirst

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self alreadyLoginView];
    }
    return self;
}

- (void)alreadyLoginView {
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"image_top"];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIImageView *imageViewForLeft = [[UIImageView alloc]init];
    imageViewForLeft.image = [UIImage imageNamed:@"navi_bar"];
    [self addSubview:imageViewForLeft];
    [imageViewForLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(35);
        make.left.equalTo(self.mas_left).with.offset(13);
        make.height.mas_offset(17);
        make.width.mas_offset(100);
    }];
    
    UIButton *buttonForMess = [[UIButton alloc]init];
    [buttonForMess setTitle:@"消息中心" forState:UIControlStateNormal];
    buttonForMess.titleLabel.font = [UIFont systemFontOfSize:14];
    [buttonForMess setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
    [self addSubview:buttonForMess];
    [buttonForMess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(38);
        make.right.equalTo(self.mas_right).with.offset(-12);
        make.height.mas_offset(14);
    }];
    
    UILabel *labelForTitle = [[UILabel alloc]init];
    labelForTitle.text = @"昨日收益(元)";
    labelForTitle.textColor = RGBA(254, 243, 243, 1.0);
    labelForTitle.font = [UIFont systemFontOfSize:14];
    [self addSubview:labelForTitle];
    [labelForTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(80);
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_offset(20);
    }];
    
    UILabel *labelForYesterDayMoney = [[UILabel alloc]init];
    labelForYesterDayMoney.text = @"10.0";
    labelForYesterDayMoney.font = [UIFont systemFontOfSize:48];
    labelForYesterDayMoney.textColor = RGBA(255, 255, 255, 1.0);
    [self addSubview:labelForYesterDayMoney];
    [labelForYesterDayMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(112);
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_offset(49);
    }];
    
    UILabel *labelForLine = [[UILabel alloc]init];
    labelForLine.backgroundColor = RGBA(255, 233, 228, 1.0);
    [self addSubview:labelForLine];
    [labelForLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(173);
        make.width.mas_offset(1);
        make.height.mas_offset(14);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    UILabel *labelForSumMoney = [[UILabel alloc]init];
    labelForSumMoney.text = @"3100000";
    labelForSumMoney.font = [UIFont systemFontOfSize:12];
    labelForSumMoney.textColor = RGBA(254, 243, 243, 1.0);
    [self addSubview:labelForSumMoney];
    [labelForSumMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(174);
        make.right.equalTo(labelForLine.mas_left).with.offset(-16);
    }];
    
    UILabel *labelForSumMoneyTitle = [[UILabel alloc]init];
    labelForSumMoneyTitle.text = @"总资产";
    labelForSumMoneyTitle.font = [UIFont systemFontOfSize:12];
    labelForSumMoneyTitle.textColor = RGBA(255, 255, 255, 1.0);
    [self addSubview:labelForSumMoneyTitle];
    [labelForSumMoneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(174);
        make.right.equalTo(labelForSumMoney.mas_left).with.offset(-10);
    }];
    
    UILabel *labelForRaiseMoneyTitle = [[UILabel alloc]init];
    labelForRaiseMoneyTitle.text = @"累计收益";
    labelForRaiseMoneyTitle.textColor = RGBA(255, 255, 255, 1.0);
    labelForRaiseMoneyTitle.font = [UIFont systemFontOfSize:12];
    [self addSubview:labelForRaiseMoneyTitle];
    [labelForRaiseMoneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(174);
        make.left.equalTo(labelForLine.mas_right).with.offset(16);
    }];
    
    UILabel *labelForRaiseMoney = [[UILabel alloc]init];
    labelForRaiseMoney.text = @"3100000";
    labelForRaiseMoney.font = [UIFont systemFontOfSize:12];
    labelForRaiseMoney.textColor = RGBA(254, 243, 243, 1.0);
    [self addSubview:labelForRaiseMoney];
    [labelForRaiseMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(174);
        make.left.equalTo(labelForRaiseMoneyTitle.mas_right).with.offset(10);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
