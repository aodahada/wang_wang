//
//  UIAlertView+Block.h
//  Lawyer
//
//  Created by 石少庸 on 15/12/18.
//  Copyright © 2015年 lawyer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIAlertViewCallBackBlock)(NSInteger buttonIndex);

@interface UIAlertView (Block)

@property (nonatomic, copy) UIAlertViewCallBackBlock alertViewCallBackBlock;

/**
 *  @brief 使用block 回调
 *
 *  @param alertViewCallBackBlock block
 *  @param title                  标题
 *  @param message                消息
 *  @param cancelButtonName       取消
 *  @param otherButtonTitles      其他按钮
 */
+ (void)alertWithCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock title:(NSString *)title message:(NSString *)message  cancelButtonName:(NSString *)cancelButtonName otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

@end
