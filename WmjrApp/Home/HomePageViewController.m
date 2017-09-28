//
//  HomePageViewController.m
//  WmjrApp
//
//  Created by horry on 2016/10/31.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomeTableViewCellFirst.h"
#import "HomeTableViewCellSecond.h"
#import "HomeTableViewCellThird.h"
#import "HomeTableViewCellForth.h"
#import "AliGesturePasswordViewController.h"
#import "LoginViewController.h"
#import "ImgHomeModel.h"
#import "AgViewController.h"
#import "BaseNavigationController.h"
#import "ProductIntroViewController.h"
#import "NewsModel.h"
#import "PersonInvestModel.h"
#import "MessageWViewController.h"
#import "UserInfoModel.h"
#import "HomeGuideView.h"
#import "SafeEnsureViewController.h"
#import "HomeTableViewCellThirdFirst.h"
#import "LongProductDetailViewController.h"
#import "RedPackageModel.h"
#import "MainRedBallView.h"
#import "MyRedPackageViewController.h"
#import "AppDelegate.h"

@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *homeTableView;

@property (nonatomic, strong) UIView * naviView;

@property (nonatomic, strong) UIImageView *imageViewForLeft;

@property (nonatomic, strong) UIButton *buttonSinaCenter;//新兰中心2
@property (nonatomic, strong) UIButton *buttonForMess;//消息中心
@property (nonatomic, strong) UIImageView *imageForMess;
@property (nonatomic, strong) UILabel *labelForLine;//竖线

@property (nonatomic, strong) NSMutableArray *arrayForTopImage;//轮播图数组

@property (nonatomic, strong) NSMutableArray *arrayForRecommendPro;//短期产品列表

@property (nonatomic, strong) NSMutableArray *arrayForNewsList;//新闻列表

@property (nonatomic, strong) PersonInvestModel *personInvestModel;//个人投资信息

@property (nonatomic, assign) BOOL isSave;//是否保存手势了

//@property (nonatomic, strong) ProductModel *longProduct;//新人购产品
@property (nonatomic, strong) NSMutableArray *arrayForNewBuy;//新人购数组

@property (nonatomic, assign) NSInteger currentPage;//当前页

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) MainRedBallView *redBallView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) NSMutableArray *redPackageArray;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    self.window = [[UIApplication sharedApplication].delegate window];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    BOOL isNull = [self isNullString:uid];
    if (!isNull) {
        [SingletonManager sharedManager].uid = uid;
        [self getDataWithLogin];
    }
    
    self.currentPage = 0;
    
    //如果有手势密码让他验证手势密码
    //    BOOL isSave = [KeychainData isSave]; //是否有保存
//    _isSave = [[SingletonManager sharedManager] isSave]; //是否有保存
//    if (_isSave) {
//        
//        AliGesturePasswordViewController *setpass = [[AliGesturePasswordViewController alloc] init];
//        setpass.string = @"验证密码";
//        setpass.isHome = @"yes";
//        [self presentViewController:setpass animated:YES completion:nil];
//        
//    }
    
    
    //退出登录时响应执行还有在主页重新登录的时候响应
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logoutMethod) name:@"logout" object:nil];
    //手势验证成功时显示
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(homeGuideLayout) name:@"addHomeGudie" object:nil];
    //登录成功广播
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccessMethod) name:@"loginSuccess" object:nil];
    
    [self setUpTableViewMethod];
    [self setReplaceNavMethod];
    
    //检查是否开启推送
//    if (IOS8) { //iOS8以上包含iOS8
//        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
//            [[[UIAlertView alloc]initWithTitle:@"您没有开启推送通知" message:@"请去设置-通知中修改" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
//        }
//    }else{ // ios7 一下
//        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes]  == UIRemoteNotificationTypeNone) {
//            [[[UIAlertView alloc]initWithTitle:@"您没有开启推送通知" message:@"请去设置-通知中修改" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
//        }
//    }
    
    
}

- (void)logoutMethod{
    [_homeTableView reloadData];
    _buttonSinaCenter.hidden = YES;
    _labelForLine.hidden = YES;
}

- (void)loginSuccessMethod {
    _buttonSinaCenter.hidden = NO;
    _labelForLine.hidden = NO;
}

