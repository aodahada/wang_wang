//
//  AgViewController.h
//  WmjrApp
//
//  Created by Baimifan on 16/5/5.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgViewController : UIViewController

@property (nonatomic, copy) NSString *webUrl;

@property (nonatomic, copy) NSString *htmlContent;

@property (nonatomic, copy) NSString *isNotification;//是否为推送跳转来的

@property (nonatomic, assign)BOOL isWhite;

@end
