//
//  RegeisterModel.m
//  wangmajinrong
//
//  Created by Baimifan on 15/7/8.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "RegisterModel.h"

@implementation RegisterModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.uid = value;
    }
    if ([key isEqualToString:@"typename"]) {
        self.typeName = value;
    }
}

@end
