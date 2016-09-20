//
//  SepcialModel.m
//  wangmajinrong
//
//  Created by Baimifan on 15/7/10.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "SepcialModel.h"

@implementation SepcialModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.sep_id = value;
    }
}

@end