#pragma mark - 获取红包信息
- (void)getRedBallMethod {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Redpacket/my" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid,@"status":@"2",@"is_new":@"1"} withBlock:^(id obj) {
        _redPackageArray = [[NSMutableArray alloc]init];
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                NSArray *dataArray = obj[@"data"];
                _redPackageArray = [[NSMutableArray alloc]init];
                for (int i=0; i<dataArray.count; i++) {
                    NSDictionary *dict = dataArray[i];
                    RedPackageModel *redPackageModel = [RedPackageModel mj_objectWithKeyValues:dict];
                    [_redPackageArray addObject:redPackageModel];
                }
                NSInteger row = _redPackageArray.count;
//                [[NSUserDefaults standardUserDefaults] setObject:@(row) forKey:@"redBallNumber"];
                //红包弹出框
                if (_redPackageArray.count>0) {
                    [self showRedBallView:_redPackageArray.count];
                }
                
                [SVProgressHUD dismiss];
                return ;
            } else {
                NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
                alertConfig.defaultTextOK = @"确定";
                [SVProgressHUD dismiss];
                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
                [alertView show];
            }
        }
    }];
}

#pragma mark - 获取红包2
- (void)getRedBallMethod2 {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Redpacket/my" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid,@"status":@"2",@"is_new":@"2"} withBlock:^(id obj) {
        _redPackageArray = [[NSMutableArray alloc]init];
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                NSArray *dataArray = obj[@"data"];
                _redPackageArray = [[NSMutableArray alloc]init];
                for (int i=0; i<dataArray.count; i++) {
                    NSDictionary *dict = dataArray[i];
                    RedPackageModel *redPackageModel = [RedPackageModel mj_objectWithKeyValues:dict];
                    [_redPackageArray addObject:redPackageModel];
                }
                NSInteger row = _redPackageArray.count;
                if (row>0) {
                    [[AppDelegate sharedInstance] redView];
                } else {
                    [[[AppDelegate sharedInstance] redView] removeFromSuperview];
                    [AppDelegate sharedInstance].redView = nil;
                }
                //获取红包
                [self getRedBallMethod];
                
                [SVProgressHUD dismiss];
                return ;
            } else {
                NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
                alertConfig.defaultTextOK = @"确定";
                [SVProgressHUD dismiss];
                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
                [alertView show];
            }
        }
    }];
}


#pragma mark - 弹出红包窗口
- (void)showRedBallView:(NSInteger)row {
    
    _blackView = [[UIView alloc]init];
    _blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
    [self.window addSubview:_blackView];
    [_blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.window);
    }];
    
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeBlackView)];
    
    NSInteger viewHeight;
    
    CGFloat width = SCREEN_WIDTH;//5s 320    6  375    6p 414
    NSInteger guessHeight;
    if (width == 320) {
        guessHeight = RESIZE_UI(130);
    } else if (width == 375) {
        guessHeight = RESIZE_UI(90);
    } else {
        guessHeight = RESIZE_UI(40);
    }
    
    if (row == 1) {
        viewHeight = RESIZE_UI(78+131)+guessHeight;
    } else if (row == 2) {
        viewHeight = RESIZE_UI(78+252)+guessHeight;
    } else {
        viewHeight = RESIZE_UI(78+300)+guessHeight;
    }
    
    _redBallView = [[MainRedBallView alloc]initWithRow:_redPackageArray];
    _redBallView.backgroundColor = RGBA(255, 84, 34, 1.0);
    _redBallView.layer.masksToBounds = YES;
    _redBallView.layer.cornerRadius = 20.0f;
    @weakify(self);
    _redBallView.jumpToMyRed = ^(){
        @strongify(self);
        [self jumpToMyRed];
    };
    [_blackView addSubview:_redBallView];
    [_redBallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.window.mas_centerX);
        make.centerY.equalTo(self.window.mas_centerY);
        make.height.mas_offset(RESIZE_UI(viewHeight));
        make.width.mas_offset(RESIZE_UI(334));
    }];
    
    _closeButton = [[UIButton alloc]init];
    [_closeButton setBackgroundImage:[UIImage imageNamed:@"icon_guanbi"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeBlackView) forControlEvents:UIControlEventTouchUpInside];
    [_blackView addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_redBallView.mas_bottom).with.offset(RESIZE_UI(19));
        make.centerX.equalTo(self.window.mas_centerX);
        make.width.height.mas_offset(RESIZE_UI(34));
    }];
}

