//
//  MainRedBallView.h
//  WmjrApp
//
//  Created by 霍锐 on 2017/9/26.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainRedBallView : UIView

- (instancetype)initWithRow:(NSMutableArray *)redBallArray;
@property (nonatomic, strong) void(^jumpToMyRed)();

@end
