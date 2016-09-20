//
//  RealNameCertificationViewController.h
//  wangmajinrong
//
//  Created by Baimifan on 15/11/18.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^showAlertBlock) ();

@interface RealNameCertificationViewController : UIViewController

@property (nonatomic, assign) BOOL isShowAlert;
@property (nonatomic, strong) showAlertBlock block;

@end
