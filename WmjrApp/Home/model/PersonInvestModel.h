//
//  PersonInvestModel.h
//  WmjrApp
//
//  Created by horry on 2016/11/1.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonInvestModel : NSObject

/**今日预期收益*/
@property (nonatomic, copy) NSString *today_income;
/**累计出借*/
@property (nonatomic, copy) NSString *total_invest;
/** 累计收益*/
@property (nonatomic, copy) NSString *total_income;

/**
 当前出借
 */
@property (nonatomic, copy) NSString *current_invest;

/**账户余额*/
@property (nonatomic, copy) NSString *account_rest;

@end
