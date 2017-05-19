//
//  HomeTableViewCellForth.m
//  WmjrApp
//
//  Created by horry on 2016/10/31.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "HomeTableViewCellForth.h"

@interface HomeTableViewCellForth ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;


@end

@implementation HomeTableViewCellForth

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _labelLeftConstraint.constant = RESIZE_UI(8);
    _labelRightConstraint.constant = RESIZE_UI(21);
    _imageRightConstraint.constant = RESIZE_UI(7);
    _imageHeight.constant = RESIZE_UI(94);
    _imageWidth.constant = RESIZE_UI(94*77/60);
    _labelForTitle.font = [UIFont fontWithName:@ "Arial-BoldMT"  size:(18)];
    _labelForInfo.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
//    [_imageViewNews mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.mas_centerY);
//        make.right.equalTo(self.mas_right).with.offset(RESIZE_UI(-16));
//        make.height.mas_offset(RESIZE_UI(94));
//        make.width.mas_offset(RESIZE_UI(94*77/60));
//    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
