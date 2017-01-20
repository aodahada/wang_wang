//
//  NewProductModel.m
//  WmjrApp
//
//  Created by horry on 2017/1/15.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "NewProductModel.h"
#import "SegmentModel.h"

@implementation NewProductModel

+(NSDictionary *)mj_objectClassInArray {
    
    return @{@"segment" : [SegmentModel class]};
    
}

@end
