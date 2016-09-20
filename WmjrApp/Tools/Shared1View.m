//
//  Shared1View.m
//  wangmajinrong
//
//  Created by Baimifan on 15/8/4.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "Shared1View.h"

@implementation Shared1View

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initWithSubViews];
    }
    return self;
}

- (void)initWithSubViews {
    NSArray *imgArray = @[@"qq.png", @"weixin.png", @"xinlang.png", @"pengyouquan.png"];
    for (int i = 0; i < 4; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = RESIZE_FRAME(CGRectMake(20 + (20 + 50) * i, 25, 50, 50));
        [button setBackgroundImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
        button.tag = 500 + i;
        [self addSubview:button];
        [button addTarget:self action:@selector(clickSharedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)callShared1BtnEventBlock:(callShared1Evevt)block {
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
