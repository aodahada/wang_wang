//
//  MyRedPackageTableViewCellTwo.h
//  WmjrApp
//
//  Created by 霍锐 on 2017/8/30.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RedPackageModel;
@interface MyRedPackageTableViewCellTwo : UITableViewCell

- (instancetype)initWithModel:(RedPackageModel *)model andIsOut:(BOOL)isOut andIsEnough:(BOOL)isEnough;

@end
