//
//  RedPackageModel.h
//  WmjrApp
//
//  Created by 霍锐 on 2017/8/22.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedPackageModel : NSObject

@property (nonatomic, strong)NSString *end_date;
@property (nonatomic, strong)NSString *end_time;
@property (nonatomic, strong)NSString *low_use;
@property (nonatomic, strong)NSString *money;
@property (nonatomic, strong)NSString *product_name;//来源产品名称
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSArray *productType;
@property (nonatomic, strong)NSString *redpacket_id;
@property (nonatomic, strong)NSString *redpacket_member_id;
@property (nonatomic, strong)NSString *start_date;
@property (nonatomic, strong)NSString *status;//0：可使用 1：已使用 2：已过期 3：未开始 4：未激活
@property (nonatomic, strong)NSString *redpacket_type;// 1.出借红包  2.加息红包  3.现金红包
@property (nonatomic, strong)NSString *returnrate_plus;//加息券的值

@end
