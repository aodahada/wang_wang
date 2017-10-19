//
//  ScoreModel.h
//  WmjrApp
//
//  Created by 霍锐 on 2017/10/19.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreModel : NSObject

@property (nonatomic, copy)NSString *create_time;
@property (nonatomic, copy)NSString *member_id;
@property (nonatomic, copy)NSString *remarks;//标题
@property (nonatomic, copy)NSString *score;//积分
@property (nonatomic, copy)NSString *score_id;

@end
