//
//  NewProductCollectionViewCell.m
//  WmjrApp
//
//  Created by horry on 2017/1/15.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "NewProductCollectionViewCell.h"
#import "ProductModel.h"

@interface NewProductCollectionViewCell ()

@property (nonatomic, strong) UIImageView *card;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *yearRateLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *dianLabelOne;
@property (nonatomic, strong) UILabel *dianLabelTwo;
@property (nonatomic, strong) UILabel *endView;

@end

@implementation NewProductCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        _card = [[UIImageView alloc]init];
        _card.image = [UIImage imageNamed:@"image_product_nor"];
        [self addSubview:_card];
        [_card mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_offset(RESIZE_UI(115));
            make.height.mas_offset(RESIZE_UI(80));
        }];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(18)]];
        [_card addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_card.mas_top).with.offset(RESIZE_UI(17));
            make.centerX.equalTo(_card.mas_centerX);
            make.height.mas_offset(RESIZE_UI(25));
        }];
        
        _dianLabelOne = [[UILabel alloc]init];
        _dianLabelOne.text = @"●";
        _dianLabelOne.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
        _dianLabelOne.textAlignment = NSTextAlignmentLeft;
        [_card addSubview:_dianLabelOne];
        
        _yearRateLabel = [[UILabel alloc]init];
        _yearRateLabel.textAlignment = NSTextAlignmentCenter;
        _yearRateLabel.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
        [_card addSubview:_yearRateLabel];
        [_yearRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).with.offset(RESIZE_UI(6));
            make.height.mas_offset(RESIZE_UI(17));
            make.centerX.equalTo(_card.mas_centerX);
        }];
        
        [_dianLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLabel.mas_left);
            make.centerY.equalTo(_yearRateLabel.mas_centerY);
        }];
        
        _dianLabelTwo = [[UILabel alloc]init];
        _dianLabelTwo.text = @"●";
        _dianLabelTwo.font = [UIFont systemFontOfSize:RESIZE_UI(10)];
        _dianLabelTwo.textAlignment = NSTextAlignmentLeft;
        [_card addSubview:_dianLabelTwo];
        
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
        [_card addSubview:_dateLabel];
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_yearRateLabel.mas_bottom).with.offset(RESIZE_UI(4));
            make.height.mas_offset(RESIZE_UI(17));
            make.centerX.equalTo(_card.mas_centerX);
        }];
        
        [_dianLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_dianLabelOne.mas_left);
            make.centerY.equalTo(_dateLabel.mas_centerY);
        }];
        
    }
    return self;
}

- (void)setModel:(ProductModel *)model {
    if (model.isSelect) {
        _card.image = [UIImage imageNamed:@"image_product_sel"];
        CGFloat yearRate = model.returnrate.floatValue;
        _yearRateLabel.textColor = RGBA(111, 0, 0, 1.0);
        _dateLabel.textColor = RGBA(111, 0, 0, 1.0);
        _titleLabel.textColor = RGBA(111, 0, 0, 1.0);
        _yearRateLabel.text = [NSString stringWithFormat:@"%.2f%%",yearRate*100];
        [_card mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(RESIZE_UI(150));
            make.height.mas_offset(RESIZE_UI(120));
        }];
    } else {
        _card.image = [UIImage imageNamed:@"image_product_nor"];
        CGFloat yearRate = model.returnrate.floatValue;
        _yearRateLabel.textColor = RGBA(158, 100, 93, 1.0);
        _dateLabel.textColor = RGBA(158, 100, 93, 1.0);
        _titleLabel.textColor = RGBA(158, 100, 93, 1.0);
        _yearRateLabel.text = [NSString stringWithFormat:@"%.2f%%",yearRate*100];
        [_card mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(RESIZE_UI(140));
            make.height.mas_offset(RESIZE_UI(110));
        }];
    }
    _titleLabel.text = model.name;
    _dateLabel.text = [NSString stringWithFormat:@"%@天期",model.day];
    if([model.is_down isEqualToString:@"1"]){
        if(!_endView) {
            _endView = [[UILabel alloc]init];
            _endView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            _endView.text = @"已售罄";
            _endView.textAlignment = NSTextAlignmentCenter;
            _endView.textColor = [UIColor whiteColor];
            _endView.font = [UIFont systemFontOfSize:RESIZE_UI(18)];
            [_card addSubview:_endView];
            [_endView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_card.mas_top).with.offset(RESIZE_UI(4));
                make.left.equalTo(_card.mas_left).with.offset(RESIZE_UI(4));
                make.right.equalTo(_card.mas_right).with.offset(RESIZE_UI(-5));
                make.bottom.equalTo(_card.mas_bottom).with.offset(RESIZE_UI(-5));
            }];
        }
    } else {
        [_endView removeFromSuperview];
        _endView = nil;
    }
}

@end
