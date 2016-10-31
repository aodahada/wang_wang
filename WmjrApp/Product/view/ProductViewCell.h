//
//  ProductViewCell.h
//  wangmajinrong
//
//  Created by 1 & 0 on 15/6/23.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

//@class ProductViewCell;
@protocol ClickBtnResponseDelegate <NSObject>

/* 点击购买 */
- (void)buttonClickProductModel:(ProductModel *)productModel;

@end

@interface ProductViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *billLable;//票据
@property (nonatomic, strong) UIImageView *imageViewForNewer;//新人购图标
@property (nonatomic, strong) UILabel *earnOfYearLable;//收益描述
@property (nonatomic, strong) UILabel *earnOfPercent;//收益百分比

@property (nonatomic, strong) UIButton *buyBtn;//立即购买
@property (nonatomic, strong) UILabel *progressLable;  /* 进度 */
@property (nonatomic, assign) CGFloat buyNum;//购买率

@property (nonatomic, assign) id<ClickBtnResponseDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexpath;

- (void)configCellWithModel:(ProductModel *)model;

@end
