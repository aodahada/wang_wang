//
//  BuyPriviTableCell.m
//  wangmajinrong
//
//  Created by Baimifan on 15/11/26.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "BuyPriviTableCell.h"

@interface BuyPriviTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *money; /* 特权金额 */
@property (weak, nonatomic) IBOutlet UILabel *intro; /* 获取描述 */
@property (weak, nonatomic) IBOutlet UILabel *eDate;  /* 截止时间 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UILabel *labelForBiao;


@end

@implementation BuyPriviTableCell

- (void)setModel:(GoldModel *)model {
    self.backgroundColor = [UIColor whiteColor];
    NSString *state = model.state;
    if ([state isEqualToString:@"-1"]) {
        //过期
        _imageView1.image = [UIImage imageNamed:@"image_leftside_y"];
        _imageView2.image = [UIImage imageNamed:@"image_rightside_ygq"];
        _money.textColor = RGBA(168, 168, 168, 1.0);
        _intro.textColor = RGBA(168, 168, 168, 1.0);
        _labelForBiao.textColor = RGBA(168, 168, 168, 1.0);
        _eDate.text = model.expiry_time;
        _eDate.textColor = RGBA(234, 14, 0, 1.0);
        NSAttributedString *attrStr =
        [[NSAttributedString alloc]initWithString:_model.expiry_time
                                      attributes:
  @{NSFontAttributeName:[UIFont systemFontOfSize:10.f],
    NSForegroundColorAttributeName:RGBA(168, 168, 168, 1.0),
    NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
    NSStrikethroughColorAttributeName:RGBA(168, 168, 168, 1.0)}];
        _eDate.attributedText = attrStr;
        
    } else if ([state isEqualToString:@"0"]) {
        //未使用
        _imageView1.image = [UIImage imageNamed:@"image_leftside_wsy"];
        _imageView2.image = [UIImage imageNamed:@"image_rightside_wsy"];
        _money.textColor = RGBA(234, 14, 0, 1.0);
        _intro.textColor = RGBA(234, 14, 0, 1.0);
        _labelForBiao.textColor = RGBA(234, 14, 0, 1.0);
        _eDate.text = model.expiry_time;
        
    } else {
        //已使用
        _imageView1.image = [UIImage imageNamed:@"image_leftside_y"];
        _imageView2.image = [UIImage imageNamed:@"image_rightside_ysy"];
        _money.textColor = RGBA(168, 168, 168, 1.0);
        _intro.textColor = RGBA(168, 168, 168, 1.0);
        _labelForBiao.textColor = RGBA(168, 168, 168, 1.0);
        NSString *name = model.expiry_time;
        _eDate.text = model.expiry_time;
        _eDate.textColor = RGBA(234, 14, 0, 1.0);
        NSAttributedString *attrStr =
        [[NSAttributedString alloc]initWithString:model.expiry_time
                                       attributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:10.f],
           NSForegroundColorAttributeName:RGBA(168, 168, 168, 1.0),
           NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
           NSStrikethroughColorAttributeName:RGBA(168, 168, 168, 1.0)}];
        _eDate.attributedText = attrStr;
        
    }
    _money.text = model.money;
    _intro.text = model.remark;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
