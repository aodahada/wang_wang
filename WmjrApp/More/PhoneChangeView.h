//
//  PhoneChangeView.h
//  wangmajinrong
//
//  Created by Baimifan on 15/7/13.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^callChoiceEvent)(UIButton *sender, NSString *text);

@interface PhoneChangeView : UIView

@property (strong, nonatomic) UITextField *nPhoneCard;  /* 新的手机号 */
@property (strong, nonatomic) UITextField *verfitionNum;  /* 验证码 */
@property (strong, nonatomic) UIButton *determinBtn;  /* 确定 */
@property (strong, nonatomic) UIButton *cancelBtn;  /* 取消 */
@property (strong, nonatomic) UIButton *getVerfitionBtn;  /* 获取验证码 */

@property (nonatomic, copy) __block callChoiceEvent block;
- (void)callBtnEventBlock:(callChoiceEvent)block;

@end
