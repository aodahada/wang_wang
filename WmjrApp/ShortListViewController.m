//
//  ShortListViewController.m
//  WmjrApp
//
//  Created by horry on 2017/2/22.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "ShortListViewController.h"
#import "ProductModel.h"
#import "ShortListTopCell.h"
#import "HomeTableViewCellThird.h"
#import "ProductIntroViewController.h"

@interface ShortListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *shortProductArray;
@property (nonatomic, strong)UITableView *shortListTableView;
@property (assign, nonatomic)NSInteger pageNum;

@end

@implementation ShortListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(239, 239, 239, 1.0);
//    self.title = @"产品列表";
    _shortProductArray = [[NSMutableArray alloc]init];
    
    _shortListTableView = [[UITableView alloc]init];
    _shortListTableView.backgroundColor = RGBA(239, 239, 239, 1.0);
    _shortListTableView.tableFooterView = [[UIView alloc]init];
    _shortListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _shortListTableView.delegate = self;
    _shortListTableView.dataSource = self;
    [self.view addSubview:_shortListTableView];
    [_shortListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-2);
    }];
    
    //下拉刷新
    _shortListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _shortListTableView.mj_header.automaticallyChangeAlpha = YES;
    
    _shortListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    
    [self getShortProductListMethod];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpNavigationBar];
}

/* 设置导航条 */
- (void)setUpNavigationBar {
    
    /*  设置颜色 */
    self.navigationController.navigationBar.barTintColor = RGBA(0, 108, 175, 1.0);
    //    /*  设置字体颜色 */
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:VIEWBACKCOLOR};
    //    /* 渲染颜色 */
    self.navigationController.navigationBar.tintColor = RGBA(0, 108, 175, 1.0);
    
    /*  去掉边线 */
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"piggy"] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *image = [[UIImage imageNamed:@"arrow_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
}

- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取短期产品列表
- (void)getShortProductListMethod {
    
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
//    NSLog(@"我的id:%@",_type_id);
    NSDictionary *paramDic = @{@"type_id":_type_id, @"page":@(_pageNum),@"is_long":@"0"};
    [manager postDataWithUrlActionStr:@"Finance/index" withParamDictionary:paramDic withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            if (_pageNum == 1) {
                _shortProductArray = [[NSMutableArray alloc]init];
            }
            [ProductModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"proIntro_id" : @"id"};
            }];
            [ProductModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"segment":@"LongProductSegment"
                         };
            }];
            NSArray *productArray = obj[@"data"];
            for (int i=0; i<productArray.count; i++) {
                ProductModel *productModel = [ProductModel mj_objectWithKeyValues:productArray[i]];
                [_shortProductArray addObject:productModel];
            }
//            _shortProductArray = [ProductModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
            
            [_shortListTableView reloadData];
            [_shortListTableView.mj_header endRefreshing];
            [_shortListTableView.mj_footer endRefreshing];
            
            [SVProgressHUD dismiss];
            
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

// 刷新数据
- (void)refreshData
{
    _pageNum = 1;
    [self getShortProductListMethod];
}

// 加载更多数据
- (void)loadMoreData
{
    _pageNum++;
    [self getShortProductListMethod];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _shortProductArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return RESIZE_UI(42);
    } else {
        return RESIZE_UI(109);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = RGBA(239, 239, 239, 1.0);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductModel *productModel = _shortProductArray[indexPath.section];
    if (indexPath.row == 0) {
        ShortListTopCell *cell = [[ShortListTopCell alloc]initWithProductModel:productModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        HomeTableViewCellThird *cell = [[HomeTableViewCellThird alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithModel:_shortProductArray[indexPath.section]];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductModel *productModel = _shortProductArray[indexPath.section];
    ProductIntroViewController *productInfoVC = [[ProductIntroViewController alloc]init];
    productInfoVC.getPro_id = productModel.proIntro_id;
    [self.navigationController pushViewController:productInfoVC animated:YES];
}

#pragma mark - 去黏性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 11;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
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
