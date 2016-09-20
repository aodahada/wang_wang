//
//  NSString+StringCode.h
//  NetManager
//
//  Created by Baimifan on 15/7/7.
//  Copyright (c) 2015年 1 & 0. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringCode)

+ (NSString*)encodeString:(NSString*)unencodedString;
+ (NSString *)decodeString:(NSString*)encodedString;

@end
