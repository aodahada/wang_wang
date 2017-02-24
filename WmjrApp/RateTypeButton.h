//
//  RateTypeButton.h
//  WmjrApp
//
//  Created by horry on 2017/2/17.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LongProductSegment;
@interface RateTypeButton : UIButton

- (instancetype)initWithSementProduct:(LongProductSegment *)segmentPro;
@property (nonatomic, strong)LongProductSegment *segmentProduct;

@end
