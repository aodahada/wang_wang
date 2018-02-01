//
//  SortCaiYouTableViewCell.h
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/28.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortContaceModel.h"

@interface SortCaiYouTableViewCell : UITableViewCell

- (instancetype)initWithType:(NSInteger)type withRow:(NSInteger)row WithModel:(SortContaceModel *)sortModel;

@end
