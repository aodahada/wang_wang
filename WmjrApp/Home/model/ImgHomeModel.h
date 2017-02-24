//
//  ImgHomeModel.h
//  wangmajinrong
//
//  Created by Baimifan on 15/12/2.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductModel.h"

@interface ImgHomeModel : NSObject

@property (nonatomic, copy) NSString *picurl;  /* 图片 */
@property (nonatomic, copy) NSString *product_id;  /* 产品id */
@property (nonatomic, copy) NSString *title;  /* 标题 */
@property (nonatomic, copy) NSString *url;//超链接
@property (nonatomic, copy) NSString *islong;//是否是长期产品
@property (nonatomic, strong) ProductModel *product;

@end
