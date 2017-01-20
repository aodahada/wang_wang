//
//  ModifyPhoneView.h
//  WmjrApp
//
//  Created by horry on 2016/12/8.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModifyPhoneViewDelegate <NSObject>

@required

- (void)changeUserPhoneSuccessMethod:(NSString *)userNewPhone;

@end

@interface ModifyPhoneView : UIView

@property (nonatomic, weak) id<ModifyPhoneViewDelegate> modifyPhoneDelegate;

@end
