//
//  PrivilegeStandardViewController.m
//  wangmajinrong
//
//  Created by 1 & 0 on 15/6/25.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "MyselfPrivilegeStandardController.h"
#import "BuyPrivilViewController.h"
#import "PopMenu.h"
#import "PopView.h"
#import "BuyPriviTableCell.h"
#import "LoginViewController.h"
#import "MMPopupItem.h"
#import "MMPopupWindow.h"
#import "GoldModel.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "RealNameCertificationViewController.h"

@interface MyselfPrivilegeStandardController () <UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
{
    PopMenu *_popMenu;
}

@property (weak, nonatomic) IBOutlet UIButton *buyPriviBtn;//购买特权标
- (IBAction)buyPriviBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *buyPriviTable; /* 历史购买列表 */

@property (nonatomic, strong) NSMutableArray *goldArray;
/** 刷新判断*/
@property (assign, nonatomic) BOOL isRefresh;
/** 页数*/
@property (assign, nonatomic) NSInteger pageNum;

@end

@implementation MyselfPrivilegeStandardController

/* 设置导航条 */
- (void)configNavigationBar {
    self.title = @"我的红包";
    self.view.backgroundColor = VIEWBACKCOLOR;
//    self.colorView.backgroundColor = BASECOLOR;
    _availablePriviGold.textColor = VIEWBACKCOLOR;
    _getPriviGold.textColor = VIEWBACKCOLOR;
    _buyPriviBtn.backgroundColor = BASECOLOR;
    _buyPriviBtn.layer.cornerRadius = 5;
    _buyPriviBtn.layer.masksToBounds = YES;
    [[MMPopupWindow sharedWindow] cacheWindow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    // 初始化
    _isRefresh = NO;
    _pageNum = 1;
    _goldArray = [NSMutableArray array];
    
    _buyPriviTable.delegate = self;
    _buyPriviTable.dataSource = self;
    _buyPriviTable.emptyDataSetSource = self;
    _buyPriviTable.emptyDataSetDelegate = self;
    _buyPriviTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_buyPriviTable registerNib:[UINib nibWithNibName:@"BuyPriviTableCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    /* 刷新 */
    _buyPriviTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    _buyPriviTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    /*  请求数据 */
    [self getDataWithNetManager];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - 数据处理 －
- (void)getDataWithNetManager {
    [SVProgressHUD showWithStatus:@"加载中"];
    NetManager *manager = [[NetManager alloc] init];
    NSString *pageStr = [NSString stringWithFormat:@"%ld", (long)_pageNum];
    NSString *uid = [SingletonManager sharedManager].uid;
    [manager postDataWithUrlActionStr:@"Gift/lists" withParamDictionary:@{@"member_id":uid, @"page":pageStr, @"size":@""} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSMutableArray *array = [NSMutableArray array];
            NSArray *arrayForEnvelop = obj[@"data"];
            for (int i=0; i<arrayForEnvelop.count; i++) {
                NSDictionary *dicForEnvelop = arrayForEnvelop[i];
                GoldModel *goldModel = [GoldModel mj_objectWithKeyValues:dicForEnvelop];
                [array addObject:goldModel];
            }
            if (obj) {
                [SVProgressHUD dismiss];
                // 判断刷新和加载更多
                if(_isRefresh) {
                    _goldArray = array;
                    _isRefresh = NO;
                } else {
                    [_goldArray  addObjectsFromArray:array];
                }
                [_buyPriviTable reloadData];
            }
        }
    }];
}

// 刷新数据
- (void)refreshData
{
    _isRefresh = YES;
    _pageNum = 1;
    [self getDataWithNetManager];
    [_buyPriviTable.mj_header endRefreshing];
}

// 加载更多数据
- (void)loadMoreData
{
    _pageNum++;
    [self getDataWithNetManager];
    [_buyPriviTable.mj_footer endRefreshing];
}

///* 了解特权金 */
//- (IBAction)priviGoldIntroBtnAction:(id)sender {
//    
//    _popMenu = [[PopMenu alloc] init];
//    _popMenu.dimBackground = YES;
//    _popMenu.coverNavigationBar = YES;
//    PopView *popView = [[PopView alloc] initWithFrame:RESIZE_FRAME(CGRectMake(35, 200, 305, 100))];
//    [_popMenu addSubview:popView];
//    popView.layer.cornerRadius = 5;
//    popView.layer.masksToBounds = YES;
//    popView.introLable1.text = @"特权金是旺马送给你的虚拟本";
//    popView.introLable2.text = @"特权金理财标年化率：10%，七天收益收到手";
//    [_popMenu showInRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopMenuAction)];
//    [_popMenu addGestureRecognizer:tap];
//}
//
///* 增加特权金 */
//- (IBAction)priviGoldAddBtnAction:(id)sender {
//    _popMenu = [[PopMenu alloc] init];
//    _popMenu.dimBackground = YES;
//    _popMenu.coverNavigationBar = YES;
//    PopView *popView = [[PopView alloc] initWithFrame:RESIZE_FRAME(CGRectMake(35, 200, 305, 100))];
//    [_popMenu addSubview:popView];
//    popView.layer.cornerRadius = 5;
//    popView.layer.masksToBounds = YES;
//    popView.introLable1.text = @"注册／邀请好友时赠送";
//    popView.introLable2.text = @"注册获得2000.邀请好友获得2000";
//    [_popMenu showInRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopMenuAction)];
//    [_popMenu addGestureRecognizer:tap];
//}

- (void)dismissPopMenuAction {
    [_popMenu dismissMenu];
}

/* 购买特权标 */
- (IBAction)buyPriviBtnAction:(id)sender {
//    if ([[SingletonManager sharedManager].isRealName isEqualToString:@"0"]) {
//        [[MMPopupWindow sharedWindow] cacheWindow];
//        MMPopupItemHandler block = ^(NSInteger index){
//            if (index == 0) {
//                return ;
//            }
//            if (index == 1) {
//                /*  实名认证 */
//                RealNameCertificationViewController *realNameAuth = [[RealNameCertificationViewController alloc] init];
//                [self.navigationController pushViewController:realNameAuth animated:YES];
//            }
//        };
//        NSArray *items =
//        @[MMItemMake(@"取消", MMItemTypeNormal, block),
//          MMItemMake(@"确定", MMItemTypeNormal, block)];
//        MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
//                                                             detail:@"你还未认证,请实名认证"
//                                                              items:items];
//        [alertView show];
//    } else {
//        /* 购买特权标 */
//        BuyPrivilViewController *buyPriviVC = [[BuyPrivilViewController alloc] init];
//        buyPriviVC.sep_idStr = @"1";
//        buyPriviVC.sep_nameStr = @"特别旺马";
//        buyPriviVC.availableStr = _availablePriviGold.text;
//        [self.navigationController pushViewController:buyPriviVC animated:YES];
//    }
    [self.navigationController popViewControllerAnimated:YES];
    [self.tabBarController setSelectedIndex:1];
}

#pragma mark - uitableView -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _goldArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoldModel *model = _goldArray[indexPath.row];
    BuyPriviTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.96f alpha:1.00f];
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return nil;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您没有红包";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
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
