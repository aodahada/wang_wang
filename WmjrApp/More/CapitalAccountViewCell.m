//
//  CapitalAccountViewCell.m
//  wangmajinrong
//
//  Created by Baimifan on 15/12/28.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "CapitalAccountViewCell.h"

@implementation CapitalAccountViewCell

- (void)awakeFromNib {
    _indexCap.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [_indexCap setTitleColor:AUXILY_COLOR forState:UIControlStateNormal];
    _questionLab.textColor = TITLE_COLOR;
    _ansLab.textColor = AUXILY_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
