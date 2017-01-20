//
//  HomeTableViewCellThirdFirst.m
//  WmjrApp
//
//  Created by horry on 2017/1/15.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "HomeTableViewCellThirdFirst.h"

@implementation HomeTableViewCellThirdFirst

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)init {
    self = [super init];
    if (self) {
        UIImageView *imageview = [[UIImageView alloc]init];
        imageview.image = [UIImage imageNamed:@"image_hongbao"];
        [self addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_offset(RESIZE_UI(306));
            make.height.mas_offset(RESIZE_UI(125));
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
