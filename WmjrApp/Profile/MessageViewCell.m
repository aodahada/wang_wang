//
//  MessageViewCell.m
//  wangmajinrong
//
//  Created by Baimifan on 15/11/20.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "MessageViewCell.h"
#import "MessageModel.h"

@interface MessageViewCell ()

@property (strong, nonatomic) UILabel *cerLab; /* 认证类型 */
@property (strong, nonatomic) UILabel *introLab; /* 认证描述 */
@property (strong, nonatomic) UILabel *cerType;/* 类型 */
@property (strong, nonatomic) UILabel *timeLabel;/* 时间 */
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *jiantouImage;
@property (nonatomic, strong) UILabel *watchLabel;

@end

@implementation MessageViewCell

- (instancetype)initWithMessageModel:(MessageModel *)model {
    self = [super init];
    if (self) {
        _cerLab = [[UILabel alloc]init];
        _cerLab.textColor = FOURNAVBARCOLOR;
        _cerLab.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
        _cerLab.text = model.message_title;
        [self addSubview:_cerLab];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = RGBA(170, 170, 170, 1.0);
        _timeLabel.text = model.create_time;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
        [self addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_cerLab.mas_centerY);
            make.right.equalTo(self.mas_right).with.offset(-RESIZE_UI(12));
            make.width.mas_offset(RESIZE_UI(50));
        }];
        
        [_cerLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(RESIZE_UI(11));
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(12));
            make.right.equalTo(_timeLabel.mas_left);
            make.height.mas_equalTo(RESIZE_UI(22));
        }];
        
        _introLab = [[UILabel alloc]init];
        _introLab.textColor = RGBA(153, 153, 153, 1.0);
        _introLab.text = model.message_intro;
        _introLab.numberOfLines = 2;
        _introLab.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        [self addSubview:_introLab];
        [_introLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_cerLab.mas_bottom).with.offset(RESIZE_UI(7));
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(12));
            make.right.equalTo(self.mas_right).with.offset(-RESIZE_UI(12));
            make.height.mas_offset(RESIZE_UI(40));
        }];
        
        if ([model.can_click isEqualToString:@"1"]) {
            _lineLabel = [[UILabel alloc]init];
            _lineLabel.backgroundColor = RGBA(242, 242, 242, 1.0);
            [self addSubview:_lineLabel];
            [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_introLab.mas_bottom).with.offset(RESIZE_UI(7));
                make.left.equalTo(self.mas_left);
                make.right.equalTo(self.mas_right);
                make.height.mas_offset(1);
            }];
            
            _bottomView = [[UIView alloc]init];
            [self addSubview:_bottomView];
            [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_lineLabel.mas_bottom);
                make.left.equalTo(self.mas_left);
                make.right.equalTo(self.mas_right);
                make.bottom.equalTo(self.mas_bottom);
            }];
            
            _jiantouImage = [[UIImageView alloc]init];
            _jiantouImage.image = [UIImage imageNamed:@"icon_bluearrow"];
            [_bottomView addSubview:_jiantouImage];
            [_jiantouImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_bottomView.mas_centerY);
                make.right.equalTo(_bottomView.mas_right).with.offset(-RESIZE_UI(12.5));
                make.height.width.mas_offset(RESIZE_UI(12));
            }];
            
            _watchLabel = [[UILabel alloc]init];
            _watchLabel.text = @"展开详情";
            _watchLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
            _watchLabel.textColor = FOURNAVBARCOLOR;
            [_bottomView addSubview:_watchLabel];
            [_watchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_jiantouImage.mas_centerY);
                make.right.equalTo(_jiantouImage.mas_left).with.offset(-RESIZE_UI(7));
            }];

        } else {
            if (_lineLabel) {
                _lineLabel = nil;
                [_lineLabel removeFromSuperview];
                _bottomView = nil;
                [_bottomView removeFromSuperview];
                _jiantouImage = nil;
                [_jiantouImage removeFromSuperview];
                _watchLabel = nil;
                [_watchLabel removeFromSuperview];
            }
        }
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
//    _imgView.layer.cornerRadius = CGRectGetWidth(_imgView.frame) / 2;
//    _imgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
