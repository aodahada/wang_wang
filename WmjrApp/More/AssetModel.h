//
//  AssetModel.h
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/28.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssetModel : NSObject

@property (nonatomic, copy) NSString *award;//累计奖励金额
@property (nonatomic, copy) NSString *invest;//累计投资收益
@property (nonatomic, copy) NSString *invite_count;//邀请财友人数
@property (nonatomic, copy) NSString *invite_money;//累计财友奖励
@property (nonatomic, copy) NSString *total;//总资产 余额除外

@end
