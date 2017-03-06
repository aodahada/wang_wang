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
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


#import "MyselfManageFinanceController.h"
#import "XHLaunchAd.h"
//jspatch
#import <JSPatchPlatform/JSPatch.h>

//静态广告
#define ImgUrlString1 @"http://d.hiphotos.baidu.com/image/pic/item/14ce36d3d539b60071473204e150352ac75cb7f3.jpg"
//动态广告
#define ImgUrlString2 @"http://c.hiphotos.baidu.com/image/pic/item/d62a6059252dd42a6a943c180b3b5bb5c8eab8e7.jpg"

@interface AppDelegate ()<UITabBarControllerDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate

+ (AppDelegate *)sharedInstance {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //设置状态栏字体颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:@"53a867bb0e9b6aff65abb491"
                          channel:@"AppStore"
                 apsForProduction:1
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

-(UIStatusBarStyle)preferredStatusBarStyle

{
    
    return UIStatusBarStyleLightContent;  //默认的值是黑色的
    
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

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if
    // appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
    NSString *haha = [NSString stringWithFormat:@"%@",error];
//    [[[UIAlertView alloc] initWithTitle:@"推送连接错误" message:haha delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

@end
