//
//  RedPackageViewController.h
//  WmjrApp
//
//  Created by 霍锐 on 2017/8/22.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RedPackageModel;
@protocol RedPackageVCDelegate <NSObject>

@optional

- (void)selecNoRedPackage;
- (void)selectRedPackage:(RedPackageModel *)redPackageModel;

@end

@interface RedPackageViewController : UIViewController

@property (nonatomic, copy)NSString *productId;

@property (nonatomic, copy)NSString *buyMoney;//是否满足使用红包条件

@property (nonatomic, weak) id<RedPackageVCDelegate> delegate;

@end
