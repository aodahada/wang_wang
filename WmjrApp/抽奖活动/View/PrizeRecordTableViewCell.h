//
//  PrizeRecordTableViewCell.h
//  WmjrApp
//
//  Created by 霍锐 on 2017/12/14.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PrizeRecordModel;
@interface PrizeRecordTableViewCell : UITableViewCell

- (instancetype)initWithPrizeRecordModel:(PrizeRecordModel *)prizeRecordModel;

@property (nonatomic, strong)void(^exchangePrize)(NSString *prize_id);

@end
