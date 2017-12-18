//
//  PrizeRecordModel.h
//  WmjrApp
//
//  Created by 霍锐 on 2017/12/14.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrizeRecordModel : NSObject

@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *prizeRecordId;
@property (nonatomic, copy) NSString *state;//1：可兑换2：已兑换
@property (nonatomic, copy) NSString *type;//1.现金红包 2.全国流量 3.尊享积分
@property (nonatomic, copy) NSString *value;

@end
