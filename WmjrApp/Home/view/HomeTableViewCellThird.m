//
//  HomeTableViewCellThird.m
//  WmjrApp
//
//  Created by horry on 2016/10/31.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "HomeTableViewCellThird.h"
#import "ProgressView.h"
#import "LongProductSegment.h"

@interface HomeTableViewCellThird ()

@property (nonatomic, strong) ProgressView *progressView;
@property (nonatomic, strong) ProductModel *productModelHa;
@property (nonatomic, strong) UIImageView *endImageView;
@property (nonatomic, strong) UIImageView *jiaxiImageView;
@property (nonatomic, strong) UILabel *jiaxiLabel;

@end

@implementation HomeTableViewCellThird

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.buyNum = 0.00;
        [self initWithSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)initWithSubViews {
    
    self.earnOfPercent = [[UILabel alloc] init];
    self.earnOfPercent.textAlignment = NSTextAlignmentCenter;
//        self.earnOfPercent.text = @"5.50%";
    self.earnOfPercent.textColor = RGBA(255, 88, 26, 1.0);
    self.earnOfPercent.font = [UIFont systemFontOfSize:RESIZE_UI(26)];
//    self.earnOfPercent.font = [UIFont fontWithName:@ "Helvetica-Bold"  size:(26)];
    [self.contentView addSubview:self.earnOfPercent];
    [self.earnOfPercent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(31));
        make.left.equalTo(self.contentView.mas_left).with.offset(RESIZE_UI(37));
    }];
    
    self.jiaxiImageView = [[UIImageView alloc]init];
    self.jiaxiImageView.image = [UIImage imageNamed:@"tab_syhl"];
    [self addSubview:self.jiaxiImageView];
    [self.jiaxiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(RESIZE_UI(24));
        make.height.mas_offset(RESIZE_UI(29));
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(103));
    }];
    
    self.jiaxiLabel = [[UILabel alloc]init];
    self.jiaxiLabel.textColor = [UIColor blackColor];
    self.jiaxiLabel.font = [UIFont systemFontOfSize:RESIZE_UI(9)];
    self.jiaxiLabel.text = @"+1.0";
    [self.jiaxiImageView addSubview:self.jiaxiLabel];
    [self.jiaxiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_jiaxiImageView.mas_centerX);
        make.centerY.equalTo(self.jiaxiImageView.mas_centerY).with.offset(-2);
    }];
    
    self.earnOfYearLable = [[UILabel alloc] init];
    self.earnOfYearLable.text = @"预期年化收益";
    self.earnOfYearLable.textAlignment = NSTextAlignmentLeft;
//    self.earnOfYearLable.backgroundColor = [UIColor redColor];
    self.earnOfYearLable.textColor = RGBA(153, 153, 153, 1.0) ;
    self.earnOfYearLable.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    [self.contentView addSubview:self.earnOfYearLable];
    [self.earnOfYearLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.earnOfPercent.mas_bottom).with.offset(RESIZE_UI(16));
        make.left.equalTo(self.earnOfPercent.mas_left);
    }];
    
    _labelForManageMoneyDay = [[UILabel alloc]init];
//    _labelForManageMoneyDay.text = @"108天";
    _labelForManageMoneyDay.textColor = RGBA(3, 3, 3, 1.0);
    _labelForManageMoneyDay.font = [UIFont systemFontOfSize:RESIZE_UI(21)];
    [self addSubview:_labelForManageMoneyDay];
    [_labelForManageMoneyDay mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(60));
        make.bottom.equalTo(self.earnOfPercent.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    
    UILabel *labelForManageDayTitle = [[UILabel alloc]init];
    labelForManageDayTitle.text = @"到期日";
//    labelForManageDayTitle.backgroundColor = [UIColor redColor];
    labelForManageDayTitle.textColor = RGBA(153, 153, 153, 1.0);
    labelForManageDayTitle.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    [self addSubview:labelForManageDayTitle];
    [labelForManageDayTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_labelForManageMoneyDay.mas_centerX);
        make.bottom.equalTo(self.earnOfYearLable.mas_bottom);
    }];
    
    _progressView = [[ProgressView alloc]init];
//    _progressView.arcFinishColor = RGBA(0, 108, 175, 1.0);
//    _progressView.arcUnfinishColor = RGBA(0, 108, 175, 1.0);
    
    _progressView.arcFinishColor = NEWYEARCOLOR;
    _progressView.arcUnfinishColor = NEWYEARCOLOR;
    _progressView.centerColor = [UIColor whiteColor];
    _progressView.arcBackColor = RGBA(246, 246, 246, 1.0);
    _progressView.width = RESIZE_UI(6);
    _progressView.percent = 0.9;
    [self.contentView addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_offset(RESIZE_UI(41));
        make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(23));
        make.right.equalTo(self.mas_right).with.offset(RESIZE_UI(-41));
    }];
    
    self.progressLable = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(270, 60, 80, 12))];
    self.progressLable.text = @"购买进度";
