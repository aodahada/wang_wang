//
//  ApplyRecordTableViewCell.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/11/21.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "ApplyRecordTableViewCell.h"
#import "ApplyRocrdModel.h"

@implementation ApplyRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithApplyRecordModel:(ApplyRocrdModel *)applyRecordModel {
    self = [super init];
    if (self) {
        
        //顶部
        UIView *topView = [[UIView alloc]init];
        topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_offset(RESIZE_UI(60));
        }];
        
        UILabel *numberLabel = [[UILabel alloc]init];
        numberLabel.text = applyRecordModel.id;
        numberLabel.textColor = RGBA(102, 102, 102, 1.0);
        numberLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        [topView addSubview:numberLabel];
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topView.mas_centerY);
            make.left.equalTo(topView.mas_left).with.offset(RESIZE_UI(15));
        }];
        
        NSString *status;
        if ([applyRecordModel.status isEqualToString:@"0"]) {
            status = @"审核中";
        } else if ([applyRecordModel.status isEqualToString:@"1"]) {
            status = @"审核通过";
        } else {
            status = @"审核驳回";
        }
        
        UILabel *statusLabel = [[UILabel alloc]init];
        statusLabel.text = status;
        statusLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        statusLabel.textColor = RGBA(255, 88, 26, 1.0);
        [topView addSubview:statusLabel];
        [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(topView.mas_centerY);
            make.right.equalTo(topView.mas_right).with.offset(-RESIZE_UI(15));
        }];
        
        UILabel *line1 = [[UILabel alloc]init];
        line1.backgroundColor = RGBA(237, 240, 242, 1.0);
        [self addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom);
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(15));
            make.right.equalTo(self.mas_right).with.offset(-RESIZE_UI(15));
            make.height.mas_offset(RESIZE_UI(2));
        }];
        
        //左边
        UIView *leftView = [[UIView alloc]init];
        leftView.backgroundColor = [UIColor whiteColor];
        [self addSubview:leftView];
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line1.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.height.mas_offset(RESIZE_UI(95));
            make.width.mas_offset(SCREEN_WIDTH/3-1);
        }];
        
        UILabel *applyDateTitle = [[UILabel alloc]init];
        applyDateTitle.text = @"申请日期";
        applyDateTitle.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        applyDateTitle.textColor = RGBA(102, 102, 102, 1.0);
        [leftView addSubview:applyDateTitle];
        [applyDateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(leftView.mas_centerX);
            make.top.equalTo(leftView.mas_top).with.offset(RESIZE_UI(20));
        }];
        
        UILabel *applyDateContent = [[UILabel alloc]init];
        applyDateContent.text = applyRecordModel.created_at;
        applyDateContent.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        applyDateContent.textColor = RGBA(20, 20, 23, 1.0);
        [leftView addSubview:applyDateContent];
        [applyDateContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(leftView.mas_centerX);
            make.top.equalTo(applyDateTitle.mas_bottom).with.offset(RESIZE_UI(10));
        }];
        
        UILabel *line2 = [[UILabel alloc]init];
        line2.backgroundColor = RGBA(237, 240, 242, 1.0);
        [self addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leftView.mas_centerY);
            make.height.mas_offset(RESIZE_UI(54));
            make.width.mas_offset(2);
            make.left.equalTo(leftView.mas_right);
        }];
        
        //中间
        UIView *centerView = [[UIView alloc]init];
        centerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:centerView];
        [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line1.mas_bottom);
            make.left.equalTo(line2.mas_right);
            make.height.mas_equalTo(leftView.mas_height);
            make.width.mas_equalTo(SCREEN_WIDTH/3-2);
        }];
        
        UILabel *loansMoneyTitle = [[UILabel alloc]init];
        loansMoneyTitle.text = @"借款金额(元)";
        loansMoneyTitle.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        loansMoneyTitle.textColor = RGBA(102, 102, 102, 1.0);
        [centerView addSubview:loansMoneyTitle];
        [loansMoneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(centerView.mas_centerX);
            make.top.equalTo(centerView.mas_top).with.offset(RESIZE_UI(20));
        }];
        
        UILabel *loansMoneyContent = [[UILabel alloc]init];
        loansMoneyContent.text = applyRecordModel.borrow_money;
        loansMoneyContent.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        loansMoneyContent.textColor = RGBA(20, 20, 23, 1.0);
        [centerView addSubview:loansMoneyContent];
        [loansMoneyContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(centerView.mas_centerX);
            make.top.equalTo(loansMoneyTitle.mas_bottom).with.offset(RESIZE_UI(10));
        }];
        
        UILabel *line3 = [[UILabel alloc]init];
        line3.backgroundColor = RGBA(237, 240, 242, 1.0);
        [self addSubview:line3];
        [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leftView.mas_centerY);
            make.height.mas_offset(RESIZE_UI(54));
            make.width.mas_offset(2);
            make.left.equalTo(centerView.mas_right);
        }];
        
        //右边
        UIView *rightView = [[UIView alloc]init];
        rightView.backgroundColor = [UIColor whiteColor];
        [self addSubview:rightView];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line1.mas_bottom);
            make.left.equalTo(line3.mas_right);
            make.height.mas_equalTo(leftView.mas_height);
            make.width.mas_equalTo(SCREEN_WIDTH/3-1);
        }];
        
        UILabel *loansDurationTitle = [[UILabel alloc]init];
        loansDurationTitle.text = @"借款期限";
        loansDurationTitle.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        loansDurationTitle.textColor = RGBA(102, 102, 102, 1.0);
        [rightView addSubview:loansDurationTitle];
        [loansDurationTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(rightView.mas_centerX);
            make.top.equalTo(rightView.mas_top).with.offset(RESIZE_UI(20));
        }];
        
        UILabel *loansDurationContent = [[UILabel alloc]init];
        loansDurationContent.text = [NSString stringWithFormat:@"%@天",applyRecordModel.borrow_day];
        loansDurationContent.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        loansDurationContent.textColor = RGBA(20, 20, 23, 1.0);
        [rightView addSubview:loansDurationContent];
        [loansDurationContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(rightView.mas_centerX);
            make.top.equalTo(loansDurationTitle.mas_bottom).with.offset(RESIZE_UI(10));
        }];
        
        UILabel *line4 = [[UILabel alloc]init];
        line4.backgroundColor = RGBA(237, 240, 242, 1.0);
        [self addSubview:line4];
        [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(leftView.mas_bottom);
            make.left.equalTo(self.mas_left).with.offset(RESIZE_UI(15));
            make.right.equalTo(self.mas_right).with.offset(-RESIZE_UI(15));
            make.height.mas_equalTo(RESIZE_UI(2));
        }];
        
        //底部
        UIView *bottomView = [[UIView alloc]init];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line4.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_offset(RESIZE_UI(44));
        }];
        
        UILabel *tipLabel = [[UILabel alloc]init];
        tipLabel.textColor = RGBA(153, 153, 153, 1.0);
        tipLabel.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        if ([[SingletonManager convertNullString:applyRecordModel.borrow_use] isEqualToString:@""]) {
            tipLabel.text = @"借款说明:未填写";
        } else {
            tipLabel.text = [NSString stringWithFormat:@"借款说明:%@",applyRecordModel.borrow_use];
        }
        [bottomView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bottomView.mas_centerY);
            make.left.equalTo(bottomView.mas_left).with.offset(RESIZE_UI(15));
            make.right.equalTo(bottomView.mas_right).with.offset(-RESIZE_UI(15));
        }];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
