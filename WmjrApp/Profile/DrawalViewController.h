//
//  DrawalViewController.h
//  wangmajinrong
//
//  Created by Baimifan on 15/11/20.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^accountChangeBlock1)(CGFloat account);

@interface DrawalViewController : UIViewController

@property (nonatomic, copy) NSString *accountStr;

@property (nonatomic, copy)accountChangeBlock1 accountChangeBlock1;

@end
