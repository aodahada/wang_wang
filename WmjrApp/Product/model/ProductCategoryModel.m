//
//  ProductCategoryModel.m
//  WmjrApp
//
//  Created by horry on 16/9/7.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "ProductCategoryModel.h"
#import "ProductModel.h"
@implementation ProductCategoryModel

+ (NSDictionary *)objectClassInArray{
    return @{@"product" : [ProductModel class]};
}

@end
