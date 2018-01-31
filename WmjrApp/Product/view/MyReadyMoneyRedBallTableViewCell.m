//
//  MyReadyMoneyRedBallTableViewCell.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/29.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "MyReadyMoneyRedBallTableViewCell.h"
#import "RedPackageModel.h"

@interface MyReadyMoneyRedBallTableViewCell ()

@property (nonatomic, strong)RedPackageModel *remodel;

@end

@implementation MyReadyMoneyRedBallTableViewCell

- (instancetype)initWithRedPackageModel:(RedPackageModel *)redModel {
    self = [super init];
    if (self) {
        _remodel = redModel;
        self.backgroundColor = RGBA(243, 244, 246, 1.0);
        UIImageView *lineImage = [[UIImageView alloc]init];
        lineImage.image = [UIImage imageNamed:@"image_hbbj"];
        lineImage.userInteractionEnabled = YES;
        [self addSubview:lineImage];
        [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UILabel *titelLabel = [[UILabel alloc]init];
        titelLabel.text =redModel.name;
        titelLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(17)];
        if ([redModel.status isEqualToString:@"1"]) {
            titelLabel.textColor = RGBA(153, 153, 153, 1.0);
        } else {
            titelLabel.textColor = RGBA(102, 102, 102, 1.0);
        }
        [lineImage addSubview:titelLabel];
        [titelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(15));
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(15));
        }];
        
        UILabel *moneyContent = [[UILabel alloc]init];
        moneyContent.text = redModel.money;
        if ([redModel.status isEqualToString:@"1"]) {
            moneyContent.textColor = RGBA(153, 153, 153, 1.0);
        } else {
            moneyContent.textColor = RGBA(255, 88, 26, 1.0);
        }
        moneyContent.font = [UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(32)];
        [lineImage addSubview:moneyContent];
        [moneyContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lineImage.mas_left).with.offset(RESIZE_UI(28));
            make.top.equalTo(titelLabel.mas_bottom).with.offset(RESIZE_UI(9));
        }];
        
        UILabel *moneyTitle = [[UILabel alloc]init];
        moneyTitle.text = @"¥";
        if ([redModel.status isEqualToString:@"1"]) {
            moneyTitle.textColor = RGBA(153, 153, 153, 1.0);
        } else {
            moneyTitle.textColor = RGBA(255, 88, 26, 1.0);
        }
        moneyTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(18)];
        [lineImage addSubview:moneyTitle];
        [moneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(moneyContent.mas_left);
            make.centerY.equalTo(moneyContent.mas_centerY);
        }];
        
        UILabel *resourceLabel = [[UILabel alloc]init];
        resourceLabel.text = [NSString stringWithFormat:@"来源:%@",redModel.product_name];
        resourceLabel.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        resourceLabel.textColor = RGBA(153, 153, 153, 1.0);
        [lineImage addSubview:resourceLabel];
        [resourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lineImage.mas_bottom).with.offset(-RESIZE_UI(10));
            make.left.equalTo(lineImage.mas_left).with.offset(RESIZE_UI(15));
        }];
        
        UIButton *jihuoButton = [[UIButton alloc]init];
        if ([redModel.status isEqualToString:@"4"]) {
            [jihuoButton setBackgroundImage:[UIImage imageNamed:@"btn_ylq"] forState:UIControlStateNormal];
        } else {
            [jihuoButton setBackgroundImage:[UIImage imageNamed:@"btn_ljlq"] forState:UIControlStateNormal];
            [jihuoButton addTarget:self action:@selector(jihuoMethod) forControlEvents:UIControlEventTouchUpInside];
        }
        [lineImage addSubview:jihuoButton];
        [jihuoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lineImage.mas_centerY);
            make.right.equalTo(lineImage.mas_right).with.offset(-RESIZE_UI(27));
            make.width.height.mas_offset(RESIZE_UI(68));
        }];
        
        
    }
    return self;
}

- (void)jihuoMethod {
    
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"member_id"] = [SingletonManager sharedManager].uid;
    dict[@"redpacket_member_id"] = _remodel.redpacket_member_id;
    [manager postDataWithUrlActionStr:@"Redpacket/doCash" withParamDictionary:dict withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [SVProgressHUD dismiss];
            if (self.jihuoSuccess) {
                self.jihuoSuccess();
            }
        } else {
            NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            [SVProgressHUD dismiss];
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
            [alertView show];
        }
    }];
    
//    if (self.jihuoSuccess) {
//        self.jihuoSuccess();
//    }
//
}

@end
