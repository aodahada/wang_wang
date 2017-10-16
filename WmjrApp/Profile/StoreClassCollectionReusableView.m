//
//  StoreClassCollectionReusableView.m
//  Meitu
//
//  Created by huorui on 16/1/11.
//  Copyright © 2016年 M2. All rights reserved.
//

#import "StoreClassCollectionReusableView.h"

@implementation StoreClassCollectionReusableView

//- (void)awakeFromNib {
//    // Initialization code
//    
//    //类名
//    UILabel *headerLab = UILabel.new;
//    [headerLab setFont:[UIFont systemFontOfSize:14]];
//    [headerLab setTextColor:RGBA(99, 100, 100, 1)];
//    headerLab.textAlignment = NSTextAlignmentLeft;
//    headerLab.text = @"ahah";
//    [self addSubview:headerLab];
//    self.headerLabel = headerLab;
//    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).mas_offset(5);
//        make.right.equalTo(self.mas_right).mas_offset(-5);
//        make.centerY.equalTo(self.mas_centerY);
//        make.height.equalTo(@20);
//    }];
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *lineLabel = [[UILabel alloc]init];
        lineLabel.backgroundColor = RGBA(255, 82, 37, 1.0);
        lineLabel.layer.masksToBounds = YES;
        lineLabel.layer.cornerRadius = RESIZE_UI(2);
        [self addSubview:lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(9));
            make.width.mas_offset(RESIZE_UI(4));
            make.height.mas_offset(RESIZE_UI(20));
        }];
        //类名
        UILabel *headerLab = UILabel.new;
        [headerLab setFont:[UIFont systemFontOfSize:RESIZE_UI(12)]];
        [headerLab setTextColor:RGBA(252, 85, 30, 1)];
        [self addSubview:headerLab];
        self.headerLabel = headerLab;
        [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lineLabel.mas_right).mas_offset(RESIZE_UI(10));
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}


@end