//    self.progressLable.backgroundColor = [UIColor redColor];
    self.progressLable.textAlignment = NSTextAlignmentCenter;
    self.progressLable.textColor = RGBA(153, 153, 153, 1.0);
    self.progressLable.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    [self.contentView addSubview:self.progressLable];
    [self.progressLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.earnOfYearLable.mas_bottom);
        make.centerX.equalTo(_progressView.mas_centerX);
    }];
    
    _endImageView = [[UIImageView alloc]init];
    _endImageView.image = [UIImage imageNamed:@"icon_ysq"];
    [self addSubview:_endImageView];
    [_endImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.height.mas_offset(RESIZE_UI(53));
        make.width.mas_offset(RESIZE_UI(61));
    }];
    
    UIView *bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = RGBA(239, 239, 239, 1.0);
    [self addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_offset(1);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    
}

/* 立即购买 */
- (void)buyBtnAction {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonClickProductModel:)]) {
        [self.delegate buttonClickProductModel:_productModelHa];
    }
}

- (void)configCellWithModel:(ProductModel *)model {
    
    _productModelHa = model;
    _progressView.percent = [model.buyrate floatValue];
    if (_productModelHa.segment.count != 0) {
        LongProductSegment *longProduct = _productModelHa.segment[0];
//            NSLog(@"我的利率:%@",longProduct.returnrate);
        double returnrate_plus = [_productModelHa.returnrate_plus doubleValue];
        double returnrate_original = [longProduct.returnrate doubleValue];
        double longRateFloat = (returnrate_original-returnrate_plus) * 100;
        NSNumber *longRateNumber = [NSNumber numberWithDouble:longRateFloat];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.roundingMode = NSNumberFormatterRoundFloor;
        formatter.minimumFractionDigits = 1;
        NSString *earnOfPercentStr = [NSString stringWithFormat:@"%@％",[formatter stringFromNumber:longRateNumber]];
        self.earnOfPercent.text = earnOfPercentStr;
    
        //加息的标志
        if ([[SingletonManager convertNullString:_productModelHa.returnrate_plus] isEqualToString:@"0"]) {
            self.jiaxiLabel.hidden = YES;
            self.jiaxiImageView.hidden = YES;
        } else {
            self.jiaxiLabel.hidden = NO;
            self.jiaxiImageView.hidden = NO;
//            NSNumber *jiaxiNumber = [NSNumber numberWithDouble:returnrate_plus*100];
//            self.jiaxiLabel.text = [NSString stringWithFormat:@"+%g％",returnrate_plus*100];
            self.jiaxiLabel.text = [NSString stringWithFormat:@"+%g",returnrate_plus*100];
//            CGSize lblSize = [self.jiaxiLabel.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:RESIZE_UI(9)]} context:nil].size;
//            //        NSLog(@"我的宽度:%.1f",lblSize.width);
//            CGFloat imgWidth = lblSize.width+RESIZE_UI(10);
//            [self.jiaxiImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.width.mas_offset(imgWidth);
//                make.height.mas_equalTo(imgWidth/29*17);
//            }];
        }
        
        NSString *endTimeUnit = [NSString stringWithFormat:@"%@天",longProduct.duration];
        _labelForManageMoneyDay.attributedText =  [self changeStringWithString:endTimeUnit withFrontColor:RGBA(255, 86, 30, 1.0) WithBehindColor:RGBA(255, 86, 30, 1.0) withFrontFont:[UIFont systemFontOfSize:RESIZE_UI(21)] WithBehindFont:[UIFont systemFontOfSize:RESIZE_UI(13)]];
        if (![model.isdown isEqualToString:@"0"]) {
            self.earnOfPercent.textColor = RGBA(237, 237, 237, 1.0);
            _labelForManageMoneyDay.textColor = RGBA(237, 237, 237, 1.0);
            _endImageView.hidden = NO;
            self.jiaxiImageView.image = [UIImage imageNamed:@"tab_syhl_grey"];
            self.jiaxiLabel.textColor = RGBA(161, 161, 161, 1.0);
        } else {
//            self.earnOfPercent.textColor = RGBA(255, 88, 26, 1.0);
            self.earnOfPercent.textColor = NEWYEARCOLOR;
            _labelForManageMoneyDay.textColor = RGBA(3, 3, 3, 1.0);
            _endImageView.hidden = YES;
            self.jiaxiImageView.image = [UIImage imageNamed:@"tab_syhl"];
            self.jiaxiLabel.textColor = [UIColor blackColor];
        }
    }
    
}

- (NSAttributedString *)changeStringWithString:(NSString *)string withFrontColor:(UIColor *)frontColor WithBehindColor:(UIColor *)behindColor withFrontFont:(UIFont *)frontFont WithBehindFont:(UIFont *)behindFont {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:frontColor range:NSMakeRange(0, [string length])];
    [str addAttribute:NSForegroundColorAttributeName value:behindColor range:NSMakeRange([string length] - 1, 1)];
    [str addAttribute:NSFontAttributeName value:frontFont range:NSMakeRange(0, [string length])];
    [str addAttribute:NSFontAttributeName value:behindFont range:NSMakeRange([string length] - 1,1)];
    return str;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
