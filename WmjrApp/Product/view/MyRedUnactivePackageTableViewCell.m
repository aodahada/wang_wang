//
//  MyRedPackageTableViewCell.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/8/22.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "MyRedUnactivePackageTableViewCell.h"
#import "RedPackageModel.h"

@interface MyRedUnactivePackageTableViewCell ()

@property (nonatomic, strong)UIImageView *imageViewForStatus;

@end

@implementation MyRedUnactivePackageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithModel:(RedPackageModel *)model andIsOut:(BOOL)isOut{
    self = [super init];
    if (self) {
        self.backgroundColor = RGBA(243, 244, 246, 1.0);
        UIImageView *lineImage = [[UIImageView alloc]init];
        lineImage.image = [UIImage imageNamed:@"image_hbbj_wjh"];
        lineImage.userInteractionEnabled = YES;
        [self addSubview:lineImage];
        [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_offset(RESIZE_UI(162));
        }];
        
        UILabel *moneyLabel = [[UILabel alloc]init];
        if (isOut || [model.status isEqualToString:@"4"]) {
            moneyLabel.textColor = RGBA(197, 197, 197, 1.0);
//            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",model.money]
//                                                                                        attributes:@{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)}];
//            moneyLabel.attributedText = attrStr;
            moneyLabel.text = model.money;
            
        } else {
            moneyLabel.textColor = RGBA(255, 88, 26, 1.0);
            moneyLabel.text = model.money;
        }
        //        moneyLabel.font = [UIFont systemFontOfSize:RESIZE_UI(32)];
        moneyLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(32)];
        [self addSubview:moneyLabel];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-RESIZE_UI(15.8));
            make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(15));
        }];
        
        UILabel *moneyTitle = [[UILabel alloc]init];
        if (isOut || [model.status isEqualToString:@"4"]) {
            moneyTitle.hidden = YES;
        } else {
            moneyTitle.hidden = NO;
        }
        moneyTitle.textColor = RGBA(255, 88, 26, 1.0);
        moneyTitle.text = @"¥";
        moneyTitle.font = [UIFont systemFontOfSize:RESIZE_UI(18)];
        [self addSubview:moneyTitle];
        [moneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(moneyLabel.mas_centerY);
            make.right.equalTo(moneyLabel.mas_left);
        }];
        
        UILabel *moneySatisfy = [[UILabel alloc]init];
        moneySatisfy.text = [NSString stringWithFormat:@"单笔满%@可用",model.low_use];
        moneySatisfy.textColor = RGBA(153, 153, 153, 1.0);
        moneySatisfy.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        [self addSubview:moneySatisfy];
        [moneySatisfy mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(moneyTitle.mas_bottom).with.offset(5);
            make.right.equalTo(self.mas_right).with.offset(-RESIZE_UI(15));
        }];
        
        UILabel *newRedPackage = [[UILabel alloc]init];
        newRedPackage.text = model.name;
        //        newRedPackage.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
        newRedPackage.font = [UIFont fontWithName:@"Helvetica-Bold" size:RESIZE_UI(17)];
        if (isOut || [model.status isEqualToString:@"4"]) {
            newRedPackage.textColor = RGBA(197, 197, 197, 1.0);
        } else {
            newRedPackage.textColor = RGBA(255, 88, 26, 1.0);
        }
        [self addSubview:newRedPackage];
        [newRedPackage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(15));
            make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(15));
        }];
        
        UILabel *suitableLabel = [[UILabel alloc]init];
        NSArray *typeArray = model.productType;
        NSMutableArray *typeMutableArray = [[NSMutableArray alloc]init];
        for (int i=0; i<typeArray.count; i++) {
            NSDictionary *dic = typeArray[i];
            NSString *name = dic[@"name"];
            [typeMutableArray addObject:name];
        }
        NSString *typeString = [typeMutableArray componentsJoinedByString:@","];
        suitableLabel.text = [NSString stringWithFormat:@"适用产品:%@",typeString];
        suitableLabel.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        suitableLabel.numberOfLines = 2;
        suitableLabel.textColor = RGBA(153, 153, 153, 1.0);
        [self addSubview:suitableLabel];
        [suitableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(newRedPackage.mas_bottom).with.offset(RESIZE_UI(4));
            make.left.equalTo(newRedPackage.mas_left);
            make.width.mas_offset(RESIZE_UI(200));
        }];
        
        UILabel *useableDay = [[UILabel alloc]init];
        useableDay.textColor = RGBA(153, 153, 153, 1.0);
        model.start_date = [model.start_date stringByReplacingOccurrencesOfString:@"-"withString:@"/"];
        model.end_date = [model.end_date stringByReplacingOccurrencesOfString:@"-"withString:@"/"];
        useableDay.text = [NSString stringWithFormat:@"有效期:%@-%@",model.start_date,model.end_date];
        useableDay.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        [self addSubview:useableDay];
        [useableDay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(newRedPackage.mas_left);
            make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(103));
        }];
        
        NSString *status = model.status;
        //        NSLog(@"我的状态：%@",status);
        if (isOut) {
            _imageViewForStatus = [[UIImageView alloc]init];
            if ([status isEqualToString:@"1"]) {
                //已使用
                _imageViewForStatus.image = [UIImage imageNamed:@"icon_ysy"];
                [self addSubview:_imageViewForStatus];
                [_imageViewForStatus mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(71));
                    make.right.equalTo(self.mas_right).with.offset(-RESIZE_UI(15));
                    make.width.mas_offset(RESIZE_UI(61));
                    make.height.mas_offset(RESIZE_UI(53));
                }];
            }
            if ([status isEqualToString:@"2"]) {
                //已过期
                _imageViewForStatus.image = [UIImage imageNamed:@"icon_ygq"];
                [self addSubview:_imageViewForStatus];
                [_imageViewForStatus mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(71));
                    make.right.equalTo(self.mas_right).with.offset(-RESIZE_UI(15));
                    make.width.mas_offset(RESIZE_UI(61));
                    make.height.mas_offset(RESIZE_UI(53));
                }];
            }
            //            if ([status isEqualToString:@"4"]) {
            //                //未激活
            //                _imageViewForStatus = [[UIImageView alloc]init];
            //                _imageViewForStatus.image = [UIImage imageNamed:@"icon_wjh"];
            //                [self addSubview:_imageViewForStatus];
            //                [_imageViewForStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            //                    make.bottom.equalTo(self.mas_bottom).with.offset(-RESIZE_UI(15));
            //                    make.right.equalTo(self.mas_right).with.offset(-RESIZE_UI(15));
            //                    make.width.mas_offset(RESIZE_UI(61));
            //                    make.height.mas_offset(RESIZE_UI(53));
            //                }];
            //
            //            }
            
        } else {
            if ([status isEqualToString:@"3"]) {
                //未开始
                _imageViewForStatus = [[UIImageView alloc]init];
                _imageViewForStatus.image = [UIImage imageNamed:@"icon_wks"];
                [self addSubview:_imageViewForStatus];
                [_imageViewForStatus mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(71));
                    make.right.equalTo(self.mas_right).with.offset(-RESIZE_UI(15));
                    make.width.mas_offset(RESIZE_UI(61));
                    make.height.mas_offset(RESIZE_UI(53));
                }];
            } else if([status isEqualToString:@"4"]) {
                //未激活
                _imageViewForStatus = [[UIImageView alloc]init];
                _imageViewForStatus.image = [UIImage imageNamed:@"icon_wjh"];
                [self addSubview:_imageViewForStatus];
                [_imageViewForStatus mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(71));
                    make.right.equalTo(self.mas_right).with.offset(-RESIZE_UI(15));
                    make.width.mas_offset(RESIZE_UI(61));
                    make.height.mas_offset(RESIZE_UI(53));
                }];
                
                UILabel *tipLabel = [[UILabel alloc]init];
                tipLabel.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
                tipLabel.textColor = RGBA(255, 117, 65, 1.0);
                tipLabel.text = @"邀请红包需在邀请好友注册并首投后，即可激活使用";
                tipLabel.numberOfLines = 2;
                [self addSubview:tipLabel];
                [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(138));
                    make.left.equalTo(suitableLabel.mas_left);
                }];
                
            } else {
                if (_imageViewForStatus) {
                    [_imageViewForStatus removeFromSuperview];
                    _imageViewForStatus = nil;
                }
            }
        }
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

