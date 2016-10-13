//
//  InvestConfirmView.h
//  WmjrApp
//
//  Created by horry on 2016/10/13.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvestConfirmView : UIView

- (instancetype)initWithInvestMoney:(NSString *)investMoney restMoney:(NSString *)restMoney;

@property (nonatomic, copy)void(^closeViewMethod)();
@property (nonatomic, copy)void(^jumToReadDelegate)();
@property (nonatomic, copy)void(^buttonNextMethod)(BOOL pay);

@end
