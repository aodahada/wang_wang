//
//  SingletonClass.h
//  wangmajinrong
//
//  Created by Baimifan on 15/7/8.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@class UserInfoModel;
@interface SingletonManager : NSObject

@property (nonatomic, strong) UserInfoModel *userModel;
@property (nonatomic, copy) NSString *companyTel;//客服电话
@property (nonatomic, copy) NSString *uid;  /* 用户id */
//@property (nonatomic, assign) NSInteger sIndex;   /* 产品列表点击索引 */
@property (nonatomic, copy) NSString *bankPhone;
//@property (nonatomic, copy) NSString *accountStr;  /* 账户余额 */

@property (nonatomic, assign) NSInteger productListCount;/* 产品列表页标题个数 */

@property (nonatomic, assign) NSInteger isJumpGun;/* 产品列表页是否需要滚动 */

@property (nonatomic, assign) NSInteger whichOneTypeIsSelected;/* 那个类型被点击 */

@property (nonatomic, assign) NSInteger currentBGTopSliderNum;/* BGTopSlider那个动画是否要走 */

@property (nonatomic, assign) NSInteger isProductListViewWillAppear;/* productlist的viewwillappear是否走 */

+ (SingletonManager *)sharedManager;

- (BOOL)isIncludeSpecialCharact:(NSString *)textStr;//是否包含特殊字符串
//- (BOOL)isValidateMobile:(NSString *)mobile;//验证手机号码是否合法
- (BOOL)checkPassword:(NSString *)password;//正则匹配用户密码4-18位数字和字母组合
//- (void)makeMoveUpToInputBox:(UITextField *)textField;//使输入框上移
- (BOOL)isPureInt:(NSString *)string;//判断字符串是否都是数字
- (NSString *)getDataStringWithString:(NSString *)str;//转换日期字符串格式
- (NSString *)getCurrentDate; /*获得当前时间*/

- (void)alert1PromptInfo:(NSString *)promptStr;  /* 提示信息 */
- (BOOL)validateIdentityCard: (NSString *)identityCard;//身份证号

- (NSArray *)getStartDateAndEndDate; /* 限制查询开始时间和结束时间 */

- (void)saveHandGestureInfoDefault:(NSString *)gesPass;
- (NSString *)getHandGestureInfoDefault;
- (void)removeHandGestureInfoDefault;
- (BOOL)isSecondInputRight:(NSString *)str;
- (BOOL)isFirstInput:(NSString *)str;
- (BOOL)isSave;
- (void)showHUDView:(id)theView title:(NSString *)theTitle content:(NSString *)theContent time:(NSTimeInterval)thTime andCodes:(void (^)())finish;
- (BOOL) isNullString:(NSString *)string;
+ (NSString *)convertNullString:(NSString *)oldString;

/**为金额添加千位分隔符*/
- (NSString *)getQianWeiFenGeFuString:(NSString *)stringValue;

/**
 相差天数

 @param beginDate 开始日期
 @param endDate 结束日期
 @return 相差天数
 */
+ (NSInteger)getTheCountOfTwoDaysWithBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate;

/**
 判断字符串是否只有浮点数
 
 @param string 字符串
 @return bool
 */
+ (BOOL)isPureFloat:(NSString *)string;

/**
 判断字符串是否只有整数数
 
 @param string 字符串
 @return bool
 */
+ (BOOL)isPureInt:(NSString *)string;

@end
