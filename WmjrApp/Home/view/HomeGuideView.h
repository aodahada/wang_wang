//
//  HomeGuideView.h
//  WmjrApp
//
//  Created by horry on 2016/11/15.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeGuideView : UIView

- (instancetype)initWithFrame:(CGRect)frame andNewsListCount:(NSInteger)newsListCount;
@property (nonatomic, strong)void(^forthLearnMethod)();
@property (nonatomic, strong)void(^destroySelfMethod)();

@end
