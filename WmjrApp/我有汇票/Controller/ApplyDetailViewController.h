//
//  ApplyDetailViewController.h
//  WmjrApp
//
//  Created by 霍锐 on 2017/11/21.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplyRocrdModel.h"

@interface ApplyDetailViewController : UIViewController

@property (nonatomic, assign)NSInteger identifier;//1.个人 2.企业

@property (nonatomic, strong)ApplyRocrdModel *applyRecordModel;

@end
