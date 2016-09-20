//
//  GoldModel.h
//  wangmajinrong
//
//  Created by Baimifan on 16/1/8.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoldModel : NSObject

//@property (nonatomic, copy) NSString *gold_id;
//@property (nonatomic, copy) NSString *money;
//@property (nonatomic, copy) NSString *enddate;
//@property (nonatomic, copy) NSString *remark;
//@property (nonatomic, copy) NSString *createtime;

@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *expiry_time;
@property (nonatomic, copy) NSString *gift_id;
@property (nonatomic, copy) NSString *member_id;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *money_pay;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *state;//-1：过期0：未使用 1：已使用，未到帐 2：已到帐

@end
