//
//  NSData+Zlib.h
//  NetManager
//
//  Created by Baimifan on 15/7/6.
//  Copyright (c) 2015年 1 & 0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <zlib.h>
#import <UIKit/UIKit.h>

@interface NSData (Zlib)

//- (NSData *)zlibDecompressed;

- (NSData *)zlibDeflate;//压缩
- (NSData *)zlibInflate;//解压


@end
