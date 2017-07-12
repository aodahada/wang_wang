//
//  NSArray+HRUtil.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/7/12.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "NSArray+HRUtil.h"

@implementation NSArray (HRUtil)

- (id)objectAtIndexCheck:(NSUInteger)index
{
    if (index >= [self count]) {
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

@end
