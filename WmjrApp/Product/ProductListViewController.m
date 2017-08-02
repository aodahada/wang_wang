//
//  ProductListViewController.m
//  WmjrApp
//
//  Created by horry on 16/9/6.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "ProductListViewController.h"
#import "global.h"
#import "BGTopSilderBar.h"
#import "ProductClassViewController.h"
#import "ProductCategoryModel.h"

#import "ProductIntroViewController.h"
#import "ProductModel.h"
#import "LoginViewController.h"
#import "RealNameCertificationViewController.h"
//#import "MMPopupItem.h"
//#import "MMPopupWindow.h"
#import "HRBuyViewController.h"
#import "HomeProductCatModel.h"
#import "ProductLongClassViewController.h"

@interface ProductListViewController ()

@property(nonatomic,strong)BGTopSilderBar* silderBar;
//@property(nonatomic,weak)UICollectionView* collectView;
@property(nonatomic,strong)UIScrollView* scrollView;
@property(nonatomic,assign)int currentBarIndex;

@property (nonatomic, strong) NSMutableArray *arrayForTypeName;

@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.title = @"产品列表";
    
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    [self initScrollView];
    [self initSilderBar];//初始化顶部BGTopSilderBar
    
    //获取分类
    [self getProductTypeClass];
    
    /* 模态登录界面 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentVCAction) name:PRESENTLOGINVCNOTIFICATION object:nil];
    /* 实名认证 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushRealNameAuthVCAction) name:PUSHREALNAMEAUTHVCNOTIFICATION object:nil];
    /* 进入购买界面 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushFundBuyViewController:) name:PUSHTOFUNDBUYVCNOTIFICATION object:nil];
    /* 进入产品详情 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushProductIntroViewController:) name:PUSHPRODUCTINTROVCNOTIFICATION object:nil];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
//    self.navigationController.navigationBar.hidden = NO;
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ProductListViewController"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ProductListViewController"];
    if ([SingletonManager sharedManager].isProductListViewWillAppear != 1) {
        if ([SingletonManager sharedManager].isJumpGun == 2) {
            
            NSInteger productId = [SingletonManager sharedManager].whichOneTypeIsSelected;
            productId = productId-1;
            [_silderBar setItemColorFromIndex:0 to:productId];
            [SingletonManager sharedManager].isJumpGun = 0;
        }
    }
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - 获取分类
- (void)getProductTypeClass {
    
//    NetManager *manager = [[NetManager alloc] init];
//    [SVProgressHUD showWithStatus:@"加载中"];
//    [manager postDataWithUrlActionStr:@"Product/type" withParamDictionary:@{@"mobile":@"as"} withBlock:^(id obj) {
//        if (obj) {
//            if ([obj[@"result"] isEqualToString:@"1"]) {
//                NSArray *dataDic = obj[@"data"];
//                _arrayForTypeName = [[NSMutableArray alloc]init];
//                for (int i=0; i<dataDic.count; i++) {
//                    NSDictionary *dic = dataDic[i];
//                    ProductCategoryModel *productCategoryModel = [ProductCategoryModel mj_objectWithKeyValues:dic];
//                    [_arrayForTypeName addObject:productCategoryModel];
//                }
                ProductCategoryModel *productCategoryModel1 = [[ProductCategoryModel alloc]init];
                productCategoryModel1.name = @"定期投";
                ProductCategoryModel *productCategoryModel2 = [[ProductCategoryModel alloc]init];
                productCategoryModel2.name = @"旺马长存";
                _arrayForTypeName = [[NSMutableArray alloc]initWithArray:@[productCategoryModel1,productCategoryModel2]];
                _silderBar.arrayForCategory = _arrayForTypeName;
    
                [self addChildViewController];
                
                [SingletonManager sharedManager].isProductListViewWillAppear = 2;
//                NSInteger row = [SingletonManager sharedManager].isJumpGun;
                if ([SingletonManager sharedManager].isJumpGun == 2) {
                    
                    NSInteger productId = [SingletonManager sharedManager].whichOneTypeIsSelected;
                    productId = productId-1;
                    [_silderBar setItemColorFromIndex:0 to:productId];
                    [SingletonManager sharedManager].isJumpGun = 0;
                }

                
//                [SVProgressHUD dismiss];
//                
//                return ;
//            }
//            if ([obj[@"result"] isEqualToString:@"1000"]) {
//                NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
//                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
//                alertConfig.defaultTextOK = @"确定";
//                [SVProgressHUD dismiss];
//                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
//                [alertView show];
//            }
//        }
//    }];
    
}

/**
 初始化BGTopSilderBar
 */
-(void)initSilderBar{
     _silderBar = [[BGTopSilderBar alloc] init];
    //silder.contentCollectionView = _collectView;//_collectView必须要在前面初始化,不然这里值为nil
    _silderBar.contentCollectionView = _scrollView;//_scrollView必须要在前面初始化,不然这里值为nil
    [self.view addSubview:_silderBar];
    [_silderBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(RESIZE_UI(44)+20);
    }];
}

/**
 初始化UIScrollView
 */
-(void)initScrollView{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = RGBA(239, 239, 239, 1.0);
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(RESIZE_UI(44));
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    NSInteger count = [SingletonManager sharedManager].productListCount;
    //contentSize的宽度等于顶部滑动栏的item个数乘与屏幕宽度screenW
    _scrollView.contentSize = CGSizeMake(2*screenW,_scrollView.frame.size.height);
}


/**
 添加子控制器
 */
-(void)addChildViewController{
//    NSInteger count = _arrayForTypeName.count;
    ProductClassViewController *shortCon = [[ProductClassViewController alloc] init];
    shortCon.pageNum = 1;
    [self addChildViewController:shortCon];
    shortCon.view.frame = CGRectMake(0*screenW,0,screenW,_scrollView.frame.size.height);
    [_scrollView addSubview:shortCon.view];
    
    ProductLongClassViewController *longCon = [[ProductLongClassViewController alloc]init];
    [self addChildViewController:longCon];
    longCon.view.frame = CGRectMake(screenW,0,screenW,_scrollView.frame.size.height);
    [_scrollView addSubview:longCon.view];
}


/* 进入产品详情 */
- (void)pushProductIntroViewController:(NSNotification *)notifi {
    ProductIntroViewController *productIntroVC = [[ProductIntroViewController alloc] init];
    ProductModel *model = notifi.object;
    productIntroVC.getPro_id = model.proIntro_id;
    productIntroVC.type_id = model.type_id;
    productIntroVC.title = model.name;
    [self.navigationController pushViewController:productIntroVC animated:YES];
}

/* 进入购买页面 */
- (void)pushFundBuyViewController:(NSNotification *)noti {
    HRBuyViewController *fundBuyVC = [[HRBuyViewController alloc] initWithNibName:@"HRBuyViewController" bundle:nil];
    ProductModel *productModel = noti.object;
    fundBuyVC.productModel = productModel;
    [self.navigationController pushViewController:fundBuyVC animated:YES];
}

/* 实名认证 */
- (void)pushRealNameAuthVCAction {
    RealNameCertificationViewController *realNameAuth = [[RealNameCertificationViewController alloc] init];
    realNameAuth.isShowAlert = YES;
    realNameAuth.block = ^() {
        MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
        alertConfig.defaultTextOK = @"好的";
        MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"请前往个人界面绑定银行卡" detail:nil];
        [alertView show];
        return;
    };
    [self.navigationController pushViewController:realNameAuth animated:YES];
}

/* 模态出现登录页面 */
- (void)presentVCAction {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *loginNa = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNa animated:YES completion:nil];
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
