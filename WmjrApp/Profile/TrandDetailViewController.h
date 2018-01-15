//
//  TrandDetailViewController.h
//  wangmajinrong
//
//  Created by Baimifan on 16/1/28.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrandDetailViewController : UIViewController

@property (nonatomic, copy) NSString *nameStr;  /*  产品名字 */
@property (nonatomic, copy) NSString *earnToatl;  /* 总收益 */
@property (nonatomic, copy) NSString *totalNum;  /*  投资金额 */
@property (nonatomic, copy) NSString *earnNum;  /* 待收本息 */
@property (nonatomic, copy) NSString *earnP;  /*  预期年收益 */
@property (nonatomic, copy) NSString *duedate;  /*  结息日期 */
@property (nonatomic, copy) NSString *expirydate;  /*  还款日期 */
@property (nonatomic, copy) NSString *createtime;  /* 购买日期 */
@property (nonatomic, copy) NSString *redpacket;/* 红包收益，为0时不显示 */
@property (nonatomic, copy) NSString *returnrate_plus;
@property (nonatomic, copy) NSString *order_id;

@end
