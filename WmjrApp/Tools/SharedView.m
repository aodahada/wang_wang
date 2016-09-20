//
//  SharedView.m
//  share(无菜单)
//
//  Created by Baimifan on 15/7/31.
//  Copyright (c) 2015年 mob.com. All rights reserved.
//

#import "SharedView.h"

@implementation SharedView

- (instancetype)initWithFrame:(CGRect)frame {
    self  = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = VIEWBACKCOLOR;
        [self initWithSharedBtn];
    }
    return self;
}

/*创建分享按钮*/
- (void)initWithSharedBtn {
    NSArray *imgArray = @[@"qq.png", @"weixin.png", @"xinlang.png", @"pengyouquan.png"];
    for (int i = 0; i < 4; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = RESIZE_FRAME(CGRectMake(35 + (35 + 50) * i, 10, 50, 50));
        [button setBackgroundImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
        button.tag = 500 + i;
        [self addSubview:button];
        [button addTarget:self action:@selector(clickSharedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)callSharedBtnEventBlock:(callSharedEvent)block {
    self.block = block;
}

/*点击分享按钮事件响应*/
- (void)clickSharedBtnAction:(UIButton *)sender  {
    NSLog(@"－－－点击了分享按妞－－－");
    self.block(sender);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
