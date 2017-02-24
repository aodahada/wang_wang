//
//  ProductModel.m
//  wangmajinrong
//
//  Created by Baimifan on 15/7/10.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "ProductModel.h"
#import "LongProductSegment.h"

@implementation ProductModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.proIntro_id = value;
    }
}

+ (NSDictionary *)objectClassInArray{
    return @{@"segment" : [LongProductSegment class]};
}

@end
