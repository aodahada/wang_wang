//
//  HomeTableViewCellThird.h
//  WmjrApp
//
//  Created by horry on 2016/10/31.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@protocol ClickBtnResponseDelegate <NSObject>

/* 点击购买 */
- (void)buttonClickProductModel:(ProductModel *)productModel;
@end

@interface HomeTableViewCellThird : UITableViewCell

//@property (nonatomic, strong) UILabel *billLable;//票据
//@property (nonatomic, strong) UIImageView *imageViewForNewer;//新人购图标
@property (nonatomic, strong) UILabel *earnOfYearLable;//收益描述
@property (nonatomic, strong) UILabel *earnOfPercent;//收益百分比

@property (nonatomic,strong) UILabel *labelForManageMoneyDay;//理财期限
@property (nonatomic, strong) UILabel *progressLable;  /* 进度 */
@property (nonatomic, assign) CGFloat buyNum;//购买率

@property (nonatomic, assign) id<ClickBtnResponseDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexpath;

- (void)configCellWithModel:(ProductModel *)model;

@end
