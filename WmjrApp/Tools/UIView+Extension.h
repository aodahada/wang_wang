//
//  UIView+Extension.h
//  PokectDog
//
//  Created by Baimifan on 15/6/23.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//
//

#import <UIKit/UIKit.h>

/**
 *  所有继承自uiview的都可以使用
 */

@interface UIView (Extension)

/** x坐标*/
@property (nonatomic, assign) CGFloat x;
/** y坐标*/
@property (nonatomic, assign) CGFloat y;
/** 中心点x坐标*/
@property (nonatomic, assign) CGFloat centerX;
/** 中心点y坐标*/
@property (nonatomic, assign) CGFloat centerY;
/** 宽度*/
@property (nonatomic, assign) CGFloat width;
/** 高度*/
@property (nonatomic, assign) CGFloat height;
/** 尺寸*/
@property (nonatomic, assign) CGSize size;
/** 圆角*/
@property (assign, nonatomic) CGFloat radius;

@end