- (void)closeBlackView {
    [_closeButton removeFromSuperview];
    _closeButton = nil;
    [_redBallView removeFromSuperview];
    _redBallView = nil;
    [_blackView removeFromSuperview];
    _blackView = nil;
    [_blackView removeGestureRecognizer:_tap];
    _tap = nil;
}

#pragma mark - 跳转到我的红包
- (void)jumpToMyRed {
    [self closeBlackView];
    MyRedPackageViewController *myRedPackageVC = [[MyRedPackageViewController alloc]init];
    [self.navigationController pushViewController:myRedPackageVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"HomePageViewController"];
    //程序复活了
    [[NSUserDefaults standardUserDefaults] setObject:@"alive" forKey:@"death"];
    
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    BOOL isNull = [self isNullString:uid];
    if (!isNull) {
        [self getPersonalMessage];
    }
    /* 获取数据 */
    [self getDataWithNetManager];
    if (![[self convertNullString:[SingletonManager sharedManager].uid] isEqualToString:@""]) {
        [self getRedBallMethod2];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
    
    [[[AppDelegate sharedInstance] redView] removeFromSuperview];
    [AppDelegate sharedInstance].redView = nil;
    [MobClick endLogPageView:@"HomePageViewController"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 获取个人信息
- (void)getPersonalMessage {
    
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"User/income" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            _personInvestModel = [PersonInvestModel mj_objectWithKeyValues:obj[@"data"]];
            [self getAccountRest];
        } else {
            NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            [SVProgressHUD dismiss];
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
            [alertView show];
        }
    }];
    
}

#pragma mark - 获取账户余额
- (void)getAccountRest {
    //获取当前余额
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"User/queryBalance" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"account_type":@"SAVING_POT"} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSString *balanceValue = [obj[@"data"] objectForKey:@"available_balance"];
            _personInvestModel.account_rest = balanceValue;
            [_homeTableView reloadData];
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }
    }];
}

#pragma mark - 数据处理
- (void)getDataWithNetManager {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Ad/index" withParamDictionary:@{@"location":@"top"} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSArray *arrayTopAd = obj[@"data"];
            self.arrayForTopImage = [[NSMutableArray alloc]init];
            for (int i=0; i<arrayTopAd.count; i++) {
                NSDictionary *dicForImage = arrayTopAd[i];
                ImgHomeModel *imageModel = [ImgHomeModel mj_objectWithKeyValues:dicForImage];
                [self.arrayForTopImage addObject:imageModel];
            }
            //获取推荐产品列表
            [self getLongProductList];
            
        } else {
            [SVProgressHUD dismiss];
            NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            [SVProgressHUD dismiss];
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
            [alertView show];
        }
    }];
}

#pragma mark - 获取一个新人购产品
- (void)getLongProductList {
    
    NetManager *manager = [[NetManager alloc] init];
    NSDictionary *paramDic = @{@"is_recommend":@"1",@"is_newer":@"1"};
    [manager postDataWithUrlActionStr:@"Finance/index" withParamDictionary:paramDic withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            _arrayForNewBuy = [[NSMutableArray alloc]init];
            [ProductModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"proIntro_id" : @"id"};
            }];
            [ProductModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"segment":@"LongProductSegment"
                         };
            }];
            NSArray *longProArr = obj[@"data"];
//            if (longProArr.count>0) {
//                _longProduct = [ProductModel mj_objectWithKeyValues:longProArr[0]];
//            }
            for (int i=0; i<longProArr.count; i++) {
                NSDictionary *dict = longProArr[i];
                ProductModel *product = [ProductModel mj_objectWithKeyValues:dict];
                [_arrayForNewBuy addObject:product];
            }
            [self getShortProductList];
            
        } else {
            [SVProgressHUD dismiss];
            NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            [SVProgressHUD dismiss];
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
            [alertView show];
        }
    }];
    
}

#pragma mark - 获取优选推荐产品
- (void)getShortProductList {
    NetManager *manager = [[NetManager alloc] init];
    NSDictionary *paramDic = @{@"is_recommend":@"1",@"is_newer":@"0"};
    [manager postDataWithUrlActionStr:@"Finance/index" withParamDictionary:paramDic withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
//            NSDictionary *dic = obj;
            _arrayForRecommendPro = [NSMutableArray array];
            [ProductModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"proIntro_id" : @"id"};
            }];
            [ProductModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"segment":@"LongProductSegment"
                         };
            }];
            _arrayForRecommendPro = [ProductModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
            
            [self getNewsListMethod];
            
        } else {
            [SVProgressHUD dismiss];
            NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            [SVProgressHUD dismiss];
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
            [alertView show];
        }
    }];
}


