//
//  MyselfManageFinanceCell.h
//  wangmajinrong
//
//  Created by Baimifan on 15/6/29.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinancialModel.h"

@interface MyselfManageFinanceCell : UITableViewCell

@property (nonatomic, strong) UILabel *ydayEarn;//昨日收益
@property (nonatomic, strong) FinancialModel *model;

@end
