//
//  AvatorChangeView.m
//  wangmajinrong
//
//  Created by Baimifan on 15/7/13.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "AvatorChangeView.h"

@implementation AvatorChangeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithSubViews];
    }
    return self;
}

- (void)initWithSubViews {
    UILabel *aLable = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(0, 0, 305, 50))];
    aLable.backgroundColor = TITLE_COLOR;
    aLable.text = @"修改头像";
    aLable.textAlignment = NSTextAlignmentCenter;
    aLable.textColor = VIEWBACKCOLOR;
    aLable.font = [UIFont systemFontOfSize:RESIZE_UI(20.0f)];
    [self addSubview:aLable];
    
    _takePicture = [UIButton buttonWithType:UIButtonTypeCustom];
    _takePicture.frame = RESIZE_FRAME(CGRectMake(0, 50, 305, 50));
    _takePicture.backgroundColor = VIEWBACKCOLOR;
    _takePicture.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(20.0f)];
    [_takePicture setTitle:@"拍照" forState:UIControlStateNormal];
    [_takePicture setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [_takePicture addTarget:self action:@selector(clickChangeAvatorAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_takePicture];
    
    UILabel *bLable = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(3, 100, 299, 1))];
    bLable.backgroundColor = AUXILY_COLOR;
    bLable.alpha = .4;
    [self addSubview:bLable];
    
    _selectAlbum = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectAlbum.frame = RESIZE_FRAME(CGRectMake(0, 101, 305, 50));
    _selectAlbum.backgroundColor = VIEWBACKCOLOR;
    _selectAlbum.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(20.0f)];
    [_selectAlbum setTitle:@"从相册中选取" forState:UIControlStateNormal];
    [_selectAlbum setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [_selectAlbum addTarget:self action:@selector(clickChangeAvatorAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectAlbum];
}

- (void)callBtnEventBlock:(callBtnEvent)block {
    self.block = block;
}

- (void)clickChangeAvatorAction:(UIButton *)sender {
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