#pragma mark - 获取新闻列表
- (void)getNewsListMethod {
    
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"Page/news" withParamDictionary:@{@"page":@"1",@"size":@""} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            _arrayForNewsList = [NSMutableArray array];
            [NewsModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"news_id" : @"id"};
            }];
            _arrayForNewsList = [NewsModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
            [_homeTableView reloadData];
//            if (!_isSave) {
//                [self homeGuideLayout];
//            }
            //引导
        NSString *app_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *userId = [self convertNullString:[SingletonManager sharedManager].uid];
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"appVersion"] isEqualToString:app_version]&&[userId isEqualToString:@""]) {
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            NSString *content = [pasteboard string];
            content = [self convertNullString:content];
            if ([content rangeOfString:@"wmcf-"].location ==NSNotFound) {
//                [self homeGuideLayout];
            }
            
        }
            //获取客服电话
            [self getCompanyTelphoneMethod];
            
        } else {
            [SVProgressHUD dismiss];
            NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            [SVProgressHUD dismiss];
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
            [alertView show];
        }
    }];
    
}

#pragma mark - 获取新闻列表2
- (void)getNewsListMethodTwo:(NSInteger)page {
    
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"Page/news" withParamDictionary:@{@"page":@(page),@"size":@""} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
//            _arrayForNewsList = [NSMutableArray array];
            [NewsModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"news_id" : @"id"};
            }];
            NSArray *newArray = [NewsModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
            for (int i=0; i<newArray.count; i++) {
                NewsModel *newsModel = newArray[i];
                [_arrayForNewsList addObject:newsModel];
            }
            
            [_homeTableView reloadData];
            
            [_homeTableView.mj_footer endRefreshing];
            
            
        } else {
            [SVProgressHUD dismiss];
            [_homeTableView.mj_footer endRefreshing];
            NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            [SVProgressHUD dismiss];
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
            [alertView show];
        }
    }];
    
}

#pragma mark - 获取客服电话
- (void)getCompanyTelphoneMethod {
    
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"App/setting" withParamDictionary:@{@"name":@"assistant"} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSDictionary *dic = obj[@"data"];
            [SingletonManager sharedManager].companyTel = dic[@"value"];
            //获取产品列表分类 为产品列表页所用
            [self getProductListTypeClass];
        }else {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }
    }];
    
}

#pragma mark - 获取产品列表分类
- (void)getProductListTypeClass {
    
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"Product/type" withParamDictionary:@{@"mobile":@"as"} withBlock:^(id obj) {
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                NSArray *dataDic = obj[@"data"];
                NSInteger count = dataDic.count;
                [SingletonManager sharedManager].productListCount = count;
                [SVProgressHUD dismiss];
                return ;
            }
            if ([obj[@"result"] isEqualToString:@"1000"]) {
                NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
                alertConfig.defaultTextOK = @"确定";
                [SVProgressHUD dismiss];
                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
                [alertView show];
            }
        }
    }];
    
}

#pragma mark - 数据处理 －
- (void)getDataWithLogin {
    NetManager *manager = [[NetManager alloc] init];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *mobile = [userDefault objectForKey:@"mobile"];
    NSString *pwd = [userDefault objectForKey:@"passWord"];
    mobile = [self convertNullString:mobile];
    pwd = [self convertNullString:pwd];
    [manager postDataWithUrlActionStr:@"User/login" withParamDictionary:@{@"mobile":mobile, @"pwd":pwd} withBlock:^(id obj) {
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                NSDictionary *dataDic = obj[@"data"];
                [UserInfoModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                    return @{@"user_id" : @"id"};
                }];
                UserInfoModel *userModel = [UserInfoModel mj_objectWithKeyValues:dataDic];
                [SingletonManager sharedManager].userModel = userModel;
                
                //登录成功才出手势验证码
                _isSave = [[SingletonManager sharedManager] isSave]; //是否有保存
                if (_isSave) {
                    
                    AliGesturePasswordViewController *setpass = [[AliGesturePasswordViewController alloc] init];
                    setpass.string = @"验证密码";
                    setpass.isHome = @"yes";
                    [self presentViewController:setpass animated:YES completion:nil];
                    
                }
                
                return ;
            } else {
                [SVProgressHUD showInfoWithStatus:@"账号密码有误,请重新登录"];
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                loginVC.loginIden = @"login";
                loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                UINavigationController *loginNa = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNa animated:YES completion:nil];
            }
