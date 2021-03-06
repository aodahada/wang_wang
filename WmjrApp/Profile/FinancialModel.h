//
//  FinancialModel.h
//  wangmajinrong
//
//  Created by Baimifan on 15/12/25.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FinancialModel : NSObject

@property (nonatomic, copy) NSString *product_id;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *returnrate;
@property (nonatomic, copy) NSString *enddate;
@property (nonatomic, copy) NSString *day_income;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *duedate;
@property (nonatomic, copy) NSString *expirydate;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *redpacket;//"0为没用红包  其余为收益"
@property (nonatomic, copy) NSString *returnrate_plus;
@property (nonatomic, copy) NSString *redpacket_type;//2时为使用加息券
@property (nonatomic, copy) NSString *redpacket_returnrate_plus;
@property (nonatomic, copy) NSString *returnrate_money;
@property (nonatomic, copy) NSString *redpacket_money;//红包金额

@end
