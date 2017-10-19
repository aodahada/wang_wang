//
//  AddressListViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/10/17.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressTableViewCell.h"
#import "AddAddressViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "IntegralAddressModel.h"

@interface AddressListViewController ()<UITableViewDelegate,UITableViewDataSource,AddressCellDalegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *addressListArray;

@end

@implementation AddressListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAddressList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收货地址";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *addAddressButton = [[UIButton alloc]init];
    [addAddressButton setBackgroundColor:RGBA(255, 84, 34, 1.0)];
    [addAddressButton setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [addAddressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addAddressButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(RESIZE_UI(17))];
    [addAddressButton addTarget:self action:@selector(addAddressMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addAddressButton];
    [addAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(RESIZE_UI(49));
    }];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(addAddressButton.mas_top);
    }];
    
}

#pragma mark - 获取地址列表
- (void)getAddressList {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    //[SingletonManager sharedManager].uid
    [manager postDataWithUrlActionStr:@"Address/my" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSArray *addressArray = obj[@"data"];
            _addressListArray = [[NSMutableArray alloc]init];
            for (int i=0; i<addressArray.count; i++) {
                NSDictionary *dic = addressArray[i];
                IntegralAddressModel *integralAddressModel = [IntegralAddressModel mj_objectWithKeyValues:dic];
                [_addressListArray addObject:integralAddressModel];
            }
            [self.tableView reloadData];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _addressListArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return RESIZE_UI(12);
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return RESIZE_UI(12);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = RGBA(238, 240, 242, 1.0);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RESIZE_UI(162);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressTableViewCell *cell = [[AddressTableViewCell alloc]initWithIntegralAddressModel:_addressListArray[indexPath.section]];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([self.isSelect isEqualToString:@"yes"]) {
//        IntegralAddressModel *integralAddrss = _addressListArray[indexPath.section];
//        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//        NSData *encodeInfo = [NSKeyedArchiver archivedDataWithRootObject:integralAddrss];
//        [userDefault setObject:encodeInfo forKey:@"integralAddrss"];
//        [userDefault synchronize];
//        [self.navigationController popViewControllerAnimated:YES];
//    } else {
        AddAddressViewController *addAddressVC = [[AddAddressViewController alloc]init];
        addAddressVC.integralAddressModel = _addressListArray[indexPath.section];
        [self.navigationController pushViewController:addAddressVC animated:YES];
//    }
    
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
////        AddressModel *model = _dataArray[indexPath.row];
////        [_dataArray removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
////        [self changeDefaultAddressWithAddressid:model.address_id withType:ChangeRequestTypeDelete withModel:model];
//    }
//}

//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}

- (void)addAddressMethod {
    AddAddressViewController *addAddressVC = [[AddAddressViewController alloc]init];
    [self.navigationController pushViewController:addAddressVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = RESIZE_UI(12);
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - 删除地址
- (void)deleteAddress:(IntegralAddressModel *)integralAddressModel {
    
    [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NetManager *manager = [[NetManager alloc] init];
            [SVProgressHUD showWithStatus:@"加载中"];
            [manager postDataWithUrlActionStr:@"Address/del" withParamDictionary:@{@"member_id":@"90222",@"address_id":integralAddressModel.id} withBlock:^(id obj) {
                if ([obj[@"result"] isEqualToString:@"1"]) {
                    [_addressListArray removeObject:integralAddressModel];
                    [self.tableView reloadData];
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
    } title:@"确定要删除该地址吗？" message:@"" cancelButtonName:@"取消" otherButtonTitles:@"确认", nil];
    
}

#pragma mark - 设置默认地址
- (void)setNormalAddress:(IntegralAddressModel *)integralAddressModel {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Address/edit" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid,@"address_id":integralAddressModel.id,@"is_default":@"1"} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            for (int i=0; i<_addressListArray.count; i++) {
                IntegralAddressModel *integralAddressModel = _addressListArray[i];
                integralAddressModel.is_default = @"0";
            }
            integralAddressModel.is_default = @"1";
            [self.tableView reloadData];
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

#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"image_zwhb-2"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无收货地址";
    
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
