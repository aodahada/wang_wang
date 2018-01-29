//
//  CaiYouTableViewCell.h
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/28.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyReCommandModel;
@interface CaiYouTableViewCell : UITableViewCell

- (instancetype)initWithReCommandModel:(MyReCommandModel *)recommandModel withRow:(NSInteger)row;

@end
