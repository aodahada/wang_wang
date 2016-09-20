//
//  HomeViewController.h
//  wangmajinrong
//
//  Created by Baimifan on 15/6/17.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ToIndexBlock)(NSString *selectStr);

@interface HomeViewController : UIViewController

@property (nonatomic, copy) __block ToIndexBlock block;
- (void)sendToIndexFrom:(ToIndexBlock)block;

@end
