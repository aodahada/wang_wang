//
//  ActiveSuccessView.h
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/29.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActiveResponseDelegate<NSObject>

- (void)backToRoot;

@end

@interface ActiveSuccessView : UIView

@property (nonatomic, assign)id<ActiveResponseDelegate> delegate;

@end
