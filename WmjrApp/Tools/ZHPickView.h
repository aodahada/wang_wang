//
//  HLPickView.h
//  ActionSheet
//
//  Created by 赵子辉 on 15/10/22.
//  Copyright © 2015年 zhaozihui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHPickView;
typedef void (^HLPickViewSubmit)(NSString*);

@interface ZHPickView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickView1;
@property (nonatomic, strong) UIPickerView *pickView2;
@property (nonatomic, copy) NSArray *provinces;
@property (nonatomic, copy) NSArray *cityes;

- (void)setAddressViewWithTitle:(NSString *)title;
- (void)setBankViewWithItem:(NSArray *)items title:(NSString *)title;
- (void)showPickView:(UIViewController *)vc;
@property(nonatomic,copy)HLPickViewSubmit block;

@end
