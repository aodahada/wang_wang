//
//  MessageViewCell.h
//  wangmajinrong
//
//  Created by Baimifan on 15/11/20.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UIImageView *imgView; /* 认证图片 */
@property (weak, nonatomic) IBOutlet UILabel *cerLab; /* 认证类型 */
@property (weak, nonatomic) IBOutlet UILabel *introLab; /* 认证描述 */
@property (weak, nonatomic) IBOutlet UILabel *cerType;/* 类型 */

@end
