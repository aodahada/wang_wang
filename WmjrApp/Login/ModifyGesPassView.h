//
//  ModifyGesPassView.h
//  WmjrApp
//
//  Created by horry on 16/9/5.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyGesPassView : UIView

@property (nonatomic, copy)void(^cancelModifyView)();

@property (nonatomic, copy)void(^canThroughPass)();//密码验证成功

@end
