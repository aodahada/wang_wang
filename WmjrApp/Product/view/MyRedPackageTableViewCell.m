//
//  MyRedPackageTableViewCell.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/8/22.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "MyRedPackageTableViewCell.h"
#import "RedPackageModel.h"

@interface MyRedPackageTableViewCell ()

@property (nonatomic, strong)UIImageView *imageViewForStatus;
@property (nonatomic, assign)BOOL isJiaXi;
@property (nonatomic, copy)NSString *returnrate_plus;

@end

@implementation MyRedPackageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithModel:(RedPackageModel *)model andIsOut:(BOOL)isOut{
    self = [super init];
    if (self) {
        self.backgroundColor = RGBA(243, 244, 246, 1.0);
        
        NSString *pic_name = @"image_hbbj";
        NSString *quan_content;
        if ([model.redpacket_type isEqualToString:@"2"]) {
            _isJiaXi = YES;
            _returnrate_plus = model.returnrate_plus;
            if ([model.returnrate_plus isEqualToString:@"0.005"]) {
                pic_name = @"jiaxi_blue";
//                quan_content = @"5‰";
            } else if ([model.returnrate_plus isEqualToString:@"0.01"]) {
                pic_name = @"jiaxi_ju";
//                quan_content = @"1%";
            } else if ([model.returnrate_plus isEqualToString:@"0.015"]) {
                pic_name = @"jiaxi_blue";
//                quan_content = @"1.5%";
            } else {
                pic_name = @"jiaxi_zi";
//                quan_content = @"2%";
            }
            double returnrate_plus = [model.returnrate_plus doubleValue];
            //转化成百分比
            double baifenFloat = returnrate_plus*100;
            if (baifenFloat<1) {
                CGFloat qianfenFloat = returnrate_plus*1000;
                quan_content = [NSString stringWithFormat:@"%g%‰",qianfenFloat];
            } else {
                quan_content = [NSString stringWithFormat:@"%g%%",baifenFloat];
            }
            
        } else {
            _isJiaXi = NO;
        }
        
        UIImageView *lineImage = [[UIImageView alloc]init];
        if (isOut) {
            lineImage.image = [UIImage imageNamed:@"image_hbbj"];
        } else {
            lineImage.image = [UIImage imageNamed:pic_name];
        }
        lineImage.userInteractionEnabled = YES;
        [self addSubview:lineImage];
        [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_offset(RESIZE_UI(130));
        }];
        
        UILabel *moneyLabel = [[UILabel alloc]init];
        if (_isJiaXi) {
            if (isOut) {
                moneyLabel.textColor = RGBA(197, 197, 197, 1.0);
            } else {
                moneyLabel.textColor = [UIColor whiteColor];
            }
            moneyLabel.text = quan_content;
        } else {
            if (isOut || [model.status isEqualToString:@"4"]) {
                moneyLabel.textColor = RGBA(197, 197, 197, 1.0);
            } else {
                moneyLabel.textColor = RGBA(255, 88, 26, 1.0);
            }
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
//        if (isOut || [model.status isEqualToString:@"4"]) {
//            moneyTitle.hidden = YES;
//        } else {
//            moneyTitle.hidden = NO;
//        }
        if (_isJiaXi) {
            if (isOut) {
                moneyTitle.textColor = RGBA(197, 197, 197, 1.0);
            }else {
                moneyTitle.textColor = [UIColor whiteColor];
            }
            moneyTitle.text = @"+";
        } else {
            if (isOut) {
                moneyTitle.textColor = RGBA(197, 197, 197, 1.0);
            } else {
                moneyTitle.textColor = RGBA(255, 88, 26, 1.0);
            }
            moneyTitle.text = @"¥";
        }
        moneyTitle.font = [UIFont systemFontOfSize:RESIZE_UI(18)];
        [self addSubview:moneyTitle];
        [moneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(moneyLabel.mas_centerY);
            make.right.equalTo(moneyLabel.mas_left);
        }];
        
        UILabel *moneySatisfy = [[UILabel alloc]init];
        moneySatisfy.text = [NSString stringWithFormat:@"单笔满%@可用",model.low_use];
        if (_isJiaXi) {
            if (isOut) {
                moneySatisfy.textColor = RGBA(153, 153, 153, 1.0);
            } else {
                moneySatisfy.textColor = [UIColor whiteColor];
            }
        } else {
            moneySatisfy.textColor = RGBA(153, 153, 153, 1.0);
        }
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
        
        if (_isJiaXi) {
            if (isOut) {
                newRedPackage.textColor = RGBA(197, 197, 197, 1.0);
            } else {
                newRedPackage.textColor = [UIColor whiteColor];
            }
        } else {
            if (isOut || [model.status isEqualToString:@"4"]) {
                newRedPackage.textColor = RGBA(197, 197, 197, 1.0);
            } else {
                newRedPackage.textColor = RGBA(255, 88, 26, 1.0);
            }
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
        if (_isJiaXi) {
            if (isOut) {
                suitableLabel.textColor = RGBA(153, 153, 153, 1.0);
            } else {
                suitableLabel.textColor = [UIColor whiteColor];
            }
        } else {
            suitableLabel.textColor = RGBA(153, 153, 153, 1.0);
        }
        suitableLabel.numberOfLines = 2;
        [self addSubview:suitableLabel];
        [suitableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(newRedPackage.mas_bottom).with.offset(RESIZE_UI(4));
            make.left.equalTo(newRedPackage.mas_left);
            make.width.mas_offset(RESIZE_UI(200));
        }];
        
        UILabel *useableDay = [[UILabel alloc]init];
        if (_isJiaXi) {
            if (isOut) {
                useableDay.textColor = RGBA(153, 153, 153, 1.0);
            } else {
                useableDay.textColor = [UIColor whiteColor];
            }
        } else{
            useableDay.textColor = RGBA(153, 153, 153, 1.0);
        }
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
