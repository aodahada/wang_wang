//
//  MyReadyMoneyRedBallTableViewCell.h
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/29.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RedPackageModel;
@interface MyReadyMoneyRedBallTableViewCell : UITableViewCell

- (instancetype)initWithRedPackageModel:(RedPackageModel *)redModel;
@property (nonatomic, strong)void(^jihuoSuccess)();

@end
