//
//  BuyPrivilViewController.h
//  wangmajinrong
//
//  Created by Baimifan on 15/6/29.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyPrivilViewController : UIViewController

@property (nonatomic, copy) NSString *sep_idStr;  /* 特权标的id */
@property (nonatomic, copy) NSString *sep_nameStr;  /* 特权标的名称 */
@property (nonatomic, copy) NSString *yearRate; /* 年利率 */
@property (nonatomic, copy) NSString *day; /* 天数 */
@property (nonatomic, copy) NSString *lowpurchase;//单位起购金额

@property (nonatomic, copy) NSString *availableStr; /* 可用特权金 */

@end
