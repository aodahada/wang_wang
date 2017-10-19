//
//  DeliverInfoObject.h
//  WmjrApp
//
//  Created by 霍锐 on 2017/10/19.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliverInfoObject : NSObject

/**
 快递公司
 */
@property (nonatomic, copy) NSString *express;

/**
 运单号
 */
@property (nonatomic, copy) NSString *waybill_no;

/**
 备注
 */
@property (nonatomic, copy) NSString *remarks;

@end