//            if ([obj[@"result"] isEqualToString:@"1000"]) {
//                NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
//                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
//                alertConfig.defaultTextOK = @"确定";
//                [SVProgressHUD dismiss];
//                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
//                [alertView show];
//            }
        }
    }];
}

- (void)setReplaceNavMethod {
    
    self.naviView = [[UIView alloc] init];
    self.naviView.backgroundColor = RGBA(0, 104, 178, 0.0);
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(64);
    }];
    
    _imageViewForLeft = [[UIImageView alloc]init];
    _imageViewForLeft.image = [UIImage imageNamed:@"navi_bar"];
    _imageViewForLeft.alpha = 0;
    [self.naviView addSubview:_imageViewForLeft];
    [_imageViewForLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_top).with.offset(35);
        make.left.equalTo(self.naviView.mas_left).with.offset(13);
        make.height.mas_offset(RESIZE_UI(17));
        make.width.mas_offset(RESIZE_UI(100));
    }];
    
    //新浪平台
    _buttonSinaCenter = [[UIButton alloc]init];
    [_buttonSinaCenter setTitle:@"安全保障" forState:UIControlStateNormal];
    _buttonSinaCenter.alpha = 0.05;
    _buttonSinaCenter.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    [_buttonSinaCenter setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
    [_buttonSinaCenter addTarget:self action:@selector(sinaMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:_buttonSinaCenter];
    [_buttonSinaCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_top).with.offset(38);
        make.right.equalTo(self.naviView.mas_right).with.offset(-53);
        make.height.mas_offset(14);
    }];
    
    //竖线
    _labelForLine = [[UILabel alloc]init];
    _labelForLine.backgroundColor = [UIColor whiteColor];
    _labelForLine.alpha = 0;
    [self.naviView addSubview:_labelForLine];
    [_labelForLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_buttonSinaCenter.mas_top);
        make.bottom.equalTo(_buttonSinaCenter.mas_bottom);
        make.width.mas_offset(1);
        make.left.equalTo(_buttonSinaCenter.mas_right).with.offset(12);
    }];
    
    //消息中心
    _imageForMess = [[UIImageView alloc]init];
    _imageForMess.image = [UIImage imageNamed:@"notific"];
    _imageForMess.alpha = 0;
    [self.naviView addSubview:_imageForMess];
    [_imageForMess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.naviView.mas_right).with.offset(-12);
        make.centerY.equalTo(_buttonSinaCenter.mas_centerY);
        make.height.mas_offset(19);
        make.width.mas_offset(15);
    }];
    
    _buttonForMess = [[UIButton alloc]init];
    _buttonForMess.alpha = 0.05;
    _buttonForMess.backgroundColor = [UIColor clearColor];
    [_buttonForMess addTarget:self action:@selector(messageBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:_buttonForMess];
    [_buttonForMess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_labelForLine.mas_right);
        make.right.equalTo(self.naviView.mas_right);
        make.top.equalTo(_labelForLine.mas_top);
        make.bottom.equalTo(_labelForLine.mas_bottom);
    }];
    
    
}

#pragma mark - 新浪平台方法
- (void)sinaMethod {
//    [self jumpToAdWebView:@"新浪资金托管平台" WebUrl:@"https://pay.sina.com.cn/zjtg/#thirdPage"];
    SafeEnsureViewController *safeVC = [[SafeEnsureViewController alloc]init];
    [self.navigationController pushViewController:safeVC animated:YES];
    
}

- (void)setUpTableViewMethod {
    
    _homeTableView = [[UITableView alloc]init];
//    _homeTableView.backgroundColor = [UIColor redColor];
    _homeTableView.delegate = self;
    _homeTableView.dataSource = self;
//    _homeTableView.bounces = NO;
    _homeTableView.showsVerticalScrollIndicator = NO;
    _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_homeTableView registerClass:[HomeTableViewCellFirst class] forCellReuseIdentifier:@"HomeTableViewCellFirst"];
    [_homeTableView registerClass:[HomeTableViewCellSecond class] forCellReuseIdentifier:@"HomeTableViewCellSecond"];
    [_homeTableView registerClass:[HomeTableViewCellThird class] forCellReuseIdentifier:@"HomeTableViewCellThird"];
    [_homeTableView registerClass:[HomeTableViewCellThirdFirst class] forCellReuseIdentifier:@"HomeTableViewCellThirdFirst"];
    [_homeTableView registerNib:[UINib nibWithNibName:@"HomeTableViewCellForth" bundle:nil] forCellReuseIdentifier:@"forthcell"];
    
    [self.view addSubview:_homeTableView];
    [_homeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(-20);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
    
    _homeTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage ++;
        [self getNewsListMethodTwo:self.currentPage];
    }];

    
}

