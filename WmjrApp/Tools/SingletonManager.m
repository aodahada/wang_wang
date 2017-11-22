//
//  SingletonClass.m
//  wangmajinrong
//
//  Created by Baimifan on 15/7/8.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "SingletonManager.h"

@implementation SingletonManager

+ (SingletonManager *)sharedManager {
    static SingletonManager *sharedSingletonInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSingletonInstance = [[self alloc] init];
    });
    return sharedSingletonInstance;
}

- (NSArray *)getStartDateAndEndDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *endDate = [NSDate date];
    NSString *endDateStr = [dateFormatter stringFromDate:endDate];
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:- 29 *24 *3600];
    NSString *startDateStr = [dateFormatter stringFromDate:startDate];
    
    return @[endDateStr, startDateStr];
}


//身份证号
- (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

/* 是否包含特殊字符 */
- (BOOL)isIncludeSpecialCharact:(NSString *)textStr {
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [textStr rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound) {
        return NO;
    } else {
        return YES;
    }
}

- (void)showHUDView:(id)theView title:(NSString *)theTitle content:(NSString *)theContent time:(NSTimeInterval)thTime andCodes:(void (^)())finish{
    UIView *aView        = (id)theView;
    MBProgressHUD*HUD    = [[MBProgressHUD alloc] initWithView:aView];
    [aView addSubview:HUD];
    HUD.labelText        = [NSString stringWithFormat:@"%@",theTitle];
    HUD.detailsLabelText = [NSString stringWithFormat:@"%@",theContent];
    HUD.mode             = MBProgressHUDModeText;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(thTime);
    } completionBlock:^{
        [HUD removeFromSuperview];
        if (finish) {
            finish();
        };
    }];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
//- (BOOL)isValidateMobile:(NSString *)mobile {
//    //手机号以13， 15，18开头，八个 \d 数字字符
//    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    return [phoneTest evaluateWithObject:mobile];
//}

//正则匹配用户密码6-18位数字和字母组合
- (BOOL)checkPassword:(NSString *)password {
    
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

//判断字符串是否都是数字
- (BOOL)isPureInt:(NSString *)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//转换日期字符串格式
- (NSString *)getDataStringWithString:(NSString *)str {
    NSString *dataStr = [NSString stringWithFormat:@"%@年%@月%@日",
                         [str substringWithRange:NSMakeRange(0, 4)],
                         [str substringWithRange:NSMakeRange(5, 2)],
                         [str substringWithRange:NSMakeRange(8, 2)]];
    return dataStr;
}

/*获得当前时间*/
- (NSString *)getCurrentDate {
    NSDate *newDate = [NSDate date];
    NSTimeInterval times = newDate.timeIntervalSince1970;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate *todayDate = [NSDate dateWithTimeIntervalSince1970:times];
    NSString *confirmStr = [formatter stringFromDate:todayDate];
    
    return confirmStr;
}

- (void)alert1PromptInfo:(NSString *)promptStr {
    MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
    alertConfig.defaultTextOK = @"确定";
    MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:promptStr];
    [alertView show];
}

//存储手势密码信息
- (void)saveHandGestureInfoDefault:(NSString *)gesPass{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:gesPass forKey:@"handGestureInfoDefault"];
    [defaults synchronize];
}


//获取手势密码信息
- (NSString *)getHandGestureInfoDefault{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *gesPass = [defaults objectForKey:@"handGestureInfoDefault"];
    if ([self isNullString:gesPass]) {
        return nil;
    } else {
        return gesPass;
    }
}

//删除以前保存的手势密码
- (void)removeHandGestureInfoDefault {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"handGestureInfoDefault"];
    [defaults synchronize];
    
}

- (BOOL)isSave
{
    NSString *str = [self getHandGestureInfoDefault];
    if (str && str.length>0 && [str isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    return NO;
}


- (BOOL)isFirstInput:(NSString *)str
{
    NSString *oldStr = [self getHandGestureInfoDefault];
    if (oldStr && oldStr.length>0 && [oldStr isKindOfClass:[NSString class]])
    {
        return NO;
    }
    
    [self saveHandGestureInfoDefault:str];
    
    return YES;
}



- (BOOL)isSecondInputRight:(NSString *)str
{
    NSString *oldStr = [self getHandGestureInfoDefault];
    
    if ([oldStr isKindOfClass:[NSNull class]]) {
        return NO;
    }
    else if (!oldStr || oldStr.length<1 || ![oldStr isKindOfClass:[NSString class]]) {
        return NO;
    }
    else if (oldStr.length==str.length  &&  [oldStr isEqualToString:str]) {
        return YES;
    }
    
    return NO;
}

- (BOOL) isNullString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (NSString *)convertNullString:(NSString*)oldString{
    if (oldString!=nil && (NSNull *)oldString != [NSNull null]) {
        if ([oldString length]!=0) {
            if ([oldString isEqualToString:@"(null)"]) {
                return @"";
            }
            return  oldString;
        }else{
            return @"";
        }
    }
    else{
        return @"";
    }
}

- (NSString *)getQianWeiFenGeFuString:(NSString *)stringValue {
    
    NSArray *hahaArray = [stringValue componentsSeparatedByString:@"."];
    NSString *stringResult;
    if (hahaArray.count == 2) {
        NSInteger balanceFlo = [hahaArray[0] integerValue];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSString *balance = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:balanceFlo]];
        stringResult = [NSString stringWithFormat:@"%@.%@",balance,hahaArray[1]];
    } else {
        NSInteger balanceFlo = [hahaArray[0] integerValue];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        stringResult = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:balanceFlo]];
    }
    return stringResult;
}

/**任意两天相差天数*/
+ (NSInteger)getTheCountOfTwoDaysWithBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate{
    
//    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
//    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
//    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
//    NSDate *startD =[inputFormatter dateFromString:beginDate];
//    NSDate *endD = [inputFormatter dateFromString:endDate];
    NSDate *startD = beginDate;
    NSDate *endD = endDate;
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:startD toDate:endD options:0];
    
    return dateCom.day;
}

@end
