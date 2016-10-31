//
//  HomeTableViewCellSecond.h
//  WmjrApp
//
//  Created by horry on 2016/10/31.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImgHomeModel;
@interface HomeTableViewCellSecond : UITableViewCell

- (instancetype)initWithImageArray:(NSMutableArray *)imageArray;

@property (nonatomic, copy)void (^cycleImage)(ImgHomeModel *imageModel);

@end
