//
//  ProductClassViewController.m
//  WmjrApp
//
//  Created by horry on 16/9/6.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "ProductClassViewController.h"
#import "ProductViewCell.h"
#import "ProductLowViewCell.h"
#import "ProductModel.h"
#import "LoginViewController.h"
#import "MMPopupItem.h"
#import "MMPopupWindow.h"
#import "AddBankViewController.h"

@interface ProductClassViewController ()<UITableViewDataSource, UITableViewDelegate, ClickBtnResponseDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
}

@property (nonatomic, copy) NSString *isRealNameAuth;  /* 是否实名认证 */

/** 刷新判断*/
@property (assign, nonatomic) BOOL isRefresh;

@end

@implementation ProductClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//     初始化
    _isRefresh = NO;
    //    _isRealNameAuth = @"1";
    
    _dataSource = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - RESIZE_UI(44) - 20 - 49) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[ProductViewCell class] forCellReuseIdentifier:@"productCell"];
    
    /* 刷新 */
//    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
//    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    //下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    
    /*  请求数据 */
    [self getDataWithNetManager];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    NetManager *manager = [[NetManager alloc] init];
    //    [manager postDataWithUrlActionStr:@"User/que" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
    //        NSLog(@"%@", obj);
    //    }];
    
}

#pragma mark - 数据处理 －
- (void)getDataWithNetManager {
    [SVProgressHUD showWithStatus:@"加载中..." maskType:(SVProgressHUDMaskTypeBlack)];
    NSString *pageStr = [NSString stringWithFormat:@"%ld", (long)_pageNum];
    NetManager *manager = [[NetManager alloc] init];
//    NSLog(@"目前是哪个id：%@",_type_id);
//    NSLog(@"目前页数:%@",pageStr);
    NSDictionary *paramDic = @{@"type_id":_type_id, @"page":pageStr, @"size":@""};
    [manager postDataWithUrlActionStr:@"Product/new_index" withParamDictionary:paramDic withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [SVProgressHUD dismiss];
            NSMutableArray *array = [NSMutableArray array];
            [ProductModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"proIntro_id" : @"id"};
            }];
            array = [ProductModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
            for (int i=0; i<array.count; i++) {
                ProductModel *productModel = array[i];
                productModel.type_id = _type_id;
            }
            // 判断刷新和加载更多
            if(_isRefresh) {
                _dataSource = array;
                _isRefresh = NO;
            } else {
                [_dataSource  addObjectsFromArray:array];
            }
            [_tableView reloadData];
            [_tableView.mj_header endRefreshing];
            [_tableView.mj_footer endRefreshing];
        }
    }];
}

// 刷新数据
- (void)refreshData
{
    _isRefresh = YES;
    _pageNum = 1;
    [self getDataWithNetManager];
}

// 加载更多数据
- (void)loadMoreData
{
    _pageNum++;
    [self getDataWithNetManager];
}


#pragma mark - UITableView dataSource delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"1 === %ld", _dataSource.count);
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductModel *model = [_dataSource objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        ProductViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.indexpath = indexPath;
        [cell configCellWithModel:model];
        
        return cell;
    } else {
        static NSString *identifier = @"lowCell";
        ProductLowViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductLowViewCell" owner:nil options:nil] lastObject];
        }
        cell.model = model;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return RESIZE_UI(12);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return RESIZE_UI(.1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return RESIZE_UI(134);
    } else {
        return RESIZE_UI(33);
    }
}

/* 点击立即购买 */
- (void)buttonClickProductModel:(ProductModel *)productModel {
    
    if ([[self convertNullString:[SingletonManager sharedManager].uid] isEqualToString:@""]) {
        /* 未登录需登录 */
        [[NSNotificationCenter defaultCenter] postNotificationName:PRESENTLOGINVCNOTIFICATION object:nil];
    } else if ([[SingletonManager sharedManager].userModel.is_real_name isEqualToString:@"0"]) {
        [[MMPopupWindow sharedWindow] cacheWindow];
        MMPopupItemHandler block = ^(NSInteger index){
            if (index == 0) {
                return ;
            }
            if (index == 1) {
                /*  实名认证 */
                [[NSNotificationCenter defaultCenter]postNotificationName:PUSHREALNAMEAUTHVCNOTIFICATION object:nil];
            }
        };
        NSArray *items =
        @[MMItemMake(@"取消", MMItemTypeNormal, block),
          MMItemMake(@"确定", MMItemTypeNormal, block)];
        MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
                                                             detail:@"你还未认证,请实名认证"
                                                              items:items];
        [alertView show];
    } else if ([[SingletonManager sharedManager].userModel.card_id isEqualToString:@"0"]) {
        MMPopupItemHandler block = ^(NSInteger index){
            if (index == 0) {
                return ;
            }
            if (index == 1) {
                /*  绑定银行卡 */
                UIStoryboard *addbank = [UIStoryboard storyboardWithName:@"AddBankViewController" bundle:[NSBundle mainBundle]];
                AddBankViewController *addBankVC = [addbank instantiateViewControllerWithIdentifier:@"AddBank"];
                addBankVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:addBankVC animated:YES];
                return;
            }
        };
        NSArray *items =
        @[MMItemMake(@"取消", MMItemTypeNormal, block),
          MMItemMake(@"好的", MMItemTypeNormal, block)];
        MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
                                                             detail:@"您还没有绑定银行卡，请去绑定银行卡"
                                                              items:items];
        [alertView show];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:PUSHTOFUNDBUYVCNOTIFICATION object:productModel];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductModel *model = _dataSource[indexPath.section];
    /* 进入产品详情 */
    [[NSNotificationCenter defaultCenter] postNotificationName:PUSHPRODUCTINTROVCNOTIFICATION object:model];
}

@end
