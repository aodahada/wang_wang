//
//  MyselfTransCell.h
//  wangmajinrong
//
//  Created by Baimifan on 15/6/29.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeModel.h"

@interface MyselfTransCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *payBankLab;
@property (nonatomic, strong) UILabel *payMoney;
@property (nonatomic, strong) UILabel *payTime;
@property (nonatomic, strong) UILabel *paySuccess;

@property (nonatomic, strong) TradeModel *model;

@end
