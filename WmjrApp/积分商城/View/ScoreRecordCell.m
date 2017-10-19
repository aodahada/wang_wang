//
//  ScoreRecordCell.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/10/19.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "ScoreRecordCell.h"
#import "ScoreModel.h"

@implementation ScoreRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithScoreModel:(ScoreModel *)scoreModel {
    self = [super init];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = scoreModel.remarks;
        titleLabel.textColor = RGBA(42, 42, 42, 1.0);
        titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(22));
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(12));
        }];
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.text = scoreModel.create_time;
        timeLabel.textColor = RGBA(153, 153, 153, 1.0);
        timeLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        [self addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).with.offset(RESIZE_UI(-22));
            make.left.equalTo(titleLabel.mas_left);
        }];
        
        UILabel *scoreLabel = [[UILabel alloc]init];
        NSString *score = scoreModel.score;
        if ([score rangeOfString:@"-"].location !=NSNotFound) {
            scoreLabel.textColor = RGBA(0, 102, 177, 1.0);
            scoreLabel.text = score;
        } else {
            scoreLabel.textColor = RGBA(255, 86, 30, 1.0);
            scoreLabel.text = [NSString stringWithFormat:@"+%@",score];
        }
        scoreLabel.font = [UIFont systemFontOfSize:RESIZE_UI(20)];
        [self addSubview:scoreLabel];
        [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).with.offset(-RESIZE_UI(15));
        }];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
