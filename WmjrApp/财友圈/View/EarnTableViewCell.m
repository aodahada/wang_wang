//
//  EarnTableViewCell.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/30.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "EarnTableViewCell.h"
#import "EarningListModel.h"

@implementation EarnTableViewCell

- (instancetype)initWithEarnModel:(EarningListModel *)earnModel {
    self = [super init];
    if (self) {
    
        UILabel *phoneLabel = [[UILabel alloc]init];
        NSString *mobileNumber = earnModel.money;
        phoneLabel.text = mobileNumber;
        phoneLabel.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
        [self addSubview:phoneLabel];
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(60));
        }];
        
        UILabel *timeLable = [[UILabel alloc]init];
        timeLable.textAlignment = NSTextAlignmentCenter;
        if ([earnModel.state isEqualToString:@"4"]) {
            timeLable.text = [NSString stringWithFormat:@"%@(预计)",earnModel.create_time];
        } else {
            timeLable.text = earnModel.create_time;
        }
        timeLable.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
        [self addSubview:timeLable];
        [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).with.offset(RESIZE_UI(-30));
            make.width.mas_offset(RESIZE_UI(140));
        }];
    }
    return self;
}

@end
