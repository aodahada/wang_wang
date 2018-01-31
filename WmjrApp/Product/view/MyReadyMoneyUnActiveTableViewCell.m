//
//  MyReadyMoneyUnActiveTableViewCell.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/29.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "MyReadyMoneyUnActiveTableViewCell.h"
#import "RedPackageModel.h"

@implementation MyReadyMoneyUnActiveTableViewCell

- (instancetype)initWithRedPackageModel:(RedPackageModel *)redModel {
    self = [super init];
    if (self) {
        self.backgroundColor = RGBA(243, 244, 246, 1.0);
//        UIImageView *lineImage = [[UIImageView alloc]init];
//        lineImage.image = [UIImage imageNamed:@"image_hbbj"];
//        lineImage.userInteractionEnabled = YES;
//        [self addSubview:lineImage];
//        [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];
        
        UIImageView *topView = [[UIImageView alloc]init];
//        topView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
        topView.image = [UIImage imageNamed:@"image_hbbj"];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_offset(RESIZE_UI(130));
        }];
        
        UILabel *titelLabel = [[UILabel alloc]init];
        titelLabel.text =redModel.name;
        titelLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(17)];
        titelLabel.textColor = RGBA(102, 102, 102, 1.0);
        [topView addSubview:titelLabel];
        [titelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(15));
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(15));
        }];
        
        UILabel *moneyContent = [[UILabel alloc]init];
        moneyContent.text = redModel.money;
        moneyContent.textColor = RGBA(255, 88, 26, 1.0);
        moneyContent.font = [UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(32)];
        [topView addSubview:moneyContent];
        [moneyContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topView.mas_left).with.offset(RESIZE_UI(28));
            make.top.equalTo(titelLabel.mas_bottom).with.offset(RESIZE_UI(9));
        }];
        
        UILabel *moneyTitle = [[UILabel alloc]init];
        moneyTitle.text = @"¥";
        moneyTitle.textColor = RGBA(255, 88, 26, 1.0);
        moneyTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(18)];
        [topView addSubview:moneyTitle];
        [moneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(moneyContent.mas_left);
            make.centerY.equalTo(moneyContent.mas_centerY);
        }];
        
        UILabel *resourceLabel = [[UILabel alloc]init];
        resourceLabel.text = [NSString stringWithFormat:@"来源:%@",redModel.product_name];
        resourceLabel.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        resourceLabel.textColor = RGBA(153, 153, 153, 1.0);
        [topView addSubview:resourceLabel];
        [resourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(topView.mas_bottom).with.offset(-RESIZE_UI(10));
            make.left.equalTo(topView.mas_left).with.offset(RESIZE_UI(15));
        }];
        
        UIButton *jihuoButton = [[UIButton alloc]init];
        [jihuoButton setBackgroundImage:[UIImage imageNamed:@"btn_wjh"] forState:UIControlStateNormal];
        [topView addSubview:jihuoButton];
        [jihuoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topView.mas_centerY);
            make.right.equalTo(topView.mas_right).with.offset(-RESIZE_UI(27));
            make.width.height.mas_offset(RESIZE_UI(68));
        }];
        
        UIImageView *bottomView = [[UIImageView alloc]init];
//        bottomView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
        bottomView.image = [UIImage imageNamed:@"Combined Shape Copy 4"];
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        UILabel *tipLabel = [[UILabel alloc]init];
        tipLabel.numberOfLines = 2;
        tipLabel.text = [NSString stringWithFormat:@"未激活红包将在出借产品到期后（%@）自动激活，激活后点击“领取”即可立即领取红包到账户余额",redModel.end_time];
        tipLabel.textColor = RGBA(153, 153, 153, 1.0);
        tipLabel.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        [bottomView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottomView.mas_top).with.offset(RESIZE_UI(7));
            make.left.equalTo(bottomView.mas_left).with.offset(RESIZE_UI(15));
            make.right.equalTo(bottomView.mas_right).with.offset(-RESIZE_UI(15));
            make.height.mas_offset(RESIZE_UI(34));
        }];
        
    }
    return self;
}

@end

