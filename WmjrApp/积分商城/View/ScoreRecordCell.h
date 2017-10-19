//
//  ScoreRecordCell.h
//  WmjrApp
//
//  Created by 霍锐 on 2017/10/19.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScoreModel;
@interface ScoreRecordCell : UITableViewCell

- (instancetype)initWithScoreModel:(ScoreModel *)scoreModel;

@end
