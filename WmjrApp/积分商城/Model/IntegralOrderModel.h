//
//  IntegralOrderModel.h
//  WmjrApp
//
//  Created by 霍锐 on 2017/10/19.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IntegralAddressModel;
@class DeliverInfoObject;
@interface IntegralOrderModel : NSObject


@property (nonatomic, copy) NSString *created_at;
/**
 发货信息
 */
@property (nonatomic, strong) DeliverInfoObject *deliver_info;
@property (nonatomic, copy) NSString *goods_name;
/**
 订单号
 */
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *pic;
/**
 收货信息
 */
@property (nonatomic, strong) IntegralAddressModel *receive_info;
@property (nonatomic, copy) NSString *score;
/**
 0:兑换成功,待发货；1:已发货
 */
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *type_id;

@end
