//
//  AreaSelectView.m
//  HuaMuWang
//
//  Created by baimifan on 15/8/19.
//  Copyright (c) 2015年 lyl. All rights reserved.
//

#import "AreaSelectView.h"

@interface AreaSelectView ()

@end

@implementation AreaSelectView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _pickerArray = [[NSMutableArray alloc]init];
        _subPickerArray = [[NSMutableArray alloc]init];
        _thirdPickerArray = [[NSMutableArray alloc]init];
        
        //获取省市区数据
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSString *plistPath = [docDir stringByAppendingPathComponent:@"area.plist"];
        NSArray *array = [[NSArray alloc]initWithContentsOfFile:plistPath];
        self.arrayForAreaList = array;
        for (int i=0; i <[array count]; i++) {
            NSDictionary *dic = array[i];
            NSString *name = [dic objectForKey:@"name"];
            [self.pickerArray addObject:name];
        }
        
        NSDictionary *dicForSel = array[0];
        _selectArray = [dicForSel objectForKey:@"children"];
        
        if ([_selectArray count]>0) {
            for (int m=0; m<[_selectArray count]; m++) {
                NSDictionary *dicSelect = _selectArray[m];
                NSString *areaName = [dicSelect objectForKey:@"name"];
                [_subPickerArray addObject:areaName];
            }
        }
        NSDictionary *dicForThird = _selectArray[0];
        NSArray *arrayForThird = [dicForThird objectForKey:@"children"];
        if ([arrayForThird count]>0) {
            for (int h=0; h<[arrayForThird count]; h++) {
                NSDictionary *ha = arrayForThird[h];
                NSString *countryName = [ha objectForKey:@"name"];
                [_thirdPickerArray addObject:countryName];
            }
        }
        
        UIPickerView *pickView = [[UIPickerView alloc]init];
        pickView.frame = CGRectMake(0, SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250);
        pickView.backgroundColor = [UIColor whiteColor];
        pickView.dataSource = self;
        pickView.delegate = self;
        pickView.layer.cornerRadius = 5;
        pickView.clipsToBounds = YES;
        pickView.showsSelectionIndicator = YES;
        [self addSubview:pickView];
        
        UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 250, SCREEN_WIDTH, 35)];
        [toolBar setBackgroundColor:RGBA(44, 108, 170, 1.0)];
        [self addSubview:toolBar];
        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [selectBtn setTitle:@"确定" forState:UIControlStateNormal];
        [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        @weakify(self);
        [selectBtn clickActionBlock:^(UIButton *button) {
            @strongify(self);
            self.provinceStr = [SingletonManager convertNullString:self.provinceStr];
            self.cityStr = [SingletonManager convertNullString:self.cityStr];
            self.districtStr = [SingletonManager convertNullString:self.districtStr];
            if ([self.provinceStr isEqualToString:@""]) {
                NSDictionary *dic = self.arrayForAreaList[0];
                self.provinceStr = [dic objectForKey:@"name"];
            }
            if ([self.cityStr isEqualToString:@""]) {
                if (self.subPickerArray.count>0) {
                    self.cityStr = self.subPickerArray[0];
                }
            }
            if ([self.districtStr isEqualToString:@""]) {
                if (_thirdPickerArray.count>0) {
                    self.districtStr = _thirdPickerArray[0];
                }
            }
            self.block(_provinceStr,_cityStr,_districtStr);
            [self removeFromSuperview];
        }];
        selectBtn.frame = CGRectMake(SCREEN_WIDTH - 45 , 0, 45, 35);
        [toolBar addSubview:selectBtn];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn clickActionBlock:^(UIButton *button) {
            @strongify(self);
            [self removeFromSuperview];
        }];
        cancelBtn.frame = CGRectMake(0 , 0, 45, 35);
        [toolBar addSubview:cancelBtn];
    }
    
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - pickView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
#pragma mark - PickerView Delegate & DataSource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component==0) {
        return [self.pickerArray count];
    }
    if (component==1) {
        return [self.subPickerArray count];
    }
    if (component==2) {
        return [self.thirdPickerArray count];
    }
    return 0;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            return [self.pickerArray objectAtIndex:row];
        }
            break;
        case 1:
        {
            return [self.subPickerArray objectAtIndex:row];
        }
            break;
        case 2:
        {
            return [self.thirdPickerArray objectAtIndex:row];
        }
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if (component == 0) {
        return SCREEN_WIDTH/3-20;
    } else if (component == 1){
        return SCREEN_WIDTH/3;
    } else {
        return SCREEN_WIDTH/3+20;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component==0) {
        self.provinceStr = @"";
        self.cityStr = @"";
        self.districtStr = @"";
        NSDictionary *dic1 = self.arrayForAreaList[row];
        self.provinceStr = [dic1 objectForKey:@"name"];
        NSArray *array1 = [dic1 objectForKey:@"children"];
        _selectArray = array1;
        if ([array1 count]>0) {
            self.subPickerArray = [[NSMutableArray alloc]init];
            for (int i=0; i<[array1 count]; i++) {
                NSDictionary *dicForSub = array1[i];
                NSString *subName = [dicForSub objectForKey:@"name"];
                [self.subPickerArray addObject:subName];
            }
        }else{
            self.subPickerArray=nil;
        }
        NSDictionary *dic2 = array1[0];
        NSArray *array2 = [dic2 objectForKey:@"children"];
        if ([array2 count]>0) {
            self.thirdPickerArray = [[NSMutableArray alloc]init];
            for (int j=0; j<[array2 count]; j++) {
                NSDictionary *dicForThird = array2[j];
                NSString *thirdName = [dicForThird objectForKey:@"name"];
                [_thirdPickerArray addObject:thirdName];
            }
        }else{
            self.thirdPickerArray=nil;
        }
        [pickerView selectedRowInComponent:1];
        [pickerView reloadComponent:1];
        [pickerView selectedRowInComponent:2];
        
        
    }
    if (component==1) {
        self.cityStr = @"";
        self.districtStr = @"";
        _thirdPickerArray = [[NSMutableArray alloc]init];
        NSDictionary *dic = _selectArray[row];
        self.cityStr = [dic objectForKey:@"name"];
        NSArray *arrayForThir = [dic objectForKey:@"children"];
        if ([arrayForThir count]>0) {
            for (int m=0; m<[arrayForThir count]; m++) {
                NSDictionary *dicForThir = arrayForThir[m];
                NSString *thirName = [dicForThir objectForKey:@"name"];
                [_thirdPickerArray addObject:thirName];
            }
        }else{
            self.thirdPickerArray=nil;
        }
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }
    
    if (component == 2) {
        self.districtStr = @"";
        if (_thirdPickerArray.count >= 1) {
            self.districtStr = _thirdPickerArray[row];
        }
    }
    
    [pickerView reloadComponent:2];
}

- (void)pickViewButtonSelectWithSelect:(pickButtonselect)block{
    self.block = block;
}

@end
