//
//  HomeTableViewCellForth.m
//  WmjrApp
//
//  Created by horry on 2016/10/31.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "HomeTableViewCellForth.h"

@interface HomeTableViewCellForth ()

@end

@implementation HomeTableViewCellForth

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _labelForTitle.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    _labelForInfo.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
