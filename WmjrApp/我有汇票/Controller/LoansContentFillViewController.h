//
//  LoansContentFillViewController.h
//  WmjrApp
//
//  Created by 霍锐 on 2017/11/20.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoansContentFillViewController : UIViewController

@property (nonatomic, assign)NSInteger identifier;//1.个人 2.企业
@property (nonatomic, assign)NSInteger typeTag;//票据类型 1.银票 2.商票
@property (nonatomic, copy)NSString *piaojuMoney;//票据金额
@property (nonatomic, copy)NSString *respectRate;//期望利率
@property (nonatomic, copy)NSString *piaojuDate;//票据到期日
@property (nonatomic, copy)NSString *chengduiObject;//承兑银行/人
@property (nonatomic, strong)NSArray *piaoMianImage;//票面图片
@property (nonatomic, strong)NSArray *beishuImage;//背书图片
@property (nonatomic, strong)NSDate *selectDate;//选择的日期数据

@end
