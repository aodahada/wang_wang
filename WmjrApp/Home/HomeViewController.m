//
//  HomeViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/6/17.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "HomeViewController.h"
#import "SDCycleScrollView.h"
#import "ProductListViewController.h"
#import "MyselfPrivilegeStandardController.h"
#import "LoginViewController.h"
#import "HomeModel.h"
#import "ProductIntroViewController.h"
#import "HomeListViewCell.h"
#import "AgViewController.h"
#import "BaseNavigationController.h"
#import "AliGesturePasswordViewController.h"
#import "ViewForProductCategory.h"
#import "HomeProductCatModel.h"
#import "ViewForScrollClass.h"

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    
    UIButton *_sevenHappyBtn;/*  七天乐 */
    UIButton *_stabilityInterestBtn;/* 稳收息 */
    UIButton *_silverTenpayBtn;/* 银付通 */
    
    NSInteger _selectIndex;
    
}

@property (nonatomic, strong) NSMutableArray *arrayForTypeName;

@property (nonatomic, strong) UILabel *labelForSeven;
@property (nonatomic, strong) UILabel *labelForWen;
@property (nonatomic, strong) UILabel *labelForYin;

@property (nonatomic, strong) NSMutableArray *arrayForImageModel;

@end

@implementation HomeViewController

/*  去掉导航条边线 */
- (void)setUpNavigationBar {
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"home_navibar_color"] forBarMetrics:(UIBarMetricsDefault)];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navi_bar"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationBar];
    
    [SingletonManager sharedManager].isProductListViewWillAppear = 1;
    
    /*  */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomeView) name:GETHOMEVIEWDATANOTIFICATION object:nil];
    
    /*  列表展示 */
    _dataSource = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[HomeListViewCell class] forCellReuseIdentifier:@"cell"];

    
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
    
    //产品列表分类
    [self getProductListTypeClass];
    //看看是不是最新版本
    [self getNewVersionMethod];
    
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    BOOL isNull = [self isNullString:uid];
    if (!isNull) {
        [self getDataWithLogin];
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

#pragma mark - 获取最新版本号
- (void)getNewVersionMethod {
    
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Public/update" withParamDictionary:@{@"platform":@"ios"} withBlock:^(id obj) {
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                
                NSString *app_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                
                NSDictionary *dicForMes = obj[@"data"];
                NSString *newVersion = dicForMes[@"version"];
                if (![newVersion isEqualToString:app_version]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您当前的版本不是最新版本" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                    [alert show];
                    [SVProgressHUD dismiss];
                } else {
//                    [SVProgressHUD showInfoWithStatus:@"已经是最新版本!"];
                }
                
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/wang-ma-cai-fu/id1071502298?l=zh&ls=1&mt=8"]];
    }
    
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

#pragma mark - 获取分类
- (void)getProductTypeClass {
    
    NetManager *manager = [[NetManager alloc] init];
//    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Product/type" withParamDictionary:@{@"mobile":@"as"} withBlock:^(id obj) {
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                NSArray *dataDic = obj[@"data"];
                _arrayForTypeName = [[NSMutableArray alloc]init];
                for (int i=0; i<dataDic.count; i++) {
                    NSDictionary *dic = dataDic[i];
                    HomeProductCatModel *homeProModel = [HomeProductCatModel mj_objectWithKeyValues:dic];
                    [_arrayForTypeName addObject:homeProModel];
                }
                
                /*  刷新列表 */
                [[NSNotificationCenter defaultCenter] postNotificationName:GETHOMEVIEWDATANOTIFICATION object:nil];
                
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
                [SVProgressHUD dismiss];
            }
        }
    }];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)refreshHomeView {
    [_tableView reloadData];
    _tableView.tableHeaderView = [self configHeadView];
    UIView *aView = [_tableView.tableHeaderView viewWithTag:2015];
    /*  轮播图 */
    [aView addSubview:[self setUpShufflingFigure]];
}

