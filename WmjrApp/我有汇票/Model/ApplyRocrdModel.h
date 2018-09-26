//
//  ApplyRocrdModel.h
//  WmjrApp
//
//  Created by 霍锐 on 2017/11/22.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyRocrdModel : NSObject


@property (nonatomic, copy)NSString *acceptor;
@property (nonatomic, copy)NSString *audit;//审核反馈
@property (nonatomic, copy)NSString *bill_type;
@property (nonatomic, copy)NSString *borrow_carrer;
@property (nonatomic, copy)NSString *borrow_day;
@property (nonatomic, copy)NSString *borrow_guarantee;
@property (nonatomic, copy)NSString *borrow_income;
@property (nonatomic, copy)NSString *borrow_money;
@property (nonatomic, copy)NSString *borrow_name;
@property (nonatomic, copy)NSString *borrow_phone;
@property (nonatomic, copy)NSString *borrow_use;
@property (nonatomic, copy)NSString *created_at;
@property (nonatomic, copy)NSString *end_time;
@property (nonatomic, copy)NSString *enterprise_name;
@property (nonatomic, copy)NSString *id;
@property (nonatomic, strong)NSArray *img_bg;
@property (nonatomic, strong)NSArray *img_front;
@property (nonatomic, strong)NSArray *img_enterprise;
@property (nonatomic, copy)NSString *member_id;
@property (nonatomic, copy)NSString *member_type;
@property (nonatomic, copy)NSString *money;
@property (nonatomic, copy)NSString *returnrate;
@property (nonatomic, copy)NSString *status;

@end
