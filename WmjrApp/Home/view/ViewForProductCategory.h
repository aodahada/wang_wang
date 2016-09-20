//
//  ViewForProductCategory.h
//  WmjrApp
//
//  Created by horry on 16/9/8.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeProductCatModel;
@interface ViewForProductCategory : UIView

@property (nonatomic, copy) void(^buttonClickMethod)(NSString *productId);

- (instancetype)initWithProductModel:(HomeProductCatModel *)productModel;

@end
