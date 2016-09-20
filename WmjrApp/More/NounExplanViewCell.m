//
//  NounExplanViewCell.m
//  wangmajinrong
//
//  Created by Baimifan on 15/12/22.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "NounExplanViewCell.h"



@implementation NounExplanViewCell

- (void)awakeFromNib {
    [_indexBtn setTitleColor:AUXILY_COLOR forState:UIControlStateNormal];
    _nounLab.textColor = BASECOLOR;
    _complainLab.textColor = AUXILY_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
