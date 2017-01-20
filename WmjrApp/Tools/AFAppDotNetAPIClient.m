//
//  AFAppDotNetAPIClient.m
//  quanqiju
//
//  Created by huorui on 16/8/8.
//  Copyright © 2016年 霍锐. All rights reserved.
//

#import "AFAppDotNetAPIClient.h"

@implementation AFAppDotNetAPIClient

+ (AFHTTPSessionManager *)sharedClient {
    
    static AFHTTPSessionManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[AFHTTPSessionManager alloc] init];
    });
    return shareInstance;
    
}

@end
