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
        self.backgroundColor = RGBA(231, 234, 236, 1.0);
//        //类名
//        UILabel *headerLab = UILabel.new;
//        [headerLab setFont:[UIFont systemFontOfSize:15]];
////        [headerLab setTextColor:RGBA(99, 100, 100, 1)];
//        headerLab.textAlignment = NSTextAlignmentLeft;
//        [self addSubview:headerLab];
//        self.headerLabel = headerLab;
//        [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).mas_offset(5);
//            make.right.equalTo(self.mas_right).mas_offset(-5);
//            make.centerY.equalTo(self.mas_centerY);
//            make.height.equalTo(@20);
//        }];
    }
    return self;
}


@end
