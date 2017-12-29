//
//  ReleaseCardDirectlyView.h
//  WmjrApp
//
//  Created by 霍锐 on 2017/12/26.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReleaseCardDirectlyView : UIView

- (instancetype)initWithBankName:(NSString *)bankName withBankNumber:(NSString *)bankNumber;
@property (nonatomic, strong)void (^confirmRelease)();

@end
