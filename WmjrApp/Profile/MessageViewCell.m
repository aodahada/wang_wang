//
//  MessageViewCell.m
//  wangmajinrong
//
//  Created by Baimifan on 15/11/20.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "MessageViewCell.h"

@interface MessageViewCell ()

@end

@implementation MessageViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
//    _imgView.layer.cornerRadius = CGRectGetWidth(_imgView.frame) / 2;
//    _imgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
