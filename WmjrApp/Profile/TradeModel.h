//
//  TradeModel.h
//  wangmajinrong
//
//  Created by Baimifan on 15/12/25.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeModel : NSObject

@property (nonatomic, copy) NSString *order_id;  /*  */
@property (nonatomic, copy) NSString *money;  /*  */
@property (nonatomic, copy) NSString *state;  /*  */
@property (nonatomic, copy) NSString *time;  /*  */

@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *type;

@end
