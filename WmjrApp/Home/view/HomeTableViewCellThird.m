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
    self.earnOfPercent.font = [UIFont systemFontOfSize:RESIZE_UI(22)];
    [self.contentView addSubview:self.earnOfPercent];
    [self.earnOfPercent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(31));
        make.left.equalTo(self.contentView.mas_left).with.offset(RESIZE_UI(37));
    }];
    
    self.earnOfYearLable = [[UILabel alloc] init];
    self.earnOfYearLable.text = @"预期年化收益";
    self.earnOfYearLable.textAlignment = NSTextAlignmentLeft;
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
    labelForManageDayTitle.textColor = RGBA(153, 153, 153, 1.0);
    labelForManageDayTitle.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    [self addSubview:labelForManageDayTitle];
    [labelForManageDayTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_labelForManageMoneyDay.mas_centerX);
        make.centerY.equalTo(self.earnOfYearLable.mas_centerY);
    }];
    
    _progressView = [[ProgressView alloc]init];
    _progressView.arcFinishColor = RGBA(0, 108, 175, 1.0);
    _progressView.arcUnfinishColor = RGBA(0, 108, 175, 1.0);
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
    self.progressLable.textAlignment = NSTextAlignmentCenter;
    self.progressLable.textColor = RGBA(153, 153, 153, 1.0);
    self.progressLable.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    [self.contentView addSubview:self.progressLable];
    [self.progressLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.earnOfYearLable.mas_centerY);
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
        //    NSLog(@"我的利率:%@",longProduct.returnrate);
        CGFloat longRateFloat = [longProduct.returnrate floatValue] * 100;
        NSNumber *longRateNumber = [NSNumber numberWithFloat:longRateFloat];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.roundingMode = NSNumberFormatterRoundFloor;
        formatter.minimumFractionDigits = 1;
        NSString *earnOfPercentStr = [NSString stringWithFormat:@"%@％",[formatter stringFromNumber:longRateNumber]];
        self.earnOfPercent.text = earnOfPercentStr;
        _labelForManageMoneyDay.text = longProduct.duration;
        if (![model.isdown isEqualToString:@"0"]) {
            self.earnOfPercent.textColor = RGBA(237, 237, 237, 1.0);
            _labelForManageMoneyDay.textColor = RGBA(237, 237, 237, 1.0);
            _endImageView.hidden = NO;
        } else {
            self.earnOfPercent.textColor = RGBA(255, 88, 26, 1.0);
            _labelForManageMoneyDay.textColor = RGBA(3, 3, 3, 1.0);
            _endImageView.hidden = YES;
        }
    }
    
    
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
