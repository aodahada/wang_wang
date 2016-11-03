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

@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *homeTableView;

@property (nonatomic, strong) UIView * naviView;

@property (nonatomic, strong) UIImageView *imageViewForLeft;

@property (nonatomic, strong) UIButton *buttonForMess;

@property (nonatomic, strong) NSMutableArray *arrayForTopImage;//轮播图数组

@property (nonatomic, strong) NSMutableArray *arrayForRecommendPro;//推荐产品列表

@property (nonatomic, strong) NSMutableArray *arrayForNewsList;//新闻列表

@property (nonatomic, strong) PersonInvestModel *personInvestModel;//个人投资信息

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    BOOL isNull = [self isNullString:uid];
    if (!isNull) {
        [SingletonManager sharedManager].uid = uid;
        [self getDataWithLogin];
    }
    /* 获取数据 */
    [self getDataWithNetManager];
    //如果有手势密码让他验证手势密码
    //    BOOL isSave = [KeychainData isSave]; //是否有保存
    BOOL isSave = [[SingletonManager sharedManager] isSave]; //是否有保存
    if (isSave) {
        
        AliGesturePasswordViewController *setpass = [[AliGesturePasswordViewController alloc] init];
        setpass.string = @"验证密码";
        [self presentViewController:setpass animated:YES completion:nil];
        
    }
    
    //退出登录时响应执行还有在主页重新登录的时候响应
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logoutMethod) name:@"logout" object:nil];
    
}

