//
//  PopMenu.h
//  SinaWeiBo
//
//  Created by 石少庸 on 15/5/19.
//  Copyright (c) 2015年 ssy. All rights reserved.
//


/*
 PopMenu:当点击某个按钮的时候，可以弹出菜单，菜单弹出的同时，除菜单意外的其他视图将会被遮盖，当再点击菜单以外，菜单收回
 */

#import <UIKit/UIKit.h>

//控制弹出菜单箭头的位置
typedef enum
{
    PopMenuArrowPositionCenter = 0,
    PopMenuArrowPositionLeft = 1,
    PopMenuArrowPositionRight = 2
}PopMenuArrowPosition;

@class PopMenu;
// 协议
@protocol PopMenuDelegate <NSObject>

@optional
// 菜单消失
- (void)popMenuDidDismissed:(PopMenu *)popMenu;

@end

@interface PopMenu : UIView

@property (nonatomic, weak) id<PopMenuDelegate> delegate;

@property (nonatomic, assign, getter = isDimBackground) BOOL dimBackground;

@property (nonatomic, assign) PopMenuArrowPosition arrowPosition;

// 要显示内容的View
@property (nonatomic, strong) UIView *contentView;
// 用于遮盖除contentView以外的其他东西
@property (nonatomic, weak) UIButton *cover;
// 容纳要显示的内容
@property (nonatomic, weak) UIImageView *container;
// 是否留出导航栏
@property (nonatomic, assign,getter = isCoverNavigationBar) BOOL coverNavigationBar;

//初始化方法
- (instancetype)initWithContentView:(UIView *)contentView;
+ (instancetype)popMenuWithContentView:(UIView *)contentView;

//设置菜单的背景图片
- (void)setBackground:(UIImage *)background;

//显示菜单
- (void)showInRect:(CGRect)rect;

//关闭菜单
- (void)dismissMenu;

@end
