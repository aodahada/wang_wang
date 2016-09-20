//
//  PopView.m
//  wangmajinrong
//
//  Created by Baimifan on 15/7/8.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "PopView.h"

@implementation PopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpPopView];
    }
    return self;
}

- (void)setUpPopView {
    
    self.backgroundColor = [UIColor whiteColor];

    self.introLable1 = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(15, 30, 275, 15))];
    self.introLable1.backgroundColor = [UIColor whiteColor];
    self.introLable1.textColor = AUXILY_COLOR;
    self.introLable1.font = [UIFont systemFontOfSize:RESIZE_UI(13.0f)];
    [self addSubview:self.introLable1];
    self.introLable2 = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(15, 55, 275, 15))];
    self.introLable2.backgroundColor = [UIColor whiteColor];
    self.introLable2.textColor = AUXILY_COLOR;
    self.introLable2.font = [UIFont systemFontOfSize:RESIZE_UI(13.0f)];
    [self addSubview:self.introLable2];

    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
