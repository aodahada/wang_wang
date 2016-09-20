//
//  ViewForScrollClass.h
//  quanqiju
//
//  Created by huorui on 16/6/20.
//  Copyright © 2016年 霍锐. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeProductCatModel;
@interface ViewForScrollClass : UIView

@property (nonatomic, strong)void (^jumToMessPage)(HomeProductCatModel *moduleModel);
- (instancetype)initWithArray:(NSMutableArray *)moduleArray;

@end
