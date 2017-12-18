//
//  LotteryModel.h
//  WmjrApp
//
//  Created by 霍锐 on 2017/12/14.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LotteryModel : NSObject

@property (nonatomic, copy)NSString *icon;
@property (nonatomic, copy)NSString *lotteryId;
@property (nonatomic, copy)NSString *type;//1.现金红包 2.全国流量 3.尊享积分
@property (nonatomic, copy)NSString *value;

@end
