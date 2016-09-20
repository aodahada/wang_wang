//
//  HomeModel.m
//  wangmajinrong
//
//  Created by Baimifan on 15/7/16.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"ad"]) {
        self.adArray = [NSMutableArray array];
        for (NSDictionary *adDic in value) {
            ImgHomeModel *model = [[ImgHomeModel alloc] init];
            [model setValuesForKeysWithDictionary:adDic];
            [self.adArray addObject:model];
        }
    }
    if ([key isEqualToString:@"topad"]) {
        self.topadArray = [NSMutableArray array];
        for (NSDictionary *adDic in value) {
            ImgHomeModel *model = [[ImgHomeModel alloc] init];
            [model setValuesForKeysWithDictionary:adDic];
            [self.topadArray addObject:model];
        }
    }
}

@end
