//
//  DatePickSelectView.m
//  WmjrApp
//
//  Created by horry on 2017/3/17.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "DatePickSelectView.h"

@interface DatePickSelectView ()

{
    UIDatePicker *datePicker;
}

@end

@implementation DatePickSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, RESIZE_UI(40))];
        [self addSubview:selectView];
        UIButton *leftButton = [[UIButton alloc]init];
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(cancelMethod) forControlEvents:UIControlEventTouchUpInside];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        [selectView addSubview:leftButton];
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(selectView.mas_centerY);
            make.left.equalTo(selectView.mas_left).with.offset(RESIZE_UI(15));
            make.width.mas_offset(RESIZE_UI(60));
            make.height.mas_offset(RESIZE_UI(40));
        }];
        
        UILabel *lineLabel = [[UILabel alloc]init];
        lineLabel.backgroundColor = RGBA(168, 168, 168, 1.0);
        [self addSubview:lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(selectView.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_offset(1);
        }];
        
        UIButton *rightButton = [[UIButton alloc]init];
        [rightButton setTitle:@"确定" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        [rightButton addTarget:self action:@selector(confirmMethod) forControlEvents:UIControlEventTouchUpInside];
        [selectView addSubview:rightButton];
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(selectView.mas_centerY);
            make.right.equalTo(selectView.mas_right).with.offset(-RESIZE_UI(15));
            make.width.mas_offset(RESIZE_UI(60));
            make.height.mas_offset(RESIZE_UI(40));
        }];
        
        datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, RESIZE_UI(40), SCREEN_WIDTH, RESIZE_UI(250))];
        datePicker.datePickerMode = UIDatePickerModeDate;
        NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
        datePicker.locale = locale;
//        NSTimeInterval oneYearTime = 365 * 24 * 60 * 60;
//        NSDate *todayDate = [NSDate date];
//        NSDate *oneYearFromToday = [todayDate dateByAddingTimeInterval:oneYearTime];
//        NSDate *twoYearsFromToday = [todayDate dateByAddingTimeInterval:2 * oneYearTime];
//        datePicker.minimumDate = oneYearFromToday;
//        datePicker.maximumDate = twoYearsFromToday;
        [self addSubview:datePicker];
    }
    return self;
}

- (void)cancelMethod {
    [UIView animateWithDuration:0.5 animations:^{
      self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, RESIZE_UI(290));
    }];
}
- (void)confirmMethod {
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, RESIZE_UI(290));
    }];
    NSDate *select = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:select];
    if ([_delegate respondsToSelector:@selector(confirmSelectDate:)]) {
        [_delegate confirmSelectDate:dateAndTime];
    }
}

@end