/*  设置 轮播图 和 跳转按钮  */
- (UIView *)configHeadView {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, RESIZE_UI(300))];
    aView.tag = 2015;
    aView.backgroundColor = VIEWBACKCOLOR;
    
    
    ViewForScrollClass *viewForClass = [[ViewForScrollClass alloc]initWithArray:_arrayForTypeName];
    viewForClass.jumToMessPage = ^(HomeProductCatModel *productModel) {
        
        NSString *idStr = productModel.id;
        [SingletonManager sharedManager].isJumpGun = 2;
        [SingletonManager sharedManager].whichOneTypeIsSelected = [idStr integerValue];
        [SingletonManager sharedManager].currentBGTopSliderNum = 1;
        self.navigationController.tabBarController.selectedIndex = 1;
        
    };
    [aView addSubview:viewForClass];
    [viewForClass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aView.mas_top).with.offset(RESIZE_UI(180));
        make.left.equalTo(aView.mas_left);
        make.right.equalTo(aView.mas_right);
        make.bottom.equalTo(aView.mas_bottom);
    }];
    
    return aView;
}

/*  轮播图 */
- (UIView *)setUpShufflingFigure {
    HomeModel *model = [_dataSource firstObject];
    /*  获取头视图中轮播图片 */
    NSMutableArray *imgArray = [NSMutableArray array];
    _arrayForImageModel = [[NSMutableArray alloc]init];
    for (ImgHomeModel *imgModel in model.topadArray) {
        [imgArray addObject:imgModel.picurl];
        [_arrayForImageModel addObject:imgModel];
    }
    NSArray *imagesURLStrings = imgArray;
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, RESIZE_UI(180)) imageURLStringsGroup:nil]; // 模拟网络延时情景
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView2.delegate = self;
    cycleScrollView2.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    cycleScrollView2.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView2.placeholderImage = [UIImage imageNamed:@"placeholder"];
    //             --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    });

    return cycleScrollView2;
}

- (void)sendToIndexFrom:(ToIndexBlock)block {
    self.block = block;
}

//特权标
- (void)clickPrivilegeStandardAction {
    MyselfPrivilegeStandardController *myselfPriVC = [[MyselfPrivilegeStandardController alloc] init];
    [self.navigationController pushViewController:myselfPriVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - UITableView dataSource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HomeModel *model = [_dataSource firstObject];
    return model.adArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeModel *model = [_dataSource firstObject];
    /* 广告图 */
    ImgHomeModel *adModel = [model.adArray objectAtIndex:indexPath.row];
    HomeListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = adModel;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RESIZE_UI(230);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击进入产品详情页－－－－－
    HomeModel *model = [_dataSource firstObject];
    ImgHomeModel *adModel = [model.adArray objectAtIndex:indexPath.row];
    ProductIntroViewController *proIntroVC = [[ProductIntroViewController alloc] init];
    proIntroVC.getPro_id = adModel.product_id;

    [self.navigationController pushViewController:proIntroVC animated:YES];
}

#pragma mark - 数据处理 －
- (void)getDataWithNetManager {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Home/index" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if (obj) {
            HomeModel *homeModel = [[HomeModel alloc] init];
            [homeModel setValuesForKeysWithDictionary:obj[@"data"]];
            [_dataSource addObject:homeModel];
//            [SVProgressHUD dismiss];
            [self getProductTypeClass];
        }
        
    }];
}

#pragma mark 轮播图
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    ImgHomeModel *imgModel = _arrayForImageModel[index];
    NSString *productId = imgModel.product_id;
    NSString *url = imgModel.url;
    productId = [self convertNullString:productId];
    url = [self convertNullString:url];
    if ([url isEqualToString:@""] && [productId isEqualToString:@""]) {
        return;
    }
    if ([url isEqualToString:@""]) {
        ProductIntroViewController *proIntroVC = [[ProductIntroViewController alloc] init];
        proIntroVC.getPro_id = productId;
        [self.navigationController pushViewController:proIntroVC animated:YES];
        return;
    }
    if ([productId isEqualToString:@""]) {
        AgViewController *agVC =[[AgViewController alloc] init];
        agVC.title = imgModel.title;
        agVC.webUrl = url;
        BaseNavigationController *baseNa = [[BaseNavigationController alloc] initWithRootViewController:agVC];
        [self presentViewController:baseNa animated:YES completion:^{
        }];
        return;
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
