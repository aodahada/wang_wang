//
//  UserInfoModel.m
//  wangmajinrong
//
//  Created by Baimifan on 15/7/10.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.user_id = value;
    }
    if ([key isEqualToString:@"typename"]) {
        self.typeName = value;
    }
}

@end
