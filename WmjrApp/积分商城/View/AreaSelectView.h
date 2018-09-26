//
//  AreaSelectView.h
//  HuaMuWang
//
//  Created by baimifan on 15/8/19.
//  Copyright (c) 2015年 lyl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^pickButtonselect)(NSString *province,NSString *city,NSString *district);

@interface AreaSelectView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,retain)NSMutableArray* pickerArray;
@property(nonatomic,retain)NSMutableArray* subPickerArray;
@property(nonatomic,retain)NSMutableArray* thirdPickerArray;
@property(nonatomic,retain)NSArray* selectArray;
@property(nonatomic,retain)NSArray *arrayForAreaList;

@property (nonatomic, copy) NSString *provinceStr;//省
@property (nonatomic, copy) NSString *cityStr;//市
@property (nonatomic, copy) NSString *districtStr;//区
@property (nonatomic, copy) NSString *locateStr;

@property (copy, nonatomic)__block pickButtonselect block;


- (instancetype)initWithFrame:(CGRect)frame;

- (void)pickViewButtonSelectWithSelect:(pickButtonselect)block;

@end
