//
//  HomeModel.h
//  wangmajinrong
//
//  Created by Baimifan on 15/7/16.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AdModel.h"
#import "ImgHomeModel.h"

@interface HomeModel : NSObject

//@property (nonatomic, copy) NSString *income;
//@property (nonatomic, copy) NSString *photourl;
@property (nonatomic, strong) NSMutableArray *topadArray;
@property (nonatomic, strong) NSMutableArray *adArray;

@end
