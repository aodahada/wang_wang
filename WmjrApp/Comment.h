//
//  Comment.h
//  wangmajinrong
//
//  Created by 1 & 0 on 15/6/20.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#ifndef wangmajinrong_Comment_h
#define wangmajinrong_Comment_h

#define STATUS_HEIGHT [[UIApplication sharedApplication] statusBarFrame]
#define NAVIGATIONBAR_HEIGHT self.navigationController.navigationBar.frame
#define BOTH_HEIGHT (CGRectGetHeight(STATUS_HEIGHT) + CGRectGetHeight(NAVIGATIONBAR_HEIGHT))
#define TABBAR_HEIGHT CGRectGetHeight(self.tabBarController.tabBar.frame)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define VIEW_WIDTH self.view.bounds.size.width
#define VIEW_HEIGHT self.view.bounds.size.height

#define RESIZE_UI(float) ((float)/375.0f * SCREEN_WIDTH)
#define RESIZE_FRAME(frame) CGRectMake(RESIZE_UI (frame.origin.x), RESIZE_UI (frame.origin.y), RESIZE_UI (frame.size.width), RESIZE_UI (frame.size.height))
#define BASECOLOR [UIColor colorWithRed:0.90f green:0.19f blue:0.09f alpha:1.00f]
//#define VIEWBACKCOLOR [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f] //视图背景色

#define VIEWBACKCOLOR [UIColor whiteColor] //视图背景色
#define TITLE_COLOR [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f] //标题字体色值
#define AUXILY_COLOR [UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f] //辅助字体色值
#define ORANGE_COLOR [UIColor colorWithRed:1.00f green:0.66f blue:0.06f alpha:1.00f] //黄色字体

#define PI 3.14159265358979323846

//内网
#define WMJRAPI @"http://test.wmjr888.com/api/"
//外网
//#define WMJRAPI @"http://api.wmjr888.com/api/"
//#define WMJRAPI @"https://api.wmjr888.com/api/"

#define GESTURESTOLOCKNOTIFITION @"GESTURESTOLOCKNOTIFITION"  //手势锁

#define PUSHMYPRIVILEGESTANDARDNOTIFICATION @"PUSHMYPRIVILEGESTANDARDNOTIFICATION"//跳转我的特权金

#define PUSHREALNAMEAUTHVCNOTIFICATION @"PUSHREALNAMEAUTHVCNOTIFICATION"  //实名认证
#define PUSHTOFUNDBUYVCNOTIFICATION @"PUSHTOFUNDBUYVCNOTIFICATION"//跳转产品买入
#define PUSHPRODUCTINTROVCNOTIFICATION @"PUSHPRODUCTINTROVCNOTIFICATION"//跳转产品详情

#define ALERTVIEW_SHOW(msg) [[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show]

#define GETHOMEVIEWDATANOTIFICATION @"GETHOMEVIEWDATANOTIFICATION" //主页面
#define GETPRODUCTINTRODATANOTIFICATION @"GETPRODUCTINTRODATANOTIFICATION" //产品详情页面通知
#define GETSEPCIALVCDATANOTIFICATION @"GETSEPCIALVCDATANOTIFICATION" //特别旺马通知
#define MAKEMOVETHEKEYBOARDNOTIFITION @"MAKEMOVETHEKEYBOARDNOTIFITION"//键盘上移
#define MAKEKEYBOARDDOWNNOTIFITION @"MAKEKEYBOARDDOWNNOTIFITION"//键盘下移

#define UMENG_APPKEY @"55a503da67e58ef242001a8d"

typedef enum {
    ModelPackageTypeRefresh,//刷新数据
    ModelPackageTypeLoadingMore//加载更多
}ModelPackageType;

#define PRESENTLOGINVCNOTIFICATION @"PRESENTLOGINVCNOTIFICATION"  //登录页面模态出现
#define PUSHBUYPRIVILVCNOTIFICATION @"PUSHBUYPRIVILVCNOTIFICATION"  //跳转购买特权标


// 弱引用
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

// 强引用
#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#pragma mark - 产品专用

#define GERENCOLOR [UIColor colorWithRed:245.0/255.0 green:89.0/255.0 blue:21.0/255.0 alpha:1.0]

#endif
