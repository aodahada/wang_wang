//
//  AvatorSettingCell.m
//  wangmajinrong
//
//  Created by Baimifan on 15/7/16.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "AvatorSettingCell.h"

@interface AvatorSettingCell ()

@end

@implementation AvatorSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configViewToCell];
    }
    return self;
}

- (void)configViewToCell {
    _avatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _avatorBtn.frame = RESIZE_FRAME(CGRectMake(15, 7, 55, 56));
    _avatorBtn.layer.cornerRadius = CGRectGetHeight(_avatorBtn.frame) / 2;
    _avatorBtn.layer.masksToBounds = YES;
    _avatorBtn.userInteractionEnabled = YES;
    [_avatorBtn addTarget:self action:@selector(clickAvatorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_avatorBtn];
    
    _nameLable = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(80, 15, 200, 40))];
    _nameLable.textColor = AUXILY_COLOR;
    _nameLable.font = [UIFont systemFontOfSize:RESIZE_UI(22.0f)];
    [self.contentView addSubview:_nameLable];
}

- (void)clickAvatorBtnAction:(UIButton *)sender {
    NSLog(@"－－－－点击头像－－－");
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickAvatorBtnWithCell:withIndexPath:)]) {
        [self.delegate clickAvatorBtnWithCell:self withIndexPath:self.indexPath];
    }
}

- (void)configCellWithModel:(UserInfoModel *)model {
    [_avatorBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.photourl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zhtx_icon.png"]];
    _nameLable.text = [NSString stringWithFormat:@"*%@", [model.name substringFromIndex:1]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
