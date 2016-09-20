//
//  ProgressView.h
//  利得行
//
//  Created by huorui on 15/12/8.
//  Copyright © 2015年 杭州稳瞻信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView
//中心颜色
@property (strong, nonatomic)UIColor *centerColor;
//圆环背景色
@property (strong, nonatomic)UIColor *arcBackColor;
//圆环色
@property (strong, nonatomic)UIColor *arcFinishColor;
@property (strong, nonatomic)UIColor *arcUnfinishColor;


//百分比数值（0-1）
@property (assign, nonatomic)float percent;

//圆环宽度
@property (assign, nonatomic)float width;
@end
