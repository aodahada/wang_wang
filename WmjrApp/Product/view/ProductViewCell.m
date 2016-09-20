//
//  ProductViewCell.m
//  wangmajinrong
//
//  Created by 1 & 0 on 15/6/23.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "ProductViewCell.h"
#import "ProgressView.h"

@interface ProductViewCell ()

@property (nonatomic, strong) ProgressView *progressView;
@property (nonatomic, strong) ProductModel *productModelHa;

@end

@implementation ProductViewCell

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
    
    self.billLable = [[UILabel alloc] init];
    self.billLable.textAlignment = NSTextAlignmentLeft;
    self.billLable.textColor = TITLE_COLOR;
    self.billLable.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.billLable];
    [self.billLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(15);
        make.left.equalTo(self.contentView.mas_left).with.offset(12);
//        make.height.mas_offset(20);
    }];

    self.imageViewForNewer = [[UIImageView alloc]init];
    self.imageViewForNewer.image = [UIImage imageNamed:@"icon_xrg"];
    [self.contentView addSubview:self.imageViewForNewer];
    [self.imageViewForNewer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(18);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.width.mas_offset(50);
        make.height.mas_offset(19);
    }];
    
    
    self.earnOfPercent = [[UILabel alloc] init];
    self.earnOfPercent.textAlignment = NSTextAlignmentCenter;
//    self.earnOfPercent.text = @"5.50%";
    self.earnOfPercent.textColor = ORANGE_COLOR;
    self.earnOfPercent.font = [UIFont systemFontOfSize:50];
    [self.contentView addSubview:self.earnOfPercent];
    [self.earnOfPercent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(48);
        make.left.equalTo(self.contentView.mas_left).with.offset(12);
        make.height.mas_offset(45);
    }];
    
    self.earnOfYearLable = [[UILabel alloc] init];
    self.earnOfYearLable.text = @"预期年化收益";
    self.earnOfYearLable.textAlignment = NSTextAlignmentLeft;
    self.earnOfYearLable.textColor = TITLE_COLOR ;
    self.earnOfYearLable.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.earnOfYearLable];
    [self.earnOfYearLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.earnOfPercent.mas_bottom).with.offset(10);
        make.left.equalTo(self.earnOfPercent.mas_left);
        make.bottom.equalTo(self.mas_bottom).with.offset(-14);
        make.height.mas_offset(15);
    }];
    
    self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.buyBtn.frame = RESIZE_FRAME(CGRectMake(275, 15, 85, 20));
    [self.buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.buyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.buyBtn addTarget:self action:@selector(buyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.buyBtn];
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(61);
        make.right.equalTo(self.mas_right).with.offset(-12);
        make.height.mas_offset(33);
        make.width.mas_offset(77);
    }];
    
    _progressView = [[ProgressView alloc]init];
    _progressView.arcFinishColor = RGBA(0, 108, 175, 1.0);
    _progressView.arcUnfinishColor = RGBA(0, 108, 175, 1.0);
    _progressView.centerColor = [UIColor whiteColor];
    _progressView.arcBackColor = RGBA(246, 246, 246, 1.0);
    _progressView.width = 6.0f;
    _progressView.percent = 0.9;
    [self.contentView addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_offset(49);
        make.centerY.equalTo(self.earnOfPercent.mas_centerY).with.offset(-2);
//        make.left.equalTo(self.earnOfPercent.mas_right).with.offset(20);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    self.progressLable = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(270, 60, 80, 12))];
    self.progressLable.text = @"购买进度";
    self.progressLable.textAlignment = NSTextAlignmentCenter;
    self.progressLable.textColor = TITLE_COLOR;
    self.progressLable.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.progressLable];
    [self.progressLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_progressView.mas_centerX);
        make.bottom.equalTo(self.earnOfYearLable.mas_bottom);
        make.height.mas_offset(15);
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
    if ([model.is_down isEqualToString:@"0"]) {
        self.buyBtn.enabled = YES;
        [self.buyBtn setBackgroundColor:RGBA(255, 86, 44, 1.0)];
        [self.buyBtn setTitle:@"抢购" forState:UIControlStateNormal];
    } else {
        self.buyBtn.enabled = NO;
        [self.buyBtn setBackgroundColor:RGBA(231, 231, 231, 1.0)];
        [self.buyBtn setTitle:@"售罄" forState:UIControlStateNormal];
    }
    self.buyNum =  [model.buyrate floatValue] * 100;
    self.billLable.text = model.name;
//    self.bankAcceptLable.text = model.acceptance;
    if ([model.is_newer isEqualToString:@"1"]) {
        self.imageViewForNewer.hidden = NO;
    } else {
        self.imageViewForNewer.hidden = YES;
    }

    _progressView.percent = [model.buyrate floatValue];
    NSString *earnOfPercentStr = [NSString stringWithFormat:@"%.2lf％", [model.returnrate floatValue] * 100];
    self.earnOfPercent.attributedText =  [self changeStringWithString:earnOfPercentStr withFrontColor:RGBA(255, 86, 30, 1.0) WithBehindColor:RGBA(255, 86, 30, 1.0) withFrontFont:[UIFont systemFontOfSize:45] WithBehindFont:[UIFont systemFontOfSize:22]];

}

- (NSAttributedString *)changeStringWithString:(NSString *)string withFrontColor:(UIColor *)frontColor WithBehindColor:(UIColor *)behindColor withFrontFont:(UIFont *)frontFont WithBehindFont:(UIFont *)behindFont {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:frontColor range:NSMakeRange(0, [string length])];
    [str addAttribute:NSForegroundColorAttributeName value:behindColor range:NSMakeRange([string length] - 1, 1)];
    [str addAttribute:NSFontAttributeName value:frontFont range:NSMakeRange(0, [string length])];
    [str addAttribute:NSFontAttributeName value:behindFont range:NSMakeRange([string length] - 3, 3)];
    return str;
}

//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
////    UIColor *aColor = BASECOLOR;
//    UIColor *aColor = RGBA(0, 108, 175, 1.0);
//    CGContextSetFillColorWithColor(context, aColor.CGColor);
//    CGContextMoveToPoint(context, RESIZE_UI(313), RESIZE_UI(102));
//    CGFloat degree = 0.00;
//    if (self.buyNum > 0 && self.buyNum <= 25) {
//        degree = 90 * (self.buyNum / 25 - 1);
//    } else if (self.buyNum == 0) {
//        degree = -90;
//    } else {
//        degree = 360 * (self.buyNum / 100) - 90;
//    }
//    CGContextAddArc(context, RESIZE_UI(313), RESIZE_UI(102), RESIZE_UI(23), -90 * M_PI / 180, degree * M_PI / 180, 0);
//    CGContextClosePath(context);
//    CGContextDrawPath(context, kCGPathFill);
//}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
