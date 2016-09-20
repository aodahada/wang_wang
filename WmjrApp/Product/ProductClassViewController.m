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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - RESIZE_UI(40) - 64 - 49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[ProductViewCell class] forCellReuseIdentifier:@"productCell"];
    
    /* 刷新 */
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    /*  请求数据 */
    [self getDataWithNetManager];
  
//    UILabel *label = [[UILabel alloc]init];
//    label.text = @"哈哈哈";
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:25];
//    [self.view addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//////        make.left.equalTo(self.view.mas_left);
////        make.centerX.equalTo(self.view.mas_centerX);
////        make.top.equalTo(self.view.mas_top);
//    }];
    
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
        }
    }];
}

// 刷新数据
- (void)refreshData
{
    _isRefresh = YES;
    _pageNum = 1;
    [self getDataWithNetManager];
    [_tableView.mj_header endRefreshing];
}

// 加载更多数据
- (void)loadMoreData
{
    _pageNum++;
    [self getDataWithNetManager];
    [_tableView.mj_footer endRefreshing];
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
    return RESIZE_UI(5);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return RESIZE_UI(.1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 134;
    } else {
        return 33;
    }
}

/* 点击立即购买 */
- (void)buttonClickProductModel:(ProductModel *)productModel {
    
    if ([[SingletonManager sharedManager].uid isEqualToString:@""]) {
        /* 未登录需登录 */
        [[NSNotificationCenter defaultCenter] postNotificationName:PRESENTLOGINVCNOTIFICATION object:nil];
    } else{
        [[NSNotificationCenter defaultCenter] postNotificationName:PUSHTOFUNDBUYVCNOTIFICATION object:productModel];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductModel *model = _dataSource[indexPath.section];
    /* 进入产品详情 */
    [[NSNotificationCenter defaultCenter] postNotificationName:PUSHPRODUCTINTROVCNOTIFICATION object:model];
}

@end
