//
//  AvatorSettingCell.h
//  wangmajinrong
//
//  Created by Baimifan on 15/7/16.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"

@class AvatorSettingCell;
@protocol AvatorSettingDelegate <NSObject>

- (void)clickAvatorBtnWithCell:(AvatorSettingCell *)cell withIndexPath:(NSIndexPath *)indexPath;

@end

@interface AvatorSettingCell : UITableViewCell

@property (nonatomic, strong) UIButton *avatorBtn;
@property (nonatomic, strong) UILabel *nameLable;

@property (nonatomic, assign) id<AvatorSettingDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configCellWithModel:(UserInfoModel *)model;

@end
