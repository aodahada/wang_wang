//
//  UIView+BlockGesture.h
//  Meitu
//
//  Created by ssy on 16/1/17.
//  Copyright © 2016年 M2. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);

@interface UIView (BlockGesture)

/**
 *  给view添加点击手势
 *
 *  @param block 回调block
 */
- (void)addTapGestureWithBlock:(GestureActionBlock)tapBlock;

/**
 *  给view添加长按手势
 *
 *  @param block 回调block
 */
- (void)addLongPressWithBlock:(GestureActionBlock)longPressBlock;

@end