#pragma mark - 首页引导
//- (void)homeGuideLayout {
//    NSString *app_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    NSString *userId = [self convertNullString:[SingletonManager sharedManager].uid];
//    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"appVersion"];
//    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"appVersion"] isEqualToString:app_version]&&[userId isEqualToString:@""]) {
//        [[NSUserDefaults standardUserDefaults]setObject:app_version forKey:@"appVersion"];
//        CGRect frame = [UIScreen mainScreen].bounds;
//        NSInteger count;
//        if (self.arrayForNewsList.count<=3) {
//            count = self.arrayForNewsList.count;
//        } else {
//            count = 3;
//        }
//        HomeGuideView *homeGuideView = [[HomeGuideView alloc]initWithFrame:frame andNewsListCount:count];
//        @weakify(self)
//        homeGuideView.forthLearnMethod = ^(){
//            @strongify(self)
//            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:count-1 inSection:4];
//            [self.homeTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
//        };
//        homeGuideView.destroySelfMethod = ^(){
//            @strongify(self)
//            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//            [self.homeTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        };
////        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
////        [window addSubview:homeGuideView];
//        [[UIApplication sharedApplication].keyWindow addSubview:homeGuideView];
//        
//    }
//    
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2){
        return _arrayForNewBuy.count;
    } else if (section == 3) {
        return _arrayForRecommendPro.count;
    } else {
        return _arrayForNewsList.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    } else if(section == 1) {
        return RESIZE_UI(12);
    } else {
        return RESIZE_UI(54);
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *viewForHeader = [[UIView alloc]init];
    viewForHeader.backgroundColor = RGBA(239, 239, 239, 1.0);
    
    if (section != 0 && section != 1) {
        
        UIView *whiteView = [[UIView alloc]init];
        whiteView.backgroundColor = [UIColor whiteColor];
        [viewForHeader addSubview:whiteView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(viewForHeader.mas_bottom).with.offset(-1);
            make.left.equalTo(viewForHeader.mas_left);
            make.right.equalTo(viewForHeader.mas_right);
            make.height.mas_offset(RESIZE_UI(42));
        }];
        
        UILabel *labelForLine = [[UILabel alloc]init];
        labelForLine.backgroundColor = RGBA(255, 82, 37, 1.0);
        [whiteView addSubview:labelForLine];
        [labelForLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(whiteView.mas_centerY);
            make.left.equalTo(whiteView.mas_left);
            make.height.mas_offset(17);
            make.width.mas_offset(5);
        }];
        
        UILabel *labelForTitle = [[UILabel alloc]init];
        labelForTitle.text = @"";
        labelForTitle.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
        labelForTitle.textColor = [UIColor blackColor];
        [whiteView addSubview:labelForTitle];
        [labelForTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(whiteView.mas_centerY);
            make.left.equalTo(whiteView.mas_left).with.offset(13);
        }];
        switch (section) {
            case 2:
                labelForTitle.text = @"旺马新人购";
                break;
            case 3:
                labelForTitle.text = @"旺马优选";
                break;
            case 4:
                labelForTitle.text = @"旺马头条";
                break;
            default:
                break;
        }
    }
    return viewForHeader;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        CGFloat height = RESIZE_UI(202);
        return height;
    } else if (indexPath.section == 1) {
        CGFloat height = RESIZE_UI(109);
        return height;
    } else if (indexPath.section == 2){
        return RESIZE_UI(109);
    } else if (indexPath.section == 3) {
        return RESIZE_UI(109);
    } else {
        return RESIZE_UI(117);
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        HomeTableViewCellFirst *cell = [[HomeTableViewCellFirst alloc]initWithDic:_personInvestModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.learnWangma = ^(){
            [self sinaMethod];
        };
        
        cell.contactWangma = ^(){
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[SingletonManager sharedManager].companyTel];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        };
        
        cell.jumpToMessageCenter = ^(){
            [self messageBtnAction];
        };
        return cell;
        
    } else if(indexPath.section == 1) {
        
        HomeTableViewCellSecond *cell = [[HomeTableViewCellSecond alloc]initWithImageArray:self.arrayForTopImage];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cycleImage = ^(ImgHomeModel *imgModel) {
            NSString *productId = imgModel.product_id;
            NSString *url = imgModel.url;
            productId = [self convertNullString:productId];
            url = [self convertNullString:url];
            if ([url isEqualToString:@""] && [productId isEqualToString:@""]) {
                return;
            }
            if ([url isEqualToString:@"https://pay.sina.com.cn/zjtg/#thirdPage"]) {
                [self sinaMethod];
                return;
            }
            if (![url isEqualToString:@""]) {
                AgViewController *agVC =[[AgViewController alloc] init];
                agVC.title = imgModel.title;
                agVC.webUrl = url;
                [self.navigationController pushViewController:agVC animated:YES];
//                BaseNavigationController *baseNa = [[BaseNavigationController alloc] initWithRootViewController:agVC];
//                [self presentViewController:baseNa animated:YES completion:^{
//                }];
                return;
            }
            if (![productId isEqualToString:@""]) {
                if ([imgModel.product.is_long isEqualToString:@"1"]) {
                    LongProductDetailViewController *newproductbuyVC = [[LongProductDetailViewController alloc]init];
                    newproductbuyVC.productModel = imgModel.product;
                    newproductbuyVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:newproductbuyVC animated:YES];
                } else {
                    ProductIntroViewController *proIntroVC = [[ProductIntroViewController alloc] init];
                    proIntroVC.getPro_id = productId;
                    proIntroVC.title = imgModel.title;
                    [self.navigationController pushViewController:proIntroVC animated:YES];
                    return;
                }
            }
        };
        return cell;
        
    } else if (indexPath.section == 2){
        ProductModel *productModel = [_arrayForNewBuy objectAtIndexCheck:indexPath.row];
        if ([productModel.is_long isEqualToString:@"1"]) {
            HomeTableViewCellThirdFirst *cell = [[HomeTableViewCellThirdFirst alloc]initWithProductModel:productModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            HomeTableViewCellThird *cell = [[HomeTableViewCellThird alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configCellWithModel:productModel];
            return cell;
        }
    } else if (indexPath.section == 3) {
        if (_arrayForRecommendPro.count != 0) {
//            ProductModel *productModel = _arrayForRecommendPro[indexPath.row];
            ProductModel *productModel = [_arrayForRecommendPro objectAtIndexCheck:indexPath.row];
            if ([productModel.is_long isEqualToString:@"1"]) {
                HomeTableViewCellThirdFirst *cell = [[HomeTableViewCellThirdFirst alloc]initWithProductModel:productModel];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            } else {
                HomeTableViewCellThird *cell = [[HomeTableViewCellThird alloc]init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell configCellWithModel:productModel];
                return cell;
            }
        } else {
            static NSString *Cellindentifier = @"Cellindentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellindentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cellindentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
    }
    else {
        HomeTableViewCellForth *cell = [tableView dequeueReusableCellWithIdentifier:@"forthcell"];
        if (cell == nil) {
            NSBundle *bundle = [NSBundle mainBundle];
            NSArray *NibArray = [bundle loadNibNamed:@"HomeTableViewCellForth" owner:self options:nil];
            cell = (HomeTableViewCellForth *)[NibArray objectAtIndex:0];
            [cell setBackgroundColor:[UIColor whiteColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
//        NewsModel *newsModel = _arrayForNewsList[indexPath.row];
        NewsModel *newsModel = [_arrayForNewsList objectAtIndexCheck:indexPath.row];
        [cell.imageViewNews sd_setImageWithURL:[NSURL URLWithString:newsModel.pic_url]];
        cell.labelForTitle.text = newsModel.title;
        cell.labelForInfo.text = newsModel.intro;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        ProductModel *productModel = [_arrayForNewBuy objectAtIndexCheck:indexPath.row];
        if ([productModel.is_long isEqualToString:@"1"]) {
            LongProductDetailViewController *newproductbuyVC = [[LongProductDetailViewController alloc]init];
            newproductbuyVC.productModel = productModel;
            newproductbuyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newproductbuyVC animated:YES];
        } else {
            ProductIntroViewController *proIntroVC = [[ProductIntroViewController alloc] init];
            proIntroVC.getPro_id = productModel.proIntro_id;
            proIntroVC.title = productModel.name;
            [self.navigationController pushViewController:proIntroVC animated:YES];
        }
        
    }
    if (indexPath.section == 3) {
//        ProductModel *productModel = _arrayForRecommendPro[indexPath.row];
        ProductModel *productModel = [_arrayForRecommendPro objectAtIndexCheck:indexPath.row];
        if ([productModel.is_long isEqualToString:@"1"]) {
            //长期详情
            LongProductDetailViewController *newproductbuyVC = [[LongProductDetailViewController alloc]init];
            newproductbuyVC.productModel = productModel;
            newproductbuyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newproductbuyVC animated:YES];
        } else {
            //短期详情
            ProductIntroViewController *proIntroVC = [[ProductIntroViewController alloc] init];
            if ([[self convertNullString:productModel.proIntro_id] isEqualToString:@""]) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"缺少参数" message:@"请重新进入该页再试一次" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alertView show];
            } else {
                proIntroVC.getPro_id = productModel.proIntro_id;
                proIntroVC.title = productModel.name;
                [self.navigationController pushViewController:proIntroVC animated:YES];
            }
        }

    }
    if (indexPath.section == 4) {
        
//        NewsModel *newsModel = _arrayForNewsList[indexPath.row];
        NewsModel *newsModel = [_arrayForNewsList objectAtIndexCheck:indexPath.row];
        AgViewController *agVC =[[AgViewController alloc] init];
        agVC.title = newsModel.title;
        agVC.webUrl = newsModel.url;
        [self.navigationController pushViewController:agVC animated:YES];
//        BaseNavigationController *baseNa = [[BaseNavigationController alloc] initWithRootViewController:agVC];
//        [self presentViewController:baseNa animated:YES completion:^{
//        }];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"我的尺寸:%.2f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y <= -20) {
        _homeTableView.bounces = NO;
    } else {
        _homeTableView.bounces = YES;
    }
    CGFloat alpha = (RESIZE_UI(scrollView.contentOffset.y)-RESIZE_UI(18)) / 100;
    if (alpha >= 1) {
        alpha = 1;
    }else if (alpha <= 0)
    {
        alpha = 0;
    }
    self.naviView.backgroundColor = RGBA(0, 104, 178, alpha);
    _imageViewForLeft.alpha = alpha;
    _imageForMess.alpha = alpha;
    _labelForLine.alpha = alpha;
    if (alpha<0.05) {
        _buttonForMess.alpha = 0.05;
        _buttonSinaCenter.alpha = 0.05;
    }else {
        _buttonForMess.alpha = alpha;
        _buttonSinaCenter.alpha = alpha;
    }
//    CGFloat sectionHeaderHeight=0;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }

}

- (void)jumpToAdWebView:(NSString *)title WebUrl:(NSString *)url{
    
    AgViewController *agVC =[[AgViewController alloc] init];
    agVC.title = title;
    agVC.webUrl = url;
    [self.navigationController pushViewController:agVC animated:YES];
//    BaseNavigationController *baseNa = [[BaseNavigationController alloc] initWithRootViewController:agVC];
//    [self presentViewController:baseNa animated:YES completion:^{
//    }];
    
}

#pragma mark - 跳转到消息页面
- (void)messageBtnAction {
    
    if ([[self convertNullString:[SingletonManager sharedManager].uid] isEqualToString:@""]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.loginIden = @"login";
        loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UINavigationController *loginNa = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNa animated:YES completion:nil];
    } else{
        MessageWViewController *messageVC = [[MessageWViewController alloc] initWithNibName:@"MessageWViewController" bundle:nil];
        [self.navigationController pushViewController:messageVC animated:YES];
    }
}

#pragma mark - 判断字符串是否为空
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

- (BOOL) isNullString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}




/**
 闪退场景二： delegate = nil 。
 将XXViewContrller设置为delegate时，当页面发生跳转时，XXViewController的对象会被释放，这是代码走到[_delegate callbackMethod],便出现crash。解决方法有二：1.将@property (nonatomic ,assign) id <BLELibDelegate>delegate; 中 assign关键字改为weak。 2.在XXViewController的delloc方法中添加：xxx.delegate = nil;
 **/
- (void)dealloc {
    self.homeTableView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
