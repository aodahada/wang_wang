//
//  RechargeViewController.h
//  wangmajinrong
//
//  Created by Baimifan on 15/11/19.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^accountChangeBlock)(CGFloat account);

@interface RechargeViewController : UIViewController

@property (nonatomic,copy)accountChangeBlock accountChangeBlock;

@end
