//
//  AppDelegate.h
//  WmjrApp
//
//  Created by Baimifan on 16/2/20.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabbarC;
@property (nonatomic, strong) UIView *redView;

+ (AppDelegate *)sharedInstance;

- (void)initTabbarCWithControllers;

@end

