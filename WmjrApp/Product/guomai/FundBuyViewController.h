//
//  FundBuyViewController.h
//  wangmajinrong
//
//  Created by 1 & 0 on 15/6/24.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FundBuyViewController : UIViewController

@property (nonatomic, copy) NSString *buyMoneyNum; /* 购买特权金时输入的投资金额 */
@property (nonatomic, copy) NSString *product_idStr;  /* 产品id */
@property (nonatomic, copy) NSString *product_name; /* 产品名称 */
@property (nonatomic, copy) NSString *yearRate; /* 年利率 */
@property (nonatomic, copy) NSString *day; /* 天数 */
@property (nonatomic, copy) NSString *lowpurchase; /*最小起购金额 */
@property (nonatomic, copy) NSString *startTime; /* 计息日 */
@property (nonatomic, copy) NSString *endTime; /* 结息日 */

@end
