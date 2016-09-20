//
//  ResultShowView.m
//  wangmajinrong
//
//  Created by Baimifan on 15/11/30.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "ResultShowView.h"

@implementation ResultShowView


- (void)callBtnClickEventBlock:(callBtnClickEvent)block {
    self.block = block;
}

/* 取消 */
- (IBAction)cancelBtnAction:(id)sender {
    self.block(sender);
}

/* 确定 */
- (IBAction)comfirBtnAction:(id)sender {
    self.block(sender);
}

@end
