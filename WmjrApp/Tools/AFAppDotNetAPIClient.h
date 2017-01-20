//
//  AFAppDotNetAPIClient.h
//  quanqiju
//
//  Created by huorui on 16/8/8.
//  Copyright © 2016年 霍锐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFAppDotNetAPIClient : AFHTTPSessionManager

+ (AFHTTPSessionManager *)sharedClient;

@end
