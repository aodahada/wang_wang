//
//  HomeTableViewCellFirst.m
//  WmjrApp
//
//  Created by horry on 2016/10/31.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "HomeTableViewCellFirst.h"
#import "PersonInvestModel.h"

@interface HomeTableViewCellFirst ()

@property (nonatomic, strong) PersonInvestModel *personalModel;
@property (nonatomic, strong) UIImageView *topImageView;

@end

@implementation HomeTableViewCellFirst

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithDic:(PersonInvestModel *)personModel {
    self = [super init];
    if (self) {
        _personalModel = personModel;
        _topImageView = [[UIImageView alloc]init];
        _topImageView.image = [UIImage imageNamed:@"image_top"];
//        NSString *imageUrl = @"http://api.wmjr888.com/Uploads/app-banner.png";
//        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"image_top"]];
        _topImageView.userInteractionEnabled = YES;
        [self addSubview:_topImageView];
        [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UIImageView *imageViewForLeft = [[UIImageView alloc]init];
        imageViewForLeft.image = [UIImage imageNamed:@"navi_bar"];
        [self addSubview:imageViewForLeft];
        [imageViewForLeft mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(35);
            make.left.equalTo(self.mas_left).with.offset(13);
            make.height.mas_offset(RESIZE_UI(17));
            make.width.mas_offset(RESIZE_UI(100));
        }];
        
//        UIButton *buttonForMess = [[UIButton alloc]init];
//        [buttonForMess setTitle:@"消息中心" forState:UIControlStateNormal];
//        buttonForMess.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
//        [buttonForMess setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
//        [buttonForMess addTarget:self action:@selector(jumpToMessageCenterMethod) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:buttonForMess];
//        [buttonForMess mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.mas_top).with.offset(38);
//            make.right.equalTo(self.mas_right).with.offset(-12);
//            make.height.mas_offset(14);
//        }];
        
        //新浪平台
        UIButton *buttonSinaCenter = [[UIButton alloc]init];
        [buttonSinaCenter setTitle:@"安全保障" forState:UIControlStateNormal];
        buttonSinaCenter.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        [buttonSinaCenter setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
        [buttonSinaCenter addTarget:self action:@selector(jumpToSinaMethod) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonSinaCenter];
        [buttonSinaCenter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(38);
            make.right.equalTo(self.mas_right).with.offset(-53);
            make.height.mas_offset(14);
        }];
        
        //竖线
        UILabel *labelForLine = [[UILabel alloc]init];
        labelForLine.backgroundColor = [UIColor whiteColor];
        [self addSubview:labelForLine];
        [labelForLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(buttonSinaCenter.mas_top);
            make.bottom.equalTo(buttonSinaCenter.mas_bottom);
            make.width.mas_offset(1);
            make.left.equalTo(buttonSinaCenter.mas_right).with.offset(12);
        }];
        
        //消息中心
        UIImageView *imageForMess = [[UIImageView alloc]init];
        imageForMess.image = [UIImage imageNamed:@"notific"];
        [self addSubview:imageForMess];
        [imageForMess mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-12);
            make.centerY.equalTo(buttonSinaCenter.mas_centerY);
            make.height.mas_offset(19);
            make.width.mas_offset(15);
        }];
        
        UIButton *buttonForMess = [[UIButton alloc]init];
        buttonForMess.backgroundColor = [UIColor clearColor];
        [buttonForMess addTarget:self action:@selector(jumpToMessageCenterMethod) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonForMess];
        [buttonForMess mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(labelForLine.mas_right);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(labelForLine.mas_top);
            make.bottom.equalTo(labelForLine.mas_bottom);
        }];
        
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        BOOL isNull = [self isNullString:uid];
        if (isNull) {
            [self dontLoginView];
        } else {
            //登录后的
            [self alreadyLoginView];
        }
    }
    return self;
}

