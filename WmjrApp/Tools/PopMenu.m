//
//  PopMenu.m
//  SinaWeiBo
//
//  Created by 石少庸 on 15/5/19.
//  Copyright (c) 2015年 ssy. All rights reserved.
//

#import "PopMenu.h"
#import "UIView+Extension.h"

@interface PopMenu ()

@end

@implementation PopMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 添加遮盖按钮
        UIButton *cover = [[UIButton alloc] init];
        // 把背景色设置为透明色
        cover.backgroundColor = [UIColor clearColor];
        // 当被点击到的时候，让菜单收回去
        [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cover];
        self.cover = cover;
        
        // 添加菜单
        UIImageView *container = [[UIImageView alloc] init];
        container.userInteractionEnabled = YES;
//        container.image = [UIImage resizeImage:@"popover_background"];
        [self addSubview:container];
        self.container = container;
    }
    return self;
}

- (instancetype)initWithContentView:(UIView *)contentView
{
    if (self = [super init])
    {
        self.contentView = contentView;
    }
    return self;
}

+ (instancetype)popMenuWithContentView:(UIView *)contentView
{
    return [[self alloc] initWithContentView:contentView];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    // 是遮盖按钮为全屏
    self.cover.frame = self.bounds;
}
- (void)coverClick
{
    [self dismissMenu];
}

- (void)setDimBackground:(BOOL)dimBackground
{
    _dimBackground = dimBackground;
    if (dimBackground)
    {
        self.cover.backgroundColor = [UIColor blackColor];
        self.cover.alpha = 0.1;
    }
    else
    {
        self.cover.backgroundColor = [UIColor clearColor];
        self.cover.alpha = 1.0;
    }
}

- (void)setArrowPostion:(PopMenuArrowPosition)arrowPosition
{
    _arrowPosition = arrowPosition;
    switch (arrowPosition)
    {
        case PopMenuArrowPositionCenter:
//            self.container.image = [UIImage resizeImage:@"popover_background"];
            break;
            
        case PopMenuArrowPositionLeft:
//            self.container.image = [UIImage resizeImage:@"popover_background_left"];
            break;
            
        case PopMenuArrowPositionRight:
//            self.container.image = [UIImage resizeImage:@"popover_background_right"];
            break;
    }
}

- (void)setBackground:(UIImage *)background
{
    self.container.image = background;
}

- (void)showInRect:(CGRect)rect
{
    // 添加菜单到整个窗体上面
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (_coverNavigationBar == YES)
    {
        self.frame = window.frame;
    }
    else
    {
        self.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    }
    [window addSubview:self];
    
    // 设置容器的frame
    self.container.frame = rect;
    [self.container addSubview:self.contentView];
    
    // 设置容器内contentview的frame
    CGFloat topInterval = 0;
    CGFloat leftInterval = 0;
    CGFloat rightInterval = 0;
    CGFloat buttomInterval = 0;
    
    self.contentView.x = leftInterval;
    self.contentView.y = topInterval;
    self.contentView.width = self.container.width - leftInterval - rightInterval;
    self.contentView.height = self.container.height - topInterval - buttomInterval;
}

- (void)dismissMenu
{
    if ([self.delegate respondsToSelector:@selector(popMenuDidDismissed:)])
    {
        [self.delegate popMenuDidDismissed:self];
    }
    
    [self removeFromSuperview];
}


@end
