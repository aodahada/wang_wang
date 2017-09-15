//
//  MessageViewCell.h
//  wangmajinrong
//
//  Created by Baimifan on 15/11/20.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageModel;
@interface MessageViewCell : UITableViewCell

- (instancetype)initWithMessageModel:(MessageModel *)model;

@end