- (void)dontLoginView {
    
//    UIImageView *backgroundImageView = [[UIImageView alloc]init];
//    backgroundImageView.image = [UIImage imageNamed:@"image_background2"];
//    backgroundImageView.userInteractionEnabled = YES;
//    [self addSubview:backgroundImageView];
//    [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
    _topImageView.image = [UIImage imageNamed:@"image_top_youzi"];
    
    UIView *viewForConsult = [[UIView alloc]init];
    viewForConsult.backgroundColor = [UIColor clearColor];
    [self addSubview:viewForConsult];
    [viewForConsult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(RESIZE_UI(-12));
        make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(173));
        make.width.mas_offset(RESIZE_UI(95));
        make.height.mas_offset(RESIZE_UI(17));
    }];
    
    UILabel *labelForConsult = [[UILabel alloc]init];
    labelForConsult.text = @"咨询联系客服";
    labelForConsult.textColor = [UIColor whiteColor];
    labelForConsult.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    [viewForConsult addSubview:labelForConsult];
    [labelForConsult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewForConsult.mas_top);
        make.bottom.equalTo(viewForConsult.mas_bottom);
        make.right.equalTo(viewForConsult.mas_right);
        make.width.mas_offset(RESIZE_UI(74));
    }];
    
    UIImageView *imageViewForConsult = [[UIImageView alloc]init];
    imageViewForConsult.image = [UIImage imageNamed:@"icon_zixun"];
    [viewForConsult addSubview:imageViewForConsult];
    [imageViewForConsult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewForConsult.mas_centerY);
        make.left.equalTo(viewForConsult.mas_left);
        make.height.width.mas_offset(RESIZE_UI(15));
    }];
    
    UIButton *buttonForConsult = [[UIButton alloc]init];
    buttonForConsult.backgroundColor = [UIColor clearColor];
    [buttonForConsult addTarget:self action:@selector(consultMethod) forControlEvents:UIControlEventTouchUpInside];
    [viewForConsult addSubview:buttonForConsult];
    [buttonForConsult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewForConsult);
    }];
}

- (void)alreadyLoginView {
    
    UILabel *labelForTitle = [[UILabel alloc]init];
    labelForTitle.text = @"累计收益(元)";
    labelForTitle.textColor = RGBA(254, 243, 243, 1.0);
    labelForTitle.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    [self addSubview:labelForTitle];
    [labelForTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(80));
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_offset(RESIZE_UI(20));
    }];
    
    UILabel *labelForYesterDayMoney = [[UILabel alloc]init];
    labelForYesterDayMoney.text = _personalModel.total_income;
    labelForYesterDayMoney.font = [UIFont systemFontOfSize:RESIZE_UI(48)];
    labelForYesterDayMoney.textColor = RGBA(255, 255, 255, 1.0);
    [self addSubview:labelForYesterDayMoney];
    [labelForYesterDayMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(112));
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_offset(RESIZE_UI(49));
    }];
    
    UILabel *labelForLine = [[UILabel alloc]init];
    labelForLine.backgroundColor = RGBA(255, 233, 228, 1.0);
    [self addSubview:labelForLine];
    [labelForLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(173));
        make.width.mas_offset(1);
        make.height.mas_offset(RESIZE_UI(14));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    UILabel *labelForSumMoney = [[UILabel alloc]init];
    labelForSumMoney.text = _personalModel.current_invest;
    labelForSumMoney.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    labelForSumMoney.textColor = RGBA(254, 243, 243, 1.0);
    [self addSubview:labelForSumMoney];
    [labelForSumMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(174));
        make.right.equalTo(labelForLine.mas_left).with.offset(RESIZE_UI(-16));
    }];
    
    UILabel *labelForSumMoneyTitle = [[UILabel alloc]init];
    labelForSumMoneyTitle.text = @"当前投资";
    labelForSumMoneyTitle.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    labelForSumMoneyTitle.textColor = RGBA(255, 255, 255, 1.0);
    [self addSubview:labelForSumMoneyTitle];
    [labelForSumMoneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(174));
        make.right.equalTo(labelForSumMoney.mas_left).with.offset(RESIZE_UI(-10));
    }];
    
    UILabel *labelForRaiseMoneyTitle = [[UILabel alloc]init];
    labelForRaiseMoneyTitle.text = @"账户余额";
    labelForRaiseMoneyTitle.textColor = RGBA(255, 255, 255, 1.0);
    labelForRaiseMoneyTitle.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    [self addSubview:labelForRaiseMoneyTitle];
    [labelForRaiseMoneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(174));
        make.left.equalTo(labelForLine.mas_right).with.offset(RESIZE_UI(16));
    }];
    
    UILabel *labelForRaiseMoney = [[UILabel alloc]init];
    labelForRaiseMoney.text = _personalModel.account_rest;
    labelForRaiseMoney.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    labelForRaiseMoney.textColor = RGBA(254, 243, 243, 1.0);
    [self addSubview:labelForRaiseMoney];
    [labelForRaiseMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(174));
        make.left.equalTo(labelForRaiseMoneyTitle.mas_right).with.offset(RESIZE_UI(10));
    }];
    
}

#pragma mark - 进入消息中心
- (void)jumpToMessageCenterMethod {
    if (self.jumpToMessageCenter) {
        self.jumpToMessageCenter();
    }
}

#pragma mark - 跳转到新浪
- (void)jumpToSinaMethod {
//    NSLog(@"跳转到新浪");
    if (self.learnWangma) {
        self.learnWangma();
    }
}

#pragma mark - 咨询客服
- (void)consultMethod {
//    NSLog(@"咨询");
    if (self.contactWangma) {
        self.contactWangma();
    }
    
}

- (BOOL) isNullString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
