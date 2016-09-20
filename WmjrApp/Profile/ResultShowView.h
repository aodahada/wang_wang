//
//  ResultShowView.h
//  wangmajinrong
//
//  Created by Baimifan on 15/11/30.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^callBtnClickEvent)(UIButton *sender);

@interface ResultShowView : UIView

@property (nonatomic, copy) __block callBtnClickEvent block;
- (void)callBtnClickEventBlock:(callBtnClickEvent)block;

@property (weak, nonatomic) IBOutlet UILabel *resultLab;  /* 结果详情 */
@property (weak, nonatomic) IBOutlet UIButton *canceBtnl;
- (IBAction)cancelBtnAction:(id)sender;  /*  取消 */
@property (weak, nonatomic) IBOutlet UIButton *comfirBtn;
- (IBAction)comfirBtnAction:(id)sender;  /* 确定 */


@end
