//
//  ViewForNewYearProDetail.h
//  WmjrApp
//
//  Created by horry on 2017/1/20.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductModel;
@interface ViewForNewYearProDetail : UIView

- (instancetype)initWithProductModel:(ProductModel *)productModel;
@property (nonatomic, copy) void(^watchPic)(NSString *picStr);
@property (nonatomic, copy) void(^watchContract)();

@end
