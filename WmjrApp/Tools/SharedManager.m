//
//  SharedManager.m
//  share(无菜单)
//
//  Created by Baimifan on 15/7/31.
//  Copyright (c) 2015年 mob.com. All rights reserved.
//

#import "SharedManager.h"

@implementation SharedManager

- (void)shareContent:(UIButton *)sender withTitle:(NSString *)title andContent:(NSString *)content andUrl:(NSString *)url {
    //1、创建分享参数（必要）
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"wangmalogo" ofType:@"png"];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:content
                                     images:[[SSDKImage alloc] initWithURL:[NSURL URLWithString:imagePath]]
                                        url:[NSURL URLWithString:url]
                                      title:title
                                       type:SSDKContentTypeAuto];
    SSDKPlatformType type = 0;
    switch (sender.tag) {
        case 500:
        {
            //定制QQ的分享内容
            [shareParams SSDKSetupQQParamsByText:content title:title url:[NSURL URLWithString:url] thumbImage:nil image:nil type:(SSDKContentTypeAuto) forPlatformSubType:(SSDKPlatformSubTypeQQFriend)];
            type = SSDKPlatformSubTypeQQFriend;
        }
            break;
        case 501:
        {
            // 定制微信好友的分享内容
            [shareParams SSDKSetupWeChatParamsByText:content title:title url:[NSURL URLWithString:url] thumbImage:nil image:[UIImage imageNamed:@"wangmalogo"] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];// 微信好友子平台
            type = SSDKPlatformSubTypeWechatSession;
        }
            break;
        case 502:
        {
            // 定制新浪微博的分享内容
            [shareParams SSDKSetupSinaWeiboShareParamsByText:content title:title image:[UIImage imageNamed:@"wangmalogo"] url:nil latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
            type = SSDKPlatformTypeSinaWeibo;
        }
            break;
        case 503:
        {
            // 定制微信朋友圈的分享内容
            [shareParams SSDKSetupWeChatParamsByText:content title:title url:[NSURL URLWithString:url] thumbImage:nil image:[UIImage imageNamed:@"wangmalogo"] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];// 微信好友子平台
            type = SSDKPlatformSubTypeWechatTimeline;
        }
            break;
            
        default:
            break;
    }
    
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
    }];


}

@end
