//
//  ViewForShuoMing.h
//  WmjrApp
//
//  Created by horry on 16/9/7.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductModel;
@interface ViewForShuoMing : UIView

- (instancetype)initWithProductModel:(ProductModel *)productModel;
@property (nonatomic, copy) void(^watchPic)(NSString *picStr);
@property (nonatomic, copy) void(^watchContract)();

@end
