//
//  ExchangeRecordViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/10/19.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "ExchangeRecordViewController.h"
#import "IntegralOrderModel.h"
#import "IntegralAddressModel.h"
#import "DeliverInfoObject.h"
#import "IntegralOrderListCell.h"
#import "OrderDetailViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface ExchangeRecordViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *exchangeOrderArray;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ExchangeRecordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ExchangeRecordViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ExchangeRecordViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"兑换记录";
    self.view.backgroundColor = RGBA(238, 240, 242, 1.0);
    self.currentPage = 1;
    
    _exchangeOrderArray = [[NSMutableArray alloc]init];
    [self getExchangeRecordMethod];
    
}

#pragma mark - 获取兑换记录
- (void)getExchangeRecordMethod {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Goods/my" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid,@"page":@(self.currentPage)} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSArray *orderList = obj[@"data"];
            [IntegralOrderModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"receive_info" : [IntegralAddressModel class],
                         @"deliver_info" : [DeliverInfoObject class]};
            }];
            for (int i=0; i<orderList.count; i++) {
                NSDictionary *dic = orderList[i];
                IntegralOrderModel *integralOrderModel = [IntegralOrderModel mj_objectWithKeyValues:dic];
                [_exchangeOrderArray addObject:integralOrderModel];
            }
            self.tableView = [[UITableView alloc]init];
            self.tableView.backgroundColor = RGBA(238, 240, 242, 1.0);
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            self.tableView.emptyDataSetSource = self;
            self.tableView.emptyDataSetDelegate = self;
            self.tableView.tableFooterView = [[UIView alloc]init];
            [self.view addSubview:self.tableView];
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
            
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                self.currentPage ++;
                [self getExchangeRecordMethod];
            }];
            
            if (orderList.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return RESIZE_UI(12);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = RGBA(238, 240, 242, 1.0);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RESIZE_UI(150);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _exchangeOrderArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IntegralOrderListCell *cell = [[IntegralOrderListCell alloc]initWithIntegralOrderModel:_exchangeOrderArray[indexPath.section]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc]init];
    orderDetailVC.integralOrderModel = _exchangeOrderArray[indexPath.section];
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"image_zwhb-2"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无兑换记录";
    
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
