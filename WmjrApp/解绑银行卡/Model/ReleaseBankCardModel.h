//
//  ReleaseBankCardModel.h
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/7.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReleaseBankCardModel : NSObject

@property (nonatomic, copy)NSString *audit;
@property (nonatomic, copy)NSString *bank_name;
@property (nonatomic, copy)NSString *card_no;
@property (nonatomic, strong)NSArray *cert_bg;
@property (nonatomic, strong)NSArray *cert_front;
@property (nonatomic, copy)NSString *cert_no;
@property (nonatomic, copy)NSString *created_at;
@property (nonatomic, copy)NSString *release_id;//解绑的id
@property (nonatomic, copy)NSString *member_id;
@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *status;//0审核中，1成功，2失败

@end
