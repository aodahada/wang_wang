//
//  MyRedPackageTableViewCell.h
//  WmjrApp
//
//  Created by 霍锐 on 2017/8/22.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RedPackageModel;
@interface MyRedPackageTableViewCell : UITableViewCell

- (instancetype)initWithModel:(RedPackageModel *)model andIsOut:(BOOL)isOut;

@end