//
//  WKDelegateController.h
//  WmjrApp
//
//  Created by 霍锐 on 2018/6/28.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>

@protocol WKDelegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;
@end

@interface WKDelegateController : UIViewController

 @property (weak , nonatomic) id delegate;

@end
