//
//  IntegralConfirmViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/10/17.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "IntegralConfirmViewController.h"
#import "IntegralOrderTableViewCell.h"
#import "AddAddressViewController.h"
#import "AddressListViewController.h"
#import "IntegralProductDetailModel.h"
#import "IntegralAddressModel.h"
#import "AddressTableViewCell.h"

@interface IntegralConfirmViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *selectAddressView;//选择地址
@property (nonatomic, strong)NSMutableArray *addressArray;
@property (nonatomic, strong)IntegralAddressModel *defaultAddressModel;

@end

@implementation IntegralConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"兑换确认";
    self.view.backgroundColor = RGBA(238, 240, 242, 1.0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self getAddressList];
}

#pragma mark - 获取地址列表
- (void)getAddressList {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    //[SingletonManager sharedManager].uid
    [manager postDataWithUrlActionStr:@"Address/my" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid,@"is_default":@"1"} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            _addressArray = [[NSMutableArray alloc]init];
            NSArray *array = obj[@"data"];
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic = array[i];
                IntegralAddressModel *integralAddressModel = [IntegralAddressModel mj_objectWithKeyValues:dic];
                [_addressArray addObject:integralAddressModel];
            }
            if (_addressArray.count == 1) {
                _defaultAddressModel = _addressArray[0];
            }
            [self setUpViewDesign];
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

- (void)setUpViewDesign {
    UIButton *congfirmButton = [[UIButton alloc]init];
    [congfirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [congfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if ([_integralProductDetailModel.type_id isEqualToString:@"1"] && _addressArray.count == 0) {
        [congfirmButton setBackgroundColor:RGBA(202, 202, 202, 1.0)];
        [congfirmButton setUserInteractionEnabled:NO];
    } else {
        [congfirmButton setBackgroundColor:RGBA(255, 84, 34, 1.0)];
        [congfirmButton setUserInteractionEnabled:YES];
    }
    congfirmButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    [congfirmButton addTarget:self action:@selector(confirmOrderMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:congfirmButton];
    [congfirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_offset(RESIZE_UI(49));
    }];
    
    UIScrollView *mainScrollView = [[UIScrollView alloc]init];
    [self.view addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(congfirmButton.mas_top);
    }];
    
    UIView *mainView = [[UIView alloc]init];
    mainView.backgroundColor = RGBA(238, 240, 242, 1.0);
    [mainScrollView addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScrollView);
        make.width.equalTo(self.view.mas_width);
        make.height.mas_offset(1000);
    }];
    
    CGFloat height;
    if ([_integralProductDetailModel.type_id isEqualToString:@"1"] && _addressArray.count == 1) {
        height = RESIZE_UI(105)+1+RESIZE_UI(111.5);
    } else {
        height = RESIZE_UI(105);
    }
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [mainView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(height);
    }];
    
    if ([_integralProductDetailModel.type_id isEqualToString:@"1"] && _addressArray.count == 0) {
        //选择地址view
        self.selectAddressView = [[UIView alloc]init];
        self.selectAddressView.backgroundColor = [UIColor whiteColor];
        [mainView addSubview:self.selectAddressView];
        [self.selectAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_bottom).with.offset(1);
            make.left.equalTo(mainView.mas_left);
            make.right.equalTo(mainView.mas_right);
            make.height.mas_offset(RESIZE_UI(59));
        }];
        
        UIButton *selectAddressButton = [[UIButton alloc]init];
        [selectAddressButton setTitle:@"选择收货地址" forState:UIControlStateNormal];
        [selectAddressButton setTitleColor:RGBA(255, 84, 34, 1.0) forState:UIControlStateNormal];
        selectAddressButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(RESIZE_UI(14))];
        selectAddressButton.layer.borderWidth = 1.0f;
        selectAddressButton.layer.borderColor = RGBA(255, 84, 34, 1.0).CGColor;
        [selectAddressButton addTarget:self action:@selector(selectAddressMethod) forControlEvents:UIControlEventTouchUpInside];
        [self.selectAddressView addSubview:selectAddressButton];
        [selectAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.selectAddressView.mas_centerX);
            make.centerY.equalTo(self.selectAddressView.mas_centerY);
            make.height.mas_offset(RESIZE_UI(34));
            make.width.mas_offset(RESIZE_UI(182));
        }];
        
    }
    //点击选择地址保存在本地
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefault objectForKey:@"integralAddrss"];
    if (data) {
        _defaultAddressModel = (IntegralAddressModel *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self.tableView reloadData];
        [userDefault setObject:nil forKey:@"integralAddrss"];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_integralProductDetailModel.type_id isEqualToString:@"1"] && _addressArray.count == 1) {
        return 2;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = RGBA(238, 240, 242, 1.0);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([_integralProductDetailModel.type_id isEqualToString:@"1"] && _addressArray.count == 1) {
        if (indexPath.section == 0) {
            return RESIZE_UI(105);
        } else {
            return RESIZE_UI(111.5);
        }
    } else {
        return RESIZE_UI(105);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        IntegralOrderTableViewCell *cell = [[IntegralOrderTableViewCell alloc]initWithIntegralProductDetailModel:_integralProductDetailModel];
        return cell;
    } else {
        AddressTableViewCell *cell = [[AddressTableViewCell alloc] initWithIntegralAddressModel:_defaultAddressModel];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        AddressListViewController *addAdressListVC = [[AddressListViewController alloc]init];
        addAdressListVC.isSelect = @"yes";
        [self.navigationController pushViewController:addAdressListVC animated:YES];
    }
}

- (void)selectAddressMethod {
    AddressListViewController *addAdressListVC = [[AddressListViewController alloc]init];
    addAdressListVC.isSelect = @"yes";
    [self.navigationController pushViewController:addAdressListVC animated:YES];
}

#pragma mark - 确认订单
- (void)confirmOrderMethod {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"User/income" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            //            NSDictionary *dic = obj[@"data"];
            
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
