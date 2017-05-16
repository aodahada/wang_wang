//
//  ProductClassViewController.m
//  WmjrApp
//
//  Created by horry on 16/9/6.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "ProductClassViewController.h"
#import "ProductModel.h"
#import "HomeTableViewCellThird.h"
#import "ProductCategoryTopCell.h"
#import "FixShortAdCell.h"
#import "ProductCategoryTopCell.h"
#import "ProductCategoryModel.h"
#import "ShortListViewController.h"
#import "ProductIntroViewController.h"
#import "AgViewController.h"
#import "AdModel.h"
#import "BaseNavigationController.h"

@interface ProductClassViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *categoryTableView;
@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, strong) AdModel *adModel;//广告图

@end

@implementation ProductClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBA(239, 239, 239, 1.0);
    
    [self getAdMethod];
    
}

#pragma mark - 获取广告图
- (void)getAdMethod {
    
    [SVProgressHUD showWithStatus:@"加载中"];
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"Ad/index" withParamDictionary:@{@"location":@"short"} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            
            NSArray *adArray = obj[@"data"];
            if (adArray.count>0) {
                _adModel = [AdModel mj_objectWithKeyValues:adArray[0]];
            }
            [self getProductTypeMethod];
            
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

#pragma mark - 获取产品类型
- (void)getProductTypeMethod {
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"Finance/type" withParamDictionary:@{@"12":@"23"} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [ProductCategoryModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"product":@"ProductModel"};
            }];
            _categoryArray = [[NSMutableArray alloc]init];
            _categoryArray = [ProductCategoryModel mj_objectArrayWithKeyValuesArray:obj[@"data"]];
            
            _categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - RESIZE_UI(44) - 20 - 49-2) style:UITableViewStylePlain];
            _categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _categoryTableView.backgroundColor = RGBA(239, 239, 239, 1.0);
            _categoryTableView.delegate = self;
            _categoryTableView.dataSource = self;
            [self.view addSubview:_categoryTableView];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _categoryArray.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return RESIZE_UI(102);
    } else{
        if (indexPath.row == 0) {
            return RESIZE_UI(42);
        } else {
            return RESIZE_UI(109);
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        ProductCategoryModel *pcModel =  _categoryArray[section-1];
        NSArray *productArray = pcModel.product;
        return productArray.count+1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = RGBA(239, 239, 239, 1.0);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return RESIZE_UI(12);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        FixShortAdCell *cell = [[FixShortAdCell alloc]initWithAdModel:_adModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        ProductCategoryModel *productCategory = _categoryArray[indexPath.section-1];
        if (indexPath.row == 0) {
            ProductCategoryTopCell *cell = [[ProductCategoryTopCell alloc]initWithProductCategoryModel:productCategory];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            HomeTableViewCellThird *cell = [[HomeTableViewCellThird alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *productList = productCategory.product;
            [cell configCellWithModel:productList[indexPath.row-1]];
            return cell;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
//        NSLog(@"点击广告图");
        AgViewController *agVC =[[AgViewController alloc] init];
        agVC.title = _adModel.title;
        agVC.webUrl = _adModel.url;
        BaseNavigationController *baseNa = [[BaseNavigationController alloc] initWithRootViewController:agVC];
        [self presentViewController:baseNa animated:YES completion:^{
        }];
    } else {
        ProductCategoryModel *productCategory = _categoryArray[indexPath.section-1];
        if (indexPath.row == 0) {
            ShortListViewController *shortList = [[ShortListViewController alloc]init];
            shortList.hidesBottomBarWhenPushed = YES;
            shortList.type_id = productCategory.id;
            shortList.title = productCategory.name;
            [self.navigationController pushViewController:shortList animated:YES];
        } else {
            NSArray *productArray = productCategory.product;
            ProductModel *productModel = productArray[indexPath.row-1];
            ProductIntroViewController *productInfoVC = [[ProductIntroViewController alloc]init];
            productInfoVC.getPro_id = productModel.proIntro_id;
            productInfoVC.title = productModel.name;
            productInfoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:productInfoVC animated:YES];
        }
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

@end
