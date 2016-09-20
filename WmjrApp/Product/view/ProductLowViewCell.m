//
//  ProductLowViewCell.m
//  wangmajinrong
//
//  Created by Baimifan on 15/7/3.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "ProductLowViewCell.h"

@interface ProductLowViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lowpurchase;
@property (weak, nonatomic) IBOutlet UILabel *lable1;
@property (weak, nonatomic) IBOutlet UILabel *lable2;

@end

@implementation ProductLowViewCell

- (void)awakeFromNib {
    _lable1.textColor = AUXILY_COLOR;
    _lable2.textColor = AUXILY_COLOR;
    _lowpurchase.textColor = AUXILY_COLOR;
}

- (void)setModel:(ProductModel *)model {
    _lowpurchase.text = [NSString stringWithFormat:@"%@起购", model.lowpurchase];
    _lable1.text = [NSString stringWithFormat:@"理财期限:%@天",model.day];
    _lable2.text = model.risk;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
