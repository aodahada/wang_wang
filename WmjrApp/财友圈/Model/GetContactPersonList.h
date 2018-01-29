//
//  GetContactPersonList.h
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/28.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetContactPersonList : NSObject

+ (GetContactPersonList *)sharedManager;

- (NSString *)getPeronListMethod;

@end
