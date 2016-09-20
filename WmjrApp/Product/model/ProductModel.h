//
//  ProductModel.h
//  wangmajinrong
//
//  Created by Baimifan on 15/7/10.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject

@property (nonatomic, copy) NSString *proIntro_id;//产品id
@property (nonatomic, copy) NSString *name;//产品名称
@property (nonatomic, copy) NSString *acceptance;//承兑方
@property (nonatomic, copy) NSString *introduction;//简介
@property (nonatomic, copy) NSString *returnrate;//预期年华受益
@property (nonatomic, assign) CGFloat returnrate_float;
@property (nonatomic, copy) NSString *day;//期限
@property (nonatomic, copy) NSString *lowpurchase;//起购金额
@property (nonatomic, copy) NSString *buyrate;//已购买率
@property (nonatomic, copy) NSString *risk;//风险
@property (nonatomic, copy) NSString *repay;//偿还方式
@property (nonatomic, copy) NSString *is_down;//是否可在购买
@property (nonatomic, copy) NSString *enddate;
@property (nonatomic, copy) NSString *type_id;//属于哪个种类1,2,3
@property (nonatomic, copy) NSString *pic;//图片
@property (nonatomic, copy) NSString *balance;//
@property (nonatomic, copy) NSString *purchasable;//融资金额
@property (nonatomic, copy) NSString *duedate; /* 到期日 */
@property (nonatomic, copy) NSString *expirydate;  /* 结息日 */
@property (nonatomic, copy) NSString *is_newer;//是否为新人购
@property (nonatomic, copy) NSString *heightpurchase;//购买区间
@property (nonatomic, copy) NSString *type_name;//
@property (nonatomic, copy) NSString *classify;//产品类型
@property (nonatomic, copy) NSString *detail_url;//产品说明webview链接

@end
