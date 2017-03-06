//
//  ProductLongClassViewController.m
//  WmjrApp
//
//  Created by horry on 2017/2/21.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "ProductLongClassViewController.h"
#import "FixLongAdCell.h"
#import "ProductModel.h"
#import "LongProductSegment.h"
#import "ProductLongTopCell.h"
#import "HomeTableViewCellThirdFirst.h"
#import "LongProductDetailViewController.h"
#import "AgViewController.h"
#import "AdModel.h"
#import "BaseNavigationController.h"

@interface ProductLongClassViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *longProductTableView;
@property (nonatomic, strong)NSMutableArray *longProductArray;
@property (nonatomic, assign)NSInteger pageNum;
@property (nonatomic, strong)AdModel *adModel;

@end

@implementation ProductLongClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBA(239, 239, 239, 1.0);
    
    _longProductArray = [[NSMutableArray alloc]init];
    _longProductTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - RESIZE_UI(44) - 20 - 49-2) style:UITableViewStylePlain];
    _longProductTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _longProductTableView.delegate = self;
    _longProductTableView.dataSource = self;
    _longProductTableView.backgroundColor = RGBA(239, 239, 239, 1.0);
    [self.view addSubview:_longProductTableView];
    
    //下拉刷新
    _longProductTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNum = 1;
        [self getLongProductListMethod];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _longProductTableView.mj_header.automaticallyChangeAlpha = YES;
    _longProductTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageNum++;
        [self getLongProductListMethod];
    }];
    
    [self getAdMethod];
    
}

#pragma mark - 获取广告图
- (void)getAdMethod {
    
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"Ad/index" withParamDictionary:@{@"location":@"long"} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            
            NSArray *adArray = obj[@"data"];
            if (adArray.count>0) {
                _adModel = [AdModel mj_objectWithKeyValues:adArray[0]];
            }
            [self getLongProductListMethod];
            
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

#pragma mark - 获取长期产品
- (void)getLongProductListMethod {
    
    NetManager *manager = [[NetManager alloc] init];
    NSDictionary *paramDic = @{@"is_recommend":@"", @"page":@(_pageNum), @"size":@"",@"is_long":@"1"};
    [manager postDataWithUrlActionStr:@"Finance/index" withParamDictionary:paramDic withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            if (_pageNum == 1) {
                _longProductArray = [[NSMutableArray alloc]init];
            }
            [ProductModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"proIntro_id" : @"id"};
            }];
            [ProductModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{
                         @"segment":@"LongProductSegment"
                         };
            }];
            NSArray *longProArr = [ProductModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
            for (int i=0; i<longProArr.count; i++) {
                ProductModel *productModel = longProArr[i];
                [_longProductArray addObject:productModel];
            }
            
            [_longProductTableView reloadData];
            [_longProductTableView.mj_header endRefreshing];
            [_longProductTableView.mj_footer endRefreshing];
            
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _longProductArray.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return RESIZE_UI(11);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = RGBA(239, 239, 239, 1.0);
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return RESIZE_UI(102);
    } else {
        if (indexPath.row == 0) {
            return RESIZE_UI(42);
        } else {
            return RESIZE_UI(109);
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        FixLongAdCell *cell = [[FixLongAdCell alloc]initWithAdModel:_adModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        ProductModel *productModel = _longProductArray[indexPath.section-1];
        if (indexPath.row == 0) {
            ProductLongTopCell *cell = [[ProductLongTopCell alloc]initWithProductModel:productModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            HomeTableViewCellThirdFirst *cell = [[HomeTableViewCellThirdFirst alloc]initWithProductModel:productModel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        NSLog(@"点击广告");
        AgViewController *agVC =[[AgViewController alloc] init];
        agVC.title = _adModel.title;
        agVC.webUrl = _adModel.url;
        BaseNavigationController *baseNa = [[BaseNavigationController alloc] initWithRootViewController:agVC];
        [self presentViewController:baseNa animated:YES completion:^{
        }];
    } else {
        ProductModel *productModel = _longProductArray[indexPath.section-1];
        LongProductDetailViewController *newproductbuyVC = [[LongProductDetailViewController alloc]init];
        newproductbuyVC.productModel = productModel;
        newproductbuyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newproductbuyVC animated:YES];
    }
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
