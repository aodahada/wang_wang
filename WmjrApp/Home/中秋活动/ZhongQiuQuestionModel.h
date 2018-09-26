//
//  ZhongQiuQuestionModel.h
//  WmjrApp
//
//  Created by 霍锐 on 2018/9/11.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhongQiuQuestionModel : NSObject

@property (nonatomic, assign)NSInteger number;
@property (nonatomic, copy)NSString *questuonContent;
@property (nonatomic, copy)NSString *answer_a;
@property (nonatomic, copy)NSString *answer_b;
@property (nonatomic, copy)NSString *answer_c;
@property (nonatomic, copy)NSString *answer_d;
@property (nonatomic, copy)NSString *right_answer;
@property (nonatomic, assign)BOOL isRight;
@property (nonatomic, copy)NSString *select_answer;

@end
