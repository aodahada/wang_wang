//
//  MessageModel.h
//  wangmajinrong
//
//  Created by Baimifan on 15/12/25.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic, copy) NSString *message_id;
@property (nonatomic, copy) NSString *message_intro;
@property (nonatomic, copy) NSString *message_title;
//@property (nonatomic, copy) NSString *type_color;
@property (nonatomic, copy) NSString *type_color;
@property (nonatomic ,copy) NSString *type_name;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *can_click;

@end
