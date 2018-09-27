//
//  GuoqingShowModel.h
//  WmjrApp
//
//  Created by 霍锐 on 2018/9/27.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GuoqingShowModel : NSObject

@property (nonatomic, copy)NSString *current_time;
@property (nonatomic, copy)NSString *next_time;
@property (nonatomic, copy)NSNumber *pool_amount;//奖金池余额
@property (nonatomic, strong)NSNumber *request_count_contain_this;//显示次数
@property (nonatomic, strong)NSArray *lists;

@end

NS_ASSUME_NONNULL_END
