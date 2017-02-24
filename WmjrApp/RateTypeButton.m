//
//  RateTypeButton.m
//  WmjrApp
//
//  Created by horry on 2017/2/17.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "RateTypeButton.h"
#import "LongProductSegment.h"

@interface RateTypeButton ()

@property (nonatomic, strong)UIImageView *imageBackView;
@property (nonatomic, strong)UILabel *rateLabel;
@property (nonatomic, strong)UILabel *dateLabel;
@property (nonatomic, strong)UILabel *yearRateLabel;
@property (nonatomic, strong)UILabel *endLabel;
@property (nonatomic, strong)UILabel *endTitleLabel;

@end

@implementation RateTypeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithSementProduct:(LongProductSegment *)segmentPro {
    self = [super init];
    if (self) {
        self.backgroundColor = RGBA(239, 239, 239, 1.0);
        _imageBackView = [[UIImageView alloc]init];
        [self addSubview:_imageBackView];
        if (segmentPro.isSelect) {
            _imageBackView.image = [UIImage imageNamed:@"image_sel"];
            [_imageBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.centerY.equalTo(self.mas_centerY);
                make.height.mas_offset(RESIZE_UI(165));
                make.width.mas_offset(RESIZE_UI(128));
            }];
        } else {
            _imageBackView.image = [UIImage imageNamed:@"image_nor"];
            [_imageBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.centerY.equalTo(self.mas_centerY);
                make.height.mas_offset(RESIZE_UI(150));
                make.width.mas_offset(RESIZE_UI(118));
            }];
        }
        
        _endLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _endLabel.textColor = RGBA(237, 237, 237, 1.0);
        _endLabel.font = [UIFont systemFontOfSize:RESIZE_UI(20)];
        _endLabel.textAlignment = NSTextAlignmentCenter;
        NSString *endtimeStr = segmentPro.segment_time;
        NSArray *timeStr = [endtimeStr componentsSeparatedByString:@" "];
        _endLabel.text = timeStr[0];
        [_imageBackView addSubview:_endLabel];
        [_endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(_imageBackView.mas_top).with.offset(RESIZE_UI(48));
        }];
        
        _endTitleLabel = [[UILabel alloc]init];
        _endTitleLabel.text = @"到期";
        _endTitleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(21)];
        _endTitleLabel.textColor = RGBA(237, 237, 237, 1.0);
        [_imageBackView addSubview:_endTitleLabel];
        [_endTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_endLabel.mas_bottom);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        _rateLabel = [[UILabel alloc]init];
        [_imageBackView addSubview:_rateLabel];
        CGFloat returnFloat = [segmentPro.returnrate floatValue]*100;
        NSNumber *longRateNumber = [NSNumber numberWithFloat:returnFloat];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.roundingMode = NSNumberFormatterRoundFloor;
        formatter.maximumFractionDigits = 1;
        NSString *yearRate = [NSString stringWithFormat:@"%@%%",[formatter stringFromNumber:longRateNumber]];
        _rateLabel.attributedText =  [self changeStringWithString:yearRate withFrontColor:RGBA(0, 108, 180, 1.0) WithBehindColor:RGBA(0, 108, 180, 1.0) withFrontFont:[UIFont systemFontOfSize:RESIZE_UI(44)] WithBehindFont:[UIFont systemFontOfSize:RESIZE_UI(22)]];
        [_rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(21));
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        _yearRateLabel = [[UILabel alloc]init];
        _yearRateLabel.text = @"年化收益率";
        _yearRateLabel.textAlignment = NSTextAlignmentCenter;
        _yearRateLabel.textColor = RGBA(102, 102, 102, 1.0);
        _yearRateLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        [_imageBackView addSubview:_yearRateLabel];
        [_yearRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(_rateLabel.mas_bottom).with.offset(RESIZE_UI(10));
        }];
        
        _dateLabel = [[UILabel alloc]init];
        _dateLabel.font = [UIFont systemFontOfSize:RESIZE_UI(18)];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.text = [NSString stringWithFormat:@"%@天",segmentPro.duration];
        [_imageBackView addSubview:_dateLabel];
        if (segmentPro.isSelect) {
            [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.bottom.equalTo(self.mas_bottom).with.offset(RESIZE_UI(-19));
            }];
        } else {
            [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.mas_centerX);
                make.bottom.equalTo(self.mas_bottom).with.offset(RESIZE_UI(-10));
            }];
        }
        
        if ([segmentPro.returnrate isEqualToString:@"0"]) {
            
            _endLabel.hidden = NO;
            _endTitleLabel.hidden = NO;
            _rateLabel.hidden = YES;
            _dateLabel.hidden = YES;
            _yearRateLabel.hidden = YES;
            
        } else {
            
            _endLabel.hidden = YES;
            _endTitleLabel.hidden = YES;
            _rateLabel.hidden = NO;
            _dateLabel.hidden = NO;
            _yearRateLabel.hidden = NO;
            
        }
        
    }
    return self;
}

- (NSAttributedString *)changeStringWithString:(NSString *)string withFrontColor:(UIColor *)frontColor WithBehindColor:(UIColor *)behindColor withFrontFont:(UIFont *)frontFont WithBehindFont:(UIFont *)behindFont {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:frontColor range:NSMakeRange(0, [string length])];
    [str addAttribute:NSForegroundColorAttributeName value:behindColor range:NSMakeRange([string length] - 1, 1)];
    [str addAttribute:NSFontAttributeName value:frontFont range:NSMakeRange(0, [string length])];
    [str addAttribute:NSFontAttributeName value:behindFont range:NSMakeRange([string length] - 1, 1)];
    return str;
}

- (void)setSegmentProduct:(LongProductSegment *)segmentProduct {
    if (segmentProduct.isSelect) {
        
        _imageBackView.image = [UIImage imageNamed:@"image_sel"];
        [_imageBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_offset(RESIZE_UI(165));
            make.width.mas_offset(RESIZE_UI(128));
        }];
    } else {
        _imageBackView.image = [UIImage imageNamed:@"image_nor"];
        [_imageBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.height.mas_offset(RESIZE_UI(150));
            make.width.mas_offset(RESIZE_UI(118));
        }];
    }
    
    CGFloat returnFloat = [segmentProduct.returnrate floatValue];
    NSString *yearRate = [NSString stringWithFormat:@"%.1f%%",returnFloat*100];
    _rateLabel.attributedText =  [self changeStringWithString:yearRate withFrontColor:RGBA(0, 108, 180, 1.0) WithBehindColor:RGBA(0, 108, 180, 1.0) withFrontFont:[UIFont systemFontOfSize:RESIZE_UI(44)] WithBehindFont:[UIFont systemFontOfSize:RESIZE_UI(22)]];
    _dateLabel.text = [NSString stringWithFormat:@"%@天",segmentProduct.duration];
    
    if (segmentProduct.isSelect) {
        [_dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_bottom).with.offset(RESIZE_UI(-19));
        }];
    } else {
        [_dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_bottom).with.offset(RESIZE_UI(-10));
        }];
    }
    
    if ([segmentProduct.returnrate isEqualToString:@"0"]) {
        
        _endLabel.hidden = NO;
        _endTitleLabel.hidden = NO;
        _rateLabel.hidden = YES;
        _dateLabel.hidden = YES;
        _yearRateLabel.hidden = YES;
        
    } else {
        
        _endLabel.hidden = YES;
        _endTitleLabel.hidden = YES;
        _rateLabel.hidden = NO;
        _dateLabel.hidden = NO;
        _yearRateLabel.hidden = NO;
        
    }
    
}

@end