- (void)logoutMethod{
    [_homeTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    //[super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    BOOL isNull = [self isNullString:uid];
    if (!isNull) {
        [self getPersonalMessage];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - 获取个人信息
- (void)getPersonalMessage {
    
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"User/income" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            _personInvestModel = [PersonInvestModel mj_objectWithKeyValues:obj[@"data"]];
            [_homeTableView reloadData];
            [SVProgressHUD dismiss];
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

#pragma mark - 数据处理
- (void)getDataWithNetManager {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Home/index" withParamDictionary:@{@"member_id":@"ss"} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSDictionary *dicSum = obj[@"data"];
            NSArray *arrayTopAd = dicSum[@"topad"];
            self.arrayForTopImage = [[NSMutableArray alloc]init];
            for (int i=0; i<arrayTopAd.count; i++) {
                NSDictionary *dicForImage = arrayTopAd[i];
                ImgHomeModel *imageModel = [ImgHomeModel mj_objectWithKeyValues:dicForImage];
                [self.arrayForTopImage addObject:imageModel];
            }
            //获取推荐产品列表
            [self getRecommendProductList];
            
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

#pragma mark - 获取推荐产品列表
- (void)getRecommendProductList {
    
    NetManager *manager = [[NetManager alloc] init];
    NSDictionary *paramDic = @{@"is_recommend":@"1", @"page":@"", @"size":@""};
    [manager postDataWithUrlActionStr:@"Product/new_index" withParamDictionary:paramDic withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            _arrayForRecommendPro = [NSMutableArray array];
            [ProductModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"proIntro_id" : @"id"};
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
    [manager postDataWithUrlActionStr:@"Page/news" withParamDictionary:@{@"mobile":@"as"} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            _arrayForNewsList = [NSMutableArray array];
            [NewsModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"news_id" : @"id"};
            }];
            _arrayForNewsList = [NewsModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
            
            [self setUpTableViewMethod];
            //设置自定义navgationview
            [self setReplaceNavMethod];
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
                return ;
            } else {
                [SVProgressHUD showInfoWithStatus:@"账号密码有误,请重新登录"];
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                loginVC.loginIden = @"login";
                loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                UINavigationController *loginNa = [[UINavigationController alloc] initWithRootViewController:loginVC];
                [self presentViewController:loginNa animated:YES completion:nil];
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
    [self.naviView addSubview:_imageViewForLeft];
    [_imageViewForLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_top).with.offset(35);
        make.left.equalTo(self.naviView.mas_left).with.offset(13);
        make.height.mas_offset(RESIZE_UI(17));
        make.width.mas_offset(RESIZE_UI(100));
    }];
    
    _buttonForMess = [[UIButton alloc]init];
    [_buttonForMess setTitle:@"消息中心" forState:UIControlStateNormal];
    _buttonForMess.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    [_buttonForMess setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
    [_buttonForMess addTarget:self action:@selector(messageBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:_buttonForMess];
    [_buttonForMess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviView.mas_top).with.offset(38);
        make.right.equalTo(self.naviView.mas_right).with.offset(-12);
        make.height.mas_offset(14);
    }];
    
}

- (void)setUpTableViewMethod {
    
    _homeTableView = [[UITableView alloc]init];
    _homeTableView.delegate = self;
    _homeTableView.dataSource = self;
    _homeTableView.bounces = NO;
    _homeTableView.showsVerticalScrollIndicator = NO;
    _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_homeTableView registerClass:[HomeTableViewCellFirst class] forCellReuseIdentifier:@"HomeTableViewCellFirst"];
    [_homeTableView registerClass:[HomeTableViewCellSecond class] forCellReuseIdentifier:@"HomeTableViewCellSecond"];
    [_homeTableView registerClass:[HomeTableViewCellThird class] forCellReuseIdentifier:@"HomeTableViewCellThird"];
    
    [self.view addSubview:_homeTableView];
    [_homeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(-20);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-48);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return _arrayForRecommendPro.count;
    } else {
        return 2;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    } else if (section == 1) {
        return 12;
    } else {
        return 32;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *viewForHeader = [[UIView alloc]init];
    viewForHeader.backgroundColor = RGBA(239, 239, 239, 1.0);
    
    if (section == 2) {
        UILabel *labelForLine = [[UILabel alloc]init];
        labelForLine.backgroundColor = RGBA(255, 82, 37, 1.0);
        [viewForHeader addSubview:labelForLine];
        [labelForLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewForHeader.mas_centerY);
            make.left.equalTo(viewForHeader.mas_left);
            make.height.mas_offset(17);
            make.width.mas_offset(5);
        }];
        
        UILabel *labelForTitle = [[UILabel alloc]init];
        labelForTitle.text = @"旺马优选";
        labelForTitle.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        labelForTitle.textColor = RGBA(153, 153, 153, 1.0);
        [viewForHeader addSubview:labelForTitle];
        [labelForTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewForHeader.mas_centerY);
            make.left.equalTo(viewForHeader.mas_left).with.offset(13);
        }];
        
    } else if (section == 3) {
        UILabel *labelForLine = [[UILabel alloc]init];
        labelForLine.backgroundColor = RGBA(255, 82, 37, 1.0);
        [viewForHeader addSubview:labelForLine];
        [labelForLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewForHeader.mas_centerY);
            make.left.equalTo(viewForHeader.mas_left);
            make.height.mas_offset(17);
            make.width.mas_offset(5);
        }];
        
        UILabel *labelForTitle = [[UILabel alloc]init];
        labelForTitle.text = @"行业头条";
        labelForTitle.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        labelForTitle.textColor = RGBA(153, 153, 153, 1.0);
        [viewForHeader addSubview:labelForTitle];
        [labelForTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(viewForHeader.mas_centerY);
            make.left.equalTo(viewForHeader.mas_left).with.offset(13);
        }];
    }
    
    return viewForHeader;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        CGFloat height = RESIZE_UI(202);
        return height;
    } else if (indexPath.section == 1) {
        CGFloat height = RESIZE_UI(109);
        return height;
    } else if (indexPath.section == 2) {
        if (indexPath.row == _arrayForRecommendPro.count-1) {
            return RESIZE_UI(120);
        } else {
            return RESIZE_UI(134);
        }
    } else {
        return RESIZE_UI(90);
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        
        HomeTableViewCellFirst *cell = [[HomeTableViewCellFirst alloc]initWithDic:_personInvestModel];
        cell.learnWangma = ^(){
            [self jumpToAdWebView:@"新浪资金托管平台" WebUrl:@"https://pay.sina.com.cn/zjtg"];
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
        cell.cycleImage = ^(ImgHomeModel *imgModel) {
            NSString *productId = imgModel.product_id;
            NSString *url = imgModel.url;
            productId = [self convertNullString:productId];
            url = [self convertNullString:url];
            if ([url isEqualToString:@""] && [productId isEqualToString:@""]) {
                return;
            }
            if (![url isEqualToString:@""]) {
                AgViewController *agVC =[[AgViewController alloc] init];
                agVC.title = imgModel.title;
                agVC.webUrl = url;
                BaseNavigationController *baseNa = [[BaseNavigationController alloc] initWithRootViewController:agVC];
                [self presentViewController:baseNa animated:YES completion:^{
                }];
                return;
            }
            if (![productId isEqualToString:@""]) {
                ProductIntroViewController *proIntroVC = [[ProductIntroViewController alloc] init];
                proIntroVC.getPro_id = productId;
                [self.navigationController pushViewController:proIntroVC animated:YES];
                return;
            }
        };
        return cell;
        
    } else if (indexPath.section == 2) {
        HomeTableViewCellThird *cell = [[HomeTableViewCellThird alloc]init];
        [cell configCellWithModel:_arrayForRecommendPro[indexPath.row]];
        return cell;
    } else {
        HomeTableViewCellForth *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCellForth"];
        if (cell == nil) {
            NSBundle *bundle = [NSBundle mainBundle];
            NSArray *NibArray = [bundle loadNibNamed:@"HomeTableViewCellForth" owner:self options:nil];
            cell = (HomeTableViewCellForth *)[NibArray objectAtIndex:0];
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        NewsModel *newsModel = _arrayForNewsList[indexPath.row];
        [cell.imageViewNews sd_setImageWithURL:[NSURL URLWithString:newsModel.pic_url]];
        cell.labelForTitle.text = newsModel.title;
        cell.labelForInfo.text = newsModel.intro;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        ProductModel *productModel = _arrayForRecommendPro[indexPath.row];
        ProductIntroViewController *proIntroVC = [[ProductIntroViewController alloc] init];
        proIntroVC.getPro_id = productModel.proIntro_id;
        [self.navigationController pushViewController:proIntroVC animated:YES];
    }
    if (indexPath.section == 3) {
        
        NewsModel *newsModel = _arrayForNewsList[indexPath.row];
        AgViewController *agVC =[[AgViewController alloc] init];
        agVC.title = newsModel.title;
        agVC.htmlContent = newsModel.content;
        BaseNavigationController *baseNa = [[BaseNavigationController alloc] initWithRootViewController:agVC];
        [self presentViewController:baseNa animated:YES completion:^{
        }];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat alpha = (RESIZE_UI(scrollView.contentOffset.y)-RESIZE_UI(18)) / 100;
    if (alpha >= 1) {
        alpha = 1;
    }else if (alpha <= 0)
    {
        alpha = 0;
    }
    //self.naviView.backgroundColor = [RGBA(0, 104, 178, 1.0) colorWithAlphaComponent:alpha];
    self.naviView.backgroundColor = RGBA(0, 104, 178, alpha);
    _imageViewForLeft.alpha = alpha;
    if (alpha<0.05) {
        _buttonForMess.alpha = 0.05;
    }else {
        _buttonForMess.alpha = alpha;
    }
    
    CGFloat sectionHeaderHeight = -20;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }

}

- (void)jumpToAdWebView:(NSString *)title WebUrl:(NSString *)url{
    
    AgViewController *agVC =[[AgViewController alloc] init];
    agVC.title = title;
    agVC.webUrl = url;
    BaseNavigationController *baseNa = [[BaseNavigationController alloc] initWithRootViewController:agVC];
    [self presentViewController:baseNa animated:YES completion:^{
    }];
    
}

#pragma mark - 跳转到消息页面
- (void)messageBtnAction {
    MessageWViewController *messageVC = [[MessageWViewController alloc] initWithNibName:@"MessageWViewController" bundle:nil];
    [self.navigationController pushViewController:messageVC animated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
