//
//  SortCaiYouTableViewCell.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/28.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "SortCaiYouTableViewCell.h"

@implementation SortCaiYouTableViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        UILabel *indexLabel = [[UILabel alloc]init];
        indexLabel.text = @"1";
        indexLabel.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
        [self addSubview:indexLabel];
        [indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(30));
        }];
        
        UILabel *phoneLabel = [[UILabel alloc]init];
        NSString *mobileNumber = @"15106910293";
        NSMutableString *phoneNum = [mobileNumber mutableCopy];
        [phoneNum replaceCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
        phoneLabel.text = phoneNum;
        phoneLabel.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
        [self addSubview:phoneLabel];
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(100));
        }];
        
        UILabel *timeLable = [[UILabel alloc]init];
        timeLable.text = @"5800.00";
        timeLable.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
        [self addSubview:timeLable];
        [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).with.offset(RESIZE_UI(-60));
        }];
    }
    return self;
}

@end
