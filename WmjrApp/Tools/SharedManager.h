//
//  SharedManager.h
//  share(无菜单)
//
//  Created by Baimifan on 15/7/31.
//  Copyright (c) 2015年 mob.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDKUI/ShareSDKUI.h>

@interface SharedManager : NSObject

- (void)shareContent:(UIButton *)sender withTitle:(NSString *)title andContent:(NSString *)content andUrl:(NSString *)url;

@end
