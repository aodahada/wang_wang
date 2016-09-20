//
//  NetManager.h
//  NetManager
//
//  Created by 1 & 0 on 15/7/5.
//  Copyright (c) 2015年 1 & 0. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetManager : NSObject

- (NSString *)getCurrentTimestamp;//获取当前的时间戳
- (NSString *)paramCodeStr:(NSDictionary *)paramDic;//加密
- (id)paramUnCodeStr:(NSString *)encodeStrl;//解密

- (void)postDataWithUrlActionStr:(NSString *)actionStr withParamDictionary:(NSDictionary *)paramsDic withBlock:(void(^)(id obj))block;

@end
