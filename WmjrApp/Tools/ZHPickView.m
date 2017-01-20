//
//  HLPickView.m
//  ActionSheet
//
//  Created by 赵子辉 on 15/10/22.
//  Copyright © 2015年 zhaozihui. All rights reserved.
//

#import "ZHPickView.h"
#define SCREENSIZE UIScreen.mainScreen.bounds.size

@interface ZHPickView ()

@property (nonatomic,copy) NSString *stateStr;
@property (nonatomic,copy) NSString *cityStr;

@end

@implementation ZHPickView
{
    UIView *bgView;
    NSArray *proTitleList;
    NSString *selectedStr;
    BOOL isDate;
}

@synthesize block;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]];
        _cityes = [[_provinces objectAtIndex:0] objectForKey:@"cities"];
        _stateStr = [[_provinces objectAtIndex:0] objectForKey:@"state"];
        _cityStr = [_cityes objectAtIndex:0];
    }
   
    return self;
}

- (void)showPickView:(UIViewController *)vc
{
    bgView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.2f;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    CGRect frame = self.frame ;
    self.frame = CGRectMake(0,SCREENSIZE.height + frame.size.height, SCREENSIZE.width, frame.size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.frame = frame;
                     }
                     completion:nil];
}

- (void)hide
{
    [bgView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)setAddressViewWithTitle:(NSString *)title
{
    isDate = YES;
    proTitleList = @[];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENSIZE.width, 39.5)];
    header.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, SCREENSIZE.width - 80, 39.5)];
    titleLbl.text = title;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = TITLE_COLOR;
    titleLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    [header addSubview:titleLbl];
    
    UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(SCREENSIZE.width - 50, 10, 50 ,29.5)];
    [submit setTitle:@"确定" forState:UIControlStateNormal];
    [submit setTitleColor:AUXILY_COLOR forState:UIControlStateNormal];
    submit.backgroundColor = [UIColor whiteColor];
    submit.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:submit];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 50 ,29.5)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:AUXILY_COLOR forState:UIControlStateNormal];
    cancel.backgroundColor = [UIColor whiteColor];
    cancel.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:cancel];
    
    [self addSubview:header];
    
    _pickView1 = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, SCREENSIZE.width, 220)];
    _pickView1.backgroundColor = [UIColor whiteColor];
    _pickView1.dataSource = self;
    _pickView1.delegate = self;
    _pickView1.layer.cornerRadius = 5;
    _pickView1.clipsToBounds = YES;
    _pickView1.showsSelectionIndicator = YES;
    [self addSubview:_pickView1];
    
    float height = 250;
    self.frame = CGRectMake(0, SCREENSIZE.height - height, SCREENSIZE.width, height);
}

- (void)setBankViewWithItem:(NSArray *)items title:(NSString *)title
{
    isDate = NO;
    proTitleList = items;
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENSIZE.width, 39.5)];
    header.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, SCREENSIZE.width - 80, 39.5)];
    titleLbl.text = title;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = TITLE_COLOR;
    titleLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    [header addSubview:titleLbl];
    
    UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(SCREENSIZE.width - 50, 10, 50 ,29.5)];
    [submit setTitle:@"确定" forState:UIControlStateNormal];
    [submit setTitleColor:AUXILY_COLOR forState:UIControlStateNormal];
    submit.backgroundColor = [UIColor whiteColor];
    submit.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
    [submit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:submit];
    
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 50 ,29.5)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:AUXILY_COLOR forState:UIControlStateNormal];
    cancel.backgroundColor = [UIColor whiteColor];
    cancel.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:cancel];

    [self addSubview:header];
    _pickView2 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, SCREENSIZE.width, 220)];
    _pickView2.delegate = self;
    _pickView2.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pickView2];
    
    float height =250;
    self.frame = CGRectMake(0, SCREENSIZE.height - height, SCREENSIZE.width, height);
}

- (void)cancel:(UIButton *)btn
{
    [self hide];
}

- (void)submit:(UIButton *)btn
{
    NSString *pickStr = selectedStr;
    if (!pickStr || pickStr.length == 0) {
        if(isDate) {
            selectedStr = [NSString stringWithFormat:@"%@-%@", [[_provinces objectAtIndex:0] objectForKey:@"state"], [_cityes objectAtIndex:0]];
        } else {
            if([proTitleList count] > 0) {
                selectedStr = proTitleList[0];
            }
        }
    }
    block(selectedStr);
    [self hide];
}

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (_pickView1 == pickerView) {
        return 2;
    } else {
        return 1;
    }
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_pickView1 == pickerView) {
        if (component == 0) {
            return [_provinces count];
        } else {
            return [_cityes count];
        }
    } else {
        return [proTitleList count];
    }
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return SCREEN_WIDTH/2;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_pickView1 == pickerView) {
        if (component == 0) {
            _cityes = [[_provinces objectAtIndex:row] objectForKey:@"cities"];
            [_pickView1 selectRow:0 inComponent:1 animated:YES];
            [_pickView1 reloadComponent:1];
            
            _stateStr = [[_provinces objectAtIndex:row] objectForKey:@"state"];
            _cityStr = [_cityes objectAtIndex:0];
        }
        if (component == 1) {
            _cityStr = [_cityes objectAtIndex:row];
        }
         selectedStr = [NSString stringWithFormat:@"%@-%@", _stateStr, _cityStr];
    } else {
        selectedStr = [proTitleList objectAtIndex:row];
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_pickView1 == pickerView) {
        if (component == 0) {
            return [[_provinces objectAtIndex:row] objectForKey:@"state"];
        } else {
            return [_cityes objectAtIndex:row];
        }
    } else {
        NSMutableArray *bankNameArray = [NSMutableArray array];
        for (NSString *bankStr in proTitleList) {
            NSArray *bankS = [bankStr componentsSeparatedByString:@"-"];
            [bankNameArray addObject:[bankS lastObject]];
        }
        return [bankNameArray objectAtIndex:row];
    }
}

- (UIColor *)getColor:(NSString*)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
    
}

- (CGSize)workOutSizeWithStr:(NSString *)str andFont:(NSInteger)fontSize value:(NSValue *)value{
    CGSize size;
    if (str) {
        NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil];
        size=[str boundingRectWithSize:[value CGSizeValue] options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    }
    return size;
}

@end

