//
//  Shared1View.h
//  wangmajinrong
//
//  Created by Baimifan on 15/8/4.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^callShared1Evevt) (UIButton *btn);
@interface Shared1View : UIView

@property (nonatomic, copy) __block callShared1Evevt block;
- (void)callShared1BtnEventBlock:(callShared1Evevt)block;

@end
