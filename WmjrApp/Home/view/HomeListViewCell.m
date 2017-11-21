//
//  HomeListViewCell.m
//  wangmajinrong
//
//  Created by Baimifan on 15/7/16.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "HomeListViewCell.h"

@interface HomeListViewCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *titButton;

@end

@implementation HomeListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, RESIZE_UI(230))];
        [self.contentView addSubview:_imgView];
        
        _titButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titButton setBackgroundImage:[UIImage imageNamed:@"frame"] forState:(UIControlStateNormal)];
        _titButton.frame = CGRectMake(30, 0, 80, 25);
        _titButton.enabled = NO;
        _titButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [self.contentView addSubview:_titButton];
    }
    
    return self;
}

- (void)setModel:(ImgHomeModel *)model {
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:[UIImage imageNamed:@"image_tuijianhdpi"]];
    [_titButton setTitle:model.title forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
