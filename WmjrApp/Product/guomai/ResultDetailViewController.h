//
//  ResultDetailViewController.h
//  wangmajinrong
//
//  Created by Baimifan on 15/11/25.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultDetailViewController : UITableViewController

@property (nonatomic, copy) NSString *proname;
@property (nonatomic, copy) NSString *buyNum;
@property (nonatomic, copy) NSString *rateNum; /* 利息收益 */
@property (nonatomic, assign) BOOL isRefresh; /* 是否更新 */


@end
