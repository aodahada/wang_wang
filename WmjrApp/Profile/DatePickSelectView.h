//
//  DatePickSelectView.h
//  WmjrApp
//
//  Created by horry on 2017/3/17.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickSelectViewDelete <NSObject>

@optional
- (void)confirmSelectDate:(NSString *)date;

@end

@interface DatePickSelectView : UIView

@property (nonatomic, strong) id<DatePickSelectViewDelete> delegate;

@end
