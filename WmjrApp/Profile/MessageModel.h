//
//  MessageModel.h
//  wangmajinrong
//
//  Created by Baimifan on 15/12/25.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic, copy) NSString *type;  /* 消息类型 */
@property (nonatomic, copy) NSString *content;  /* 消息内容 */

@end
