//
//  AppDelegate.m
//  WmjrApp
//
//  Created by Baimifan on 16/2/20.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
//#import "HomeViewController.h"
#import "HomePageViewController.h"
#import "ProductListViewController.h"
#import "ProfileViewController.h"
#import "UserInfoModel.h"
#import "LoginViewController.h"

#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "JPUSHService.h"
#import "MyselfManageFinanceController.h"
#import "XHLaunchAd.h"
//jspatch
#import <JSPatchPlatform/JSPatch.h>

//静态广告
#define ImgUrlString1 @"http://d.hiphotos.baidu.com/image/pic/item/14ce36d3d539b60071473204e150352ac75cb7f3.jpg"
//动态广告
#define ImgUrlString2 @"http://c.hiphotos.baidu.com/image/pic/item/d62a6059252dd42a6a943c180b3b5bb5c8eab8e7.jpg"

@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate

+ (AppDelegate *)sharedInstance {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NSThread sleepForTimeInterval:2.0];
    //jspatch配置
//    [JSPatch startWithAppKey:@"153660e85d541b6c"];
//    [JSPatch sync];
    //本地测试jspatch
    [JSPatch testScriptInBundle];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:@"53a867bb0e9b6aff65abb491"
                          channel:@"AppStore"
                 apsForProduction:YES
            advertisingIdentifier:nil];
    
    
    [self example];

    /* 分享 */
    [self shareContent];
    
    
    //在这里处理界面跳转，didFinishLaunchingWithOptions这个方法不论是程序被杀死了，进入前台都会调用这个方法,从无到有进会走这个方法
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        NSLog(@"%@",launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]);
        NSLog(@"进行界面跳转");
        //        UILabel *view = [[UILabel alloc]init];
        //        view.numberOfLines = 0;
        //        view.text = [NSString stringWithFormat:@"%@",launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]];
        //        view.backgroundColor = [UIColor redColor];
        //        view.font = [UIFont systemFontOfSize:12];
        //        view.frame = CGRectMake(0, 0, 200, 300);
        //        [self.window.rootViewController.view addSubview:view];
        
        //获取到主页控制器
//        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
//        [nav popToRootViewControllerAnimated:NO];
//        HomeViewController *controller = [nav.childViewControllers firstObject];
//        NSString *ss;
//        if ([ss isEqualToString:@"newBuy"]) {
//            //跳转
//            MyselfManageFinanceController *mySelfVC = [[MyselfManageFinanceController alloc]init];
//            [controller.navigationController pushViewController:mySelfVC animated:YES];
//            
//        }
        
    }
    
    return YES;
}

/**
 *  启动页广告
 */
-(void)example
{
    /**
     *  1.显示启动页广告
     */
    [XHLaunchAd showWithAdFrame:CGRectMake(0, 0,self.window.bounds.size.width, self.window.bounds.size.height) setAdImage:^(XHLaunchAd *launchAd) {
        
        //未检测到广告数据,启动页停留时间,不设置默认为3,(设置4即表示:启动页显示了4s,还未检测到广告数据,就自动进入window根控制器)
        //launchAd.noDataDuration = 4;
        
        //获取广告数据
        [self requestImageData:^(NSString *imgUrl, NSInteger duration, NSString *openUrl) {
            
            /**
             *  2.设置广告数据
             */
            
            //定义一个weakLaunchAd
//            __weak __typeof(launchAd) weakLaunchAd = launchAd;
            [launchAd setImageUrl:imgUrl duration:duration skipType:SkipTypeTimeText options:XHWebImageRefreshCached completed:^(UIImage *image, NSURL *url) {
                
                //异步加载图片完成回调(若需根据图片尺寸,刷新广告frame,可在这里操作)
                //weakLaunchAd.adFrame = ...;
                
            } click:^{
                
                //广告点击事件
                
                //1.用浏览器打开
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
                
                //2.在webview中打开
//                WebViewController *VC = [[WebViewController alloc] init];
//                VC.URLString = openUrl;
//                [weakLaunchAd presentViewController:VC animated:YES completion:nil];
                
            }];
            
        }];
        
    } showFinish:^{
        
        //广告展示完成回调,设置window根控制器
//        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
        
        [self initTabbarCWithControllers];
        
    }];
}

/**
 *  模拟:向服务器请求广告数据
 *
 *  @param imageData 回调imageUrl,及停留时间,跳转链接
 */
-(void)requestImageData:(void(^)(NSString *imgUrl,NSInteger duration,NSString *openUrl))imageData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if(imageData)
        {
            imageData(@"http://api.wmjr888.com/Uploads/bootstrap.jpg",3,@"http://www.returnoc.com");
        }
    });
}

/* 分享 */
- (void)shareContent {
    [ShareSDK registerApp:@"8dfe2246f9f7" activePlatforms:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformSubTypeWechatSession), @(SSDKPlatformSubTypeQQFriend), @(SSDKPlatformSubTypeWechatTimeline)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;

            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType)
        {
            case SSDKPlatformTypeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                [appInfo SSDKSetupSinaWeiboByAppKey:@"3234818096"
                                          appSecret:@"28d3ef9811c622ae4ceca516285fbf66"
                                        redirectUri:@"http://www.sharesdk.cn"
                                           authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wx6b9c884ac57e29bf"
                                      appSecret:@"0b41f59c0600acd4c61f4343a76c2e86"];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:@"1104708039"
                                     appKey:@"usR1ASaS5dxq01Zh"
                                   authType:SSDKAuthTypeBoth];
                break;

            default:
                break;
        }
    }];
