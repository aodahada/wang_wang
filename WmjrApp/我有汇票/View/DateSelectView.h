//
//  DateSelectView.h
//  WmjrApp
//
//  Created by 霍锐 on 2017/11/20.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateSelectViewDelegate<NSObject>

- (void)cancelDatePickerView;

- (void)confirmDatePickerView:(NSString *)content;

@end

@interface DateSelectView : UIView

@property (nonatomic, assign)id<DateSelectViewDelegate> delegate;

@end
