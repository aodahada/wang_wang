//
//  proIntroModel.h
//  wangmajinrong
//
//  Created by Baimifan on 15/7/10.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface proIntroModel : NSObject

@property (nonatomic, copy) NSString *acceptance;//承兑方
@property (nonatomic, copy) NSString *balance;//融资金额
@property (nonatomic, copy) NSString *day;//期限
@property (nonatomic, copy) NSString *enddate;//筹标结束日期
@property (nonatomic, copy) NSString *proIntro_id;//产品编号
@property (nonatomic, copy) NSString *lowpurchase;//单位起购金额
@property (nonatomic, copy) NSString *name;//产品名称
@property (nonatomic, copy) NSString *purchasable;//
@property (nonatomic, copy) NSString *repay;//偿还方式
@property (nonatomic, copy) NSString *returnrate;//历史年化收益
@property (nonatomic, copy) NSString *risk;//风险
@property (nonatomic, copy) NSString *is_down;
@property (nonatomic, copy) NSString *duedate; /* 到期日 */
@property (nonatomic, copy) NSString *expirydate;  /* 结息日 */
@property (nonatomic, copy) NSString *pic;

@end