//    [ShareSDK registerApp:@"8dfe2246f9f7"];
    
//    /* 微博 */
//    [ShareSDK  connectSinaWeiboWithAppKey:@"3234818096"
//                                appSecret:@"28d3ef9811c622ae4ceca516285fbf66"
//                              redirectUri:@"http://www.sharesdk.cn"
//                              weiboSDKCls:[WeiboSDK class]];
//    /* QQ应用 */
//    [ShareSDK connectQQWithQZoneAppKey:@"1104708039"
//                     qqApiInterfaceCls:[QQApiInterface class]
//                       tencentOAuthCls:[TencentOAuth class]];
//    /*  微信/朋友圈 */
//    [ShareSDK connectWeChatSessionWithAppId:@"wx6b9c884ac57e29bf" appSecret:@"0b41f59c0600acd4c61f4343a76c2e86" wechatCls:[WXApi class]];
//    [ShareSDK connectWeChatTimelineWithAppId:@"wx6b9c884ac57e29bf" appSecret:@"0b41f59c0600acd4c61f4343a76c2e86" wechatCls:[WXApi class]];
}

- (void)initTabbarCWithControllers {
    /*导航条上的视图控制器*/
//    HomeViewController *homeVC = [[HomeViewController alloc] init];
    HomePageViewController *homeVC = [[HomePageViewController alloc]init];
    BaseNavigationController *homeNa = [[BaseNavigationController alloc] initWithRootViewController:homeVC];
    UITabBarItem *homeTab = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"tab_btn_home_nor"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] selectedImage:[[UIImage imageNamed:@"tab_btn_home_pre"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
    homeVC.tabBarItem = homeTab;
    
//    ProductViewController *productVC = [ProductViewController sharedManager];
    ProductListViewController *productVC = [[ProductListViewController alloc]init];
    BaseNavigationController *productNa = [[BaseNavigationController alloc] initWithRootViewController:productVC];
    UITabBarItem *productTab = [[UITabBarItem alloc] initWithTitle:@"理财" image:[[UIImage imageNamed:@"tab_btn_licai_nor"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] selectedImage:[[UIImage imageNamed:@"tab_btn_licai_pre"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
    productVC.tabBarItem = productTab;
    
    
    ProfileViewController *profileVC = [[ProfileViewController alloc] init];
    BaseNavigationController *profileNa = [[BaseNavigationController alloc] initWithRootViewController:profileVC];
    UITabBarItem *profileTab = [[UITabBarItem alloc] initWithTitle:@"账户中心" image:[[UIImage imageNamed:@"tab_btn_zhanghui_nor"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] selectedImage:[[UIImage imageNamed:@"tab_btn_zhanghui_pre"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]];
    profileVC.tabBarItem = profileTab;
    
    self.tabbarC = [[UITabBarController alloc] init];
    self.tabbarC.viewControllers = @[homeNa, productNa, profileNa];
    self.tabbarC.tabBar.tintColor = RGBA(0, 102, 177, 1.0);
    self.tabbarC.delegate = self;
    
    self.window.rootViewController = self.tabbarC;
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController.tabBarItem.title isEqualToString:@"账户中心"]) {
        NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
        uid = [self convertNullString:uid];
        if ([uid isEqualToString:@""]) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            UINavigationController *loginNa = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [((UINavigationController *)tabBarController.selectedViewController) presentViewController:loginNa animated:YES completion:nil];
            return NO;
        } else {
            return YES;
        }
    } else {
        return YES;
    }
}

- (NSString*)convertNullString:(NSString*)oldString{
    if (oldString!=nil && (NSNull *)oldString != [NSNull null]) {
        if ([oldString length]!=0) {
            if ([oldString isEqualToString:@"(null)"]) {
                return @"";
            }
            return  oldString;
        }else{
            return @"";
        }
    }
    else{
        return @"";
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", userInfo);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
    
    if (application.applicationState == UIApplicationStateInactive) {
        //在进入前台的时候才执行
        NSLog(@"本地通知");
        NSLog(@"%@",notification.userInfo);
        //获取到主页控制器
//        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
//        [nav popToRootViewControllerAnimated:NO];
//        HomeViewController *controller = [nav.childViewControllers firstObject];
//        NSString *ss;
//        if ([ss isEqualToString:@"newBuy"]) {
//            //跳转
//            MyselfManageFinanceController *mySelfVC = [[MyselfManageFinanceController alloc]init];
//            [controller.navigationController pushViewController:mySelfVC animated:YES];
//        }
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

/*应用程序将要进入活跃状态执行*/
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    /*应用程序将要进入活跃状态，即将进入前台运行*/
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"GESTURESTOLOCKNOTIFITION" object:nil];
    
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
