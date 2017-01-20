//
//  SegmentModel.h
//  WmjrApp
//
//  Created by horry on 2017/1/15.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SegmentModel : NSObject

@property (nonatomic, copy)NSString *can_buy;
@property (nonatomic, copy)NSString *duration;
@property (nonatomic, copy)NSString *returnrate;
@property (nonatomic, copy)NSString *segment_id;
@property (nonatomic, copy)NSString *segment_time;
@property (nonatomic, assign)BOOL isSelect;


@end
