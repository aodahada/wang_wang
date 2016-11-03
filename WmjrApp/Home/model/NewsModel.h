//
//  NewsModel.h
//  WmjrApp
//
//  Created by horry on 2016/10/31.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

@property(nonatomic, copy) NSString *news_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *intro;//简介
@property (nonatomic, copy) NSString *pic_url;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *url;

@end
