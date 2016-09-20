//
//  ComfirmFastPayView.h
//  wangmajinrong
//
//  Created by Baimifan on 15/11/25.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^callBtnClickEvent)(UIButton *sender);

@interface ComfirmFastPayView : UIView

@property (nonatomic, copy) __block callBtnClickEvent block;
- (void)callBtnClickEventBlock:(callBtnClickEvent)block;

@property (weak, nonatomic) IBOutlet UILabel *promptLab;   /* 提示 */
@property (weak, nonatomic) IBOutlet UILabel *phoneTailLab; /* 手机号尾四位 */
@property (weak, nonatomic) IBOutlet UITextField *vercerNumField; /*验证码 */

@property (weak, nonatomic) IBOutlet UIButton *getVerCerBtn;
- (IBAction)getVerCerBtnAction:(id)sender; /* 获取验证码 */

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *comfirBtn;
- (IBAction)comfirBtnAction:(id)sender;  /* 确定 */
- (IBAction)cancelBtnAction:(id)sender;   /* 取消 */

@end
