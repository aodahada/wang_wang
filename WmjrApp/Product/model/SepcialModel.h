//
//  SepcialModel.h
//  wangmajinrong
//
//  Created by Baimifan on 15/7/10.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SepcialModel : NSObject

@property (nonatomic, copy) NSString *day;//天数
@property (nonatomic, copy) NSString *gold;//已投入的特权金
@property (nonatomic, copy) NSString *sep_id;  /* 产品id */
@property (nonatomic, copy) NSString *name; //  产品名称
@property (nonatomic, copy) NSString *returnrate;//回报率
@property (nonatomic, copy) NSString *totalincome;//累计收益
@property (nonatomic, copy) NSString *type_id;//
@property (nonatomic, copy) NSString *waitincome;//待受收益
@property (nonatomic, copy) NSString *lowpurchase;//单位起购金额
@property (nonatomic, copy) NSString *available;

@end
