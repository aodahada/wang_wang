//
//  HomeTableViewCellThird.m
//  WmjrApp
//
//  Created by horry on 2016/10/31.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "HomeTableViewCellThird.h"
#import "ProgressView.h"

@interface HomeTableViewCellThird ()

@property (nonatomic, strong) ProgressView *progressView;
@property (nonatomic, strong) ProductModel *productModelHa;

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
    
    self.billLable = [[UILabel alloc] init];
//    self.billLable.text = @"07期哈哈哈哈哈";
    self.billLable.textAlignment = NSTextAlignmentLeft;
    self.billLable.textColor = RGBA(102, 102, 102, 1.0);
//    self.billLable.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    [self.billLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(17)]];
    [self.contentView addSubview:self.billLable];
    [self.billLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(RESIZE_UI(15));
        make.left.equalTo(self.contentView.mas_left).with.offset(RESIZE_UI(12));
        make.height.mas_offset(RESIZE_UI(17));
    }];
    
    self.imageViewForNewer = [[UIImageView alloc]init];
    self.imageViewForNewer.image = [UIImage imageNamed:@"icon_hotxrg"];
    [self addSubview:self.imageViewForNewer];
    [self.imageViewForNewer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(14));
        make.left.equalTo(self.billLable.mas_right).with.offset(RESIZE_UI(10));
        make.width.mas_offset(RESIZE_UI(50));
        make.height.mas_offset(RESIZE_UI(20));
    }];
    
    
    self.earnOfPercent = [[UILabel alloc] init];
    self.earnOfPercent.textAlignment = NSTextAlignmentCenter;
//        self.earnOfPercent.text = @"5.50%";
    self.earnOfPercent.textColor = ORANGE_COLOR;
    self.earnOfPercent.font = [UIFont systemFontOfSize:RESIZE_UI(50)];
    [self.contentView addSubview:self.earnOfPercent];
    [self.earnOfPercent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(46));
        make.left.equalTo(self.contentView.mas_left).with.offset(RESIZE_UI(12));
        make.height.mas_offset(RESIZE_UI(38));
    }];
    
    self.earnOfYearLable = [[UILabel alloc] init];
    self.earnOfYearLable.text = @"预期年化收益";
    self.earnOfYearLable.textAlignment = NSTextAlignmentLeft;
    self.earnOfYearLable.textColor = RGBA(102, 102, 102, 1.0) ;
    self.earnOfYearLable.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    [self.contentView addSubview:self.earnOfYearLable];
    [self.earnOfYearLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(91));
        make.left.equalTo(self.earnOfPercent.mas_left);
        make.height.mas_offset(RESIZE_UI(17));
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
    
    UILabel *labelForDay = [[UILabel alloc]init];
    labelForDay.text = @"天";
    labelForDay.textColor = RGBA(3, 3, 3, 1.0);
    labelForDay.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    [self addSubview:labelForDay];
    [labelForDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_labelForManageMoneyDay.mas_bottom).with.offset(RESIZE_UI(-2));
        make.left.equalTo(_labelForManageMoneyDay.mas_right);
//        make.height.mas_offset(25);
    }];
    
    UILabel *labelForManageDayTitle = [[UILabel alloc]init];
    labelForManageDayTitle.text = @"理财期限";
    labelForManageDayTitle.textColor = RGBA(102, 102, 102, 1.0);
    labelForManageDayTitle.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    [self addSubview:labelForManageDayTitle];
    [labelForManageDayTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(91));
        make.centerX.equalTo(_labelForManageMoneyDay.mas_centerX);
        make.height.mas_offset(RESIZE_UI(17));
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
        make.height.width.mas_offset(RESIZE_UI(44));
//        make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(42));
        make.bottom.equalTo(self.earnOfPercent.mas_bottom);
        make.right.equalTo(self.mas_right).with.offset(RESIZE_UI(-41));
    }];
    
    self.progressLable = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(270, 60, 80, 12))];
    self.progressLable.text = @"购买进度";
    self.progressLable.textAlignment = NSTextAlignmentCenter;
    self.progressLable.textColor = RGBA(102, 102, 102, 1.0);
    self.progressLable.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    [self.contentView addSubview:self.progressLable];
    [self.progressLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(91));
        make.centerX.equalTo(_progressView.mas_centerX);
        make.height.mas_offset(RESIZE_UI(17));
    }];
    
    UIView *viewForBottom = [[UIView alloc]init];
    viewForBottom.backgroundColor = RGBA(239, 239, 239, 1.0);
    [self addSubview:viewForBottom];
    [viewForBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.earnOfYearLable.mas_bottom).with.offset(RESIZE_UI(14));
        make.height.mas_offset(RESIZE_UI(14));
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    
    UILabel *labelForLine = [[UILabel alloc]init];
    labelForLine.backgroundColor = RGBA(239, 239, 239, 1.0);
    [self addSubview:labelForLine];
    [labelForLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(36));
        make.right.equalTo(self.mas_right).with.offset(RESIZE_UI(-123));
        make.width.mas_offset(1);
        make.height.mas_offset(RESIZE_UI(66));
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
    _labelForManageMoneyDay.text = model.day;
    self.buyNum =  [model.buyrate floatValue] * 100;
    self.billLable.text = model.name;
    _progressView.percent = [model.buyrate floatValue];
    NSString *earnOfPercentStr = [NSString stringWithFormat:@"%.2lf％", [model.returnrate floatValue] * 100];
    self.earnOfPercent.attributedText =  [self changeStringWithString:earnOfPercentStr withFrontColor:RGBA(255, 86, 30, 1.0) WithBehindColor:RGBA(255, 86, 30, 1.0) withFrontFont:[UIFont systemFontOfSize:RESIZE_UI(33)] WithBehindFont:[UIFont systemFontOfSize:RESIZE_UI(22)]];
    
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
