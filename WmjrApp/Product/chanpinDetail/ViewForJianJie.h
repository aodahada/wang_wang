//
//  ViewForJianJie.h
//  WmjrApp
//
//  Created by horry on 16/9/7.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductModel;
@interface ViewForJianJie : UIView

- (instancetype)initWithProductModel:(ProductModel *)productModel;

@property (nonatomic, strong)void(^transHight)(CGFloat height);

@end
