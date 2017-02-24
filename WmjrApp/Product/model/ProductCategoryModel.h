//
//  ProductCategoryModel.h
//  WmjrApp
//
//  Created by horry on 16/9/7.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductCategoryModel : NSObject

@property (nonatomic, copy) NSString *icon;//图片
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *product;

@end
