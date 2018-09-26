//
//  UIButton+Block.m
//  Meitu
//
//  Created by 石少庸 on 16/1/5.
//  Copyright © 2016年 M2. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>

static char *buttonCallBackBlockKey;

@implementation UIButton (Block)

- (void)clickActionBlock:(void (^)(UIButton *))clickCallBack {
    
    // 实现系统方法
    [self addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (clickCallBack) {
        // 替换系统方法
        objc_setAssociatedObject(self, &buttonCallBackBlockKey, clickCallBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (void)buttonClick:(UIButton *)sender {
    
    // 取出替换后的方法
    void(^buttonClickBlock)(UIButton *button) = objc_getAssociatedObject(sender, &buttonCallBackBlockKey);
    
    // 回调
    if (buttonClickBlock) {
        buttonClickBlock(sender);
    }
}

@end
