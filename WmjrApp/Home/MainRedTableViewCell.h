//
//  MainRedTableViewCell.h
//  WmjrApp
//
//  Created by 霍锐 on 2017/9/26.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RedPackageModel;
@interface MainRedTableViewCell : UITableViewCell

- (instancetype)initWithModel:(RedPackageModel *)model andIsOut:(BOOL)isOut;

@end
