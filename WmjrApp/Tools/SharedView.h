//
//  SharedView.h
//  share(无菜单)
//
//  Created by Baimifan on 15/7/31.
//  Copyright (c) 2015年 mob.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^callSharedEvent) (UIButton *btn);

@interface SharedView : UIView

@property (nonatomic, copy) __block callSharedEvent block;
- (void)callSharedBtnEventBlock:(callSharedEvent)block;

@end
