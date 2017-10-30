//
//  UserInfoModel.h
//  wangmajinrong
//
//  Created by Baimifan on 15/7/10.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property (nonatomic, copy) NSString *user_id;//会员id
@property (nonatomic, copy) NSString *mobile;//手机号
@property (nonatomic, copy) NSString *name;//用户姓名
@property (nonatomic, copy) NSString *typeName;//会员类型名称
@property (nonatomic, copy) NSString *photourl;//头像地址
@property (nonatomic, copy) NSString *createtime;//会员注册时间
@property (nonatomic, copy) NSString *invitationcode;  /* 邀请码 */
@property (nonatomic, copy) NSString *is_real_name; /* 是否认证 */
@property (nonatomic, copy) NSString *card_id;  /* 是否绑卡 */
@property (nonatomic, copy) NSString *mobile_bind; /* 绑定银行卡时的手机号 */
@property (nonatomic, copy) NSString *is_newer;/* 是否是新人 1是新人，0不是新人*/
@property (nonatomic, copy) NSString *score;//积分
@property (nonatomic, copy) NSString *score_clear;//剩余积分

@end
