//
//  DateSelectView.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/11/20.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "DateSelectView.h"

@interface DateSelectView()

@property (nonatomic, strong)UIDatePicker *dataPicker;
@property (nonatomic, copy)NSString *contentValue;
@property (nonatomic, strong)NSDate *selectDate;

@end

@implementation DateSelectView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.29];
        _contentValue = @"";
        _dataPicker = [[UIDatePicker alloc]init];
        _dataPicker.backgroundColor = [UIColor whiteColor];
        _dataPicker.datePickerMode = UIDatePickerModeDate; // 设置模式 这里是 年月日 没有上下午
        _dataPicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"]; // 设置地区 这里是
        //    self.timeField.inputView = _dateKB; // 用 UIDatePicker 替换 timeField 的键盘
        
        // 当值改变的时候会触发的方法  我们滑动日期键盘的时候  执行方法 rollAction:
        [_dataPicker addTarget:self action:@selector(rollAction:) forControlEvents:(UIControlEventValueChanged)];
        [self addSubview:_dataPicker];
        [_dataPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_offset(RESIZE_UI(230));
        }];
        
        UIView *topView = [[UIView alloc]init];
        topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_dataPicker.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.mas_offset(RESIZE_UI(50));
        }];
        
        UIButton *cancelButton = [[UIButton alloc]init];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
        [cancelButton setTitleColor:RGBA(94, 149, 206, 1.0) forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelMethod) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topView);
            make.left.equalTo(topView.mas_left).with.offset(RESIZE_UI(15));
            make.width.mas_offset(RESIZE_UI(80));
            make.height.mas_offset(RESIZE_UI(40));
        }];
        
        UIButton *confirmButton = [[UIButton alloc]init];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
        [confirmButton setTitleColor:RGBA(94, 149, 206, 1.0) forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmMethod) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:confirmButton];
        [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topView);
            make.right.equalTo(topView.mas_right).with.offset(-RESIZE_UI(15));
            make.width.mas_offset(RESIZE_UI(80));
            make.height.mas_offset(RESIZE_UI(40));
        }];
    }
    return self;
}

#pragma mark - 取消方法
- (void)cancelMethod {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelDatePickerView)]) {
        [self.delegate cancelDatePickerView];
    }
}

#pragma mark - 确定方法
- (void)confirmMethod {
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmDatePickerView: andDate:)]) {
        if ([_contentValue isEqualToString:@""]) {
            NSDate *date = [NSDate date];
            NSString *dateString = [NSString stringWithFormat:@"%@",date];
            _contentValue = [self dealStringMethod:dateString];
        }
        [self.delegate confirmDatePickerView:_contentValue andDate:_selectDate];
    }
}

- (void)rollAction:(UIDatePicker *)datePicker {
    _selectDate = datePicker.date;
    _contentValue = [NSString stringWithFormat:@"%@",datePicker.date];
    _contentValue = [self dealStringMethod:_contentValue];
}

#pragma mark - 处理字符串
- (NSString *)dealStringMethod:(NSString *)dateString {
    NSString *content = [dateString substringToIndex:10];
//    NSArray *contentArray = [content componentsSeparatedByString:@"-"];
//    NSString *value = [NSString stringWithFormat:@"%@年%@月%@日",contentArray[0],contentArray[1],contentArray[2]];
    return content;
}

@end
