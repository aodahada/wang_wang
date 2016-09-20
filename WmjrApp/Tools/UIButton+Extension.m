//
//  UIButton+Extension.m
//  Lawyer
//
//  Created by 石少庸 on 15/11/17.
//  Copyright © 2015年 lawyer. All rights reserved.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>

static char *buttonCallBackBlockKey;

@implementation UIButton (Extension)

- (void)clickBlock:(void (^)(UIButton *))clickCallBack {

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
