//
//  WebViewForActivityViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/6/28.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "WebViewForActivityViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "CaiYouCircleViewController.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "SortCaiYouViewController.h"
#import "PopMenu.h"
#import "SharedView.h"

@protocol JSObjcDelegate <JSExport>
//wangma对象调用的JavaScript方法，必须声明！！！
/**
 去产品列表
 */
- (void)openProductList;
/**
 去财友圈
 */
- (void)openFriendCircle;
/**
 分享
 */
- (void)openShare:(NSString *)url;
/**
 注册
 */
- (void)openRegister;

@end

@interface WebViewForActivityViewController ()<UIWebViewDelegate,JSExport,JSObjcDelegate>{
        PopMenu *_popMenu;
        SharedView *_sharedView;
}

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) JSContext *context;

@end

@implementation WebViewForActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _webView = [[UIWebView alloc]init];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]]];
    //https://7hg.oss-cn-shanghai.aliyuncs.com/test.html
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://7hg.oss-cn-shanghai.aliyuncs.com/test.html"]]];
    [_webView sizeToFit];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"WebViewForActivityViewController"];
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"WebViewForActivityViewController"];
}

//网页开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD showWithStatus:@"加载中"];
}
//网页加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
    
    // 还可以直接调用js定义的方法
    // 比如getShareUrl()为js端定义好的方法，返回值为分享的url
    
    // 还可以为js端提供完整的原生方法供其调用（记得导入#import <JavaScriptCore/JavaScriptCore.h>）
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //将wangma对象指向自身
    self.context[@"wangma"] = self;
    //打印异常信息
    self.context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    // 可以定义供js调用的方法, testMethod为js调用的方法名(调用对象方法不能用)
//    self.context[@"openProductList"] = ^() {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"js调用方法" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
//            [alert show];
//        });
//    };
}
//网页加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
//    NSString *url = request.URL.absoluteString;
//    NSLog(@"url:%@",url);
    
    
    return YES;
    
}

-(void)openProductList {
    NSLog(@"打开产品列表");
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tabBarController.selectedIndex = 1;
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}

- (void)openFriendCircle {
    
    NSLog(@"打开唤醒界面");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
        uid = [SingletonManager convertNullString:uid];
        if ([uid isEqualToString:@""]) {
            [self jumpToLoginMethod];
        } else {
            SortCaiYouViewController *sortVC = [[SortCaiYouViewController alloc]init];
            //        sortVC.isHuanXing = YES;
            [self.navigationController pushViewController:sortVC animated:YES];
        }
    });
    
}

-(void)openShare:(NSString *)url {
    //分享
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    uid = [SingletonManager convertNullString:uid];
    if ([uid isEqualToString:@""]) {
        [self jumpToLoginMethod];
    } else {
        //分享
        [self clickSharedBtn];
    }
}

- (void)openRegister {
    //注册
    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    uid = [SingletonManager convertNullString:uid];
    if ([uid isEqualToString:@""]) {
        [self jumpToLoginMethod];
    } else {
        MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
        alertConfig.defaultTextOK = @"确定";
        [SVProgressHUD dismiss];
        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:@"你已经是老用户"];
        [alertView show];
    }
}

- (void)jumpToLoginMethod {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    BaseNavigationController *loginNa = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNa animated:YES completion:nil];
}

- (void)clickSharedBtn {
    _popMenu = [[PopMenu alloc] init];
    _popMenu.dimBackground = YES;
    _popMenu.coverNavigationBar = YES;
    _sharedView = [[SharedView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-RESIZE_UI(168), SCREEN_WIDTH, RESIZE_UI(168))];
    [_popMenu addSubview:_sharedView];
    [_popMenu showInRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //    _sharedView.center = _popMenu.center;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPopAction)];
    [_popMenu addGestureRecognizer:tap];
    
    [_sharedView callSharedBtnEventBlock:^(UIButton *sender) {
        [_popMenu dismissMenu];
        SharedManager *sharedManager = [[SharedManager alloc] init];
        if ([SingletonManager sharedManager].userModel.invitationcode) {
            //            NSString *contentStr = [NSString stringWithFormat:@"大吉大利，春节来“息”！工资不够，年终来凑！快快使用我的旺马财富推荐码%@立即出借吧！", [SingletonManager sharedManager].userModel.invitationcode];
            NSString *contentStr = @"旺马财富大富翁计划，邀请好友，建立财友圈，享好友附加收益。";
            //            NSString *urlStr = [NSString stringWithFormat:@"http://m.wmjr888.com/?invitationcode=%@#login-register",_invitationcode];
            NSString *urlStr = [NSString stringWithFormat:@"http://m.wangmacaifu.com/#/register/wmcf-%@",[SingletonManager sharedManager].userModel.invitationcode];
            [sharedManager shareContent:sender withTitle:@"参与大富翁计划，享财友收益" andContent:contentStr andUrl:urlStr];
            
        } else {
            [[SingletonManager sharedManager] alert1PromptInfo:@"推荐码获取失败,请重新分享"];
        }
    }];
}

/*遮盖消失*/
- (void)tapPopAction {
    [_popMenu dismissMenu];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
