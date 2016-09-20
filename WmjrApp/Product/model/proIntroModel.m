//
//  proIntroModel.m
//  wangmajinrong
//
//  Created by Baimifan on 15/7/10.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "proIntroModel.h"

@implementation proIntroModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.proIntro_id = value;
    }
}

@end
