//
//  HomeTableViewCellFirst.h
//  WmjrApp
//
//  Created by horry on 2016/10/31.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonInvestModel;
@interface HomeTableViewCellFirst : UITableViewCell

- (instancetype)initWithDic:(PersonInvestModel *)personModel;

@property (nonatomic, strong)void(^contactWangma)();
@property (nonatomic, strong)void(^learnWangma)();
@property (nonatomic, strong)void(^jumpToMessageCenter)();

@end
