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
#import "ExchangeRecordViewController.h"

@interface IntegralConfirmViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *selectAddressView;//选择地址
@property (nonatomic, strong)NSMutableArray *addressArray;
@property (nonatomic, strong)IntegralAddressModel *defaultAddressModel;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIImageView *rightImage;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation IntegralConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"兑换确认";
    self.view.backgroundColor = RGBA(238, 240, 242, 1.0);
    self.window = [[UIApplication sharedApplication].delegate window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateViewMethod) name:@"updateView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSelectAddress) name:@"updateSelectAddress" object:nil];
    [self getAddressList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"IntegralConfirmViewController"];
//    [self getAddressList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"IntegralConfirmViewController"];
}

- (void)updateViewMethod {
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
    
    CGFloat height;
    if ([_integralProductDetailModel.type_id isEqualToString:@"1"] && _addressArray.count == 1) {
        height = RESIZE_UI(105)+1+RESIZE_UI(111.5);
    } else if ([_integralProductDetailModel.type_id isEqualToString:@"1"] && _addressArray.count != 1) {
        height = RESIZE_UI(105)+1+RESIZE_UI(59);
    } else {
        height = RESIZE_UI(105);
    }
    
    UIView *mainView = [[UIView alloc]init];
    mainView.backgroundColor = RGBA(238, 240, 242, 1.0);
    [mainScrollView addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScrollView);
        make.width.equalTo(self.view.mas_width);
        make.height.mas_offset(height);
    }];
    
    CGFloat tableHeight;
    if ([_integralProductDetailModel.type_id isEqualToString:@"1"] && _addressArray.count == 1) {
        tableHeight = RESIZE_UI(105)+1+RESIZE_UI(111.5);
    } else {
        tableHeight = RESIZE_UI(105);
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
        make.height.mas_offset(tableHeight);
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
    
}

- (void)updateSelectAddress {
    //点击选择地址保存在本地
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefault objectForKey:@"integralAddrss"];
    if (data) {
        _defaultAddressModel = (IntegralAddressModel *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        [userDefault removeObjectForKey:@"integralAddrss"];
        [userDefault synchronize];
        [self.tableView reloadData];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        AddressTableViewCell *cell = [[AddressTableViewCell alloc] initWithIntegralAddressModel:_defaultAddressModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    NSString *addressId = [SingletonManager convertNullString:_defaultAddressModel.id];
    [manager postDataWithUrlActionStr:@"Score/exchange" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid,@"goods_id":_integralProductDetailModel.id,@"address_id":addressId} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [SVProgressHUD dismiss];
//            [[SingletonManager sharedManager] showHUDView:self.view title:@"兑换成功" content:@"" time:1.0 andCodes:^{
//                ExchangeRecordViewController *exchangeRecordVC = [[ExchangeRecordViewController alloc] init];
//                [self.navigationController pushViewController:exchangeRecordVC animated:YES];
//            }];
            
            [self successTipWindow];
            
            
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

- (void)successTipWindow {
    _blackView = [[UIView alloc]init];
    _blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.55];
    [self.window addSubview:_blackView];
    [_blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.window);
    }];
    
    _whiteView = [[UIView alloc]init];
    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.layer.masksToBounds = YES;
    _whiteView.layer.cornerRadius = RESIZE_UI(10);
    [_blackView addSubview:_whiteView];
    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_blackView.mas_centerX);
        make.centerY.equalTo(_blackView.mas_centerY);
        make.height.mas_offset(RESIZE_UI(160));
        make.width.mas_offset(RESIZE_UI(258));
    }];
    
    _rightImage = [[UIImageView alloc]init];
    _rightImage.image = [UIImage imageNamed:@"icon_done"];
    [_whiteView addSubview:_rightImage];
    [_rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_whiteView.mas_top).with.offset(RESIZE_UI(30));
        make.centerX.equalTo(_whiteView.mas_centerX);
        make.height.width.mas_offset(RESIZE_UI(60));
    }];
    
    _tipLabel = [[UILabel alloc]init];
    _tipLabel.text = @"恭喜您，兑换成功!";
    _tipLabel.textColor = RGBA(102, 102, 102, 1.0);
    _tipLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    [_whiteView addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightImage.mas_bottom).with.offset(RESIZE_UI(18));
        make.centerX.equalTo(_whiteView.mas_centerX);
    }];
    
//    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeBlackView)];
//    [_blackView addGestureRecognizer:_tap];
    [self performSelector:@selector(closeBlackView) withObject:nil afterDelay:1.0];
    
}

- (void)closeBlackView {
    [_blackView removeFromSuperview];
    _blackView = nil;
//    _tap = nil;
//    [_blackView removeGestureRecognizer:_tap];
    [_whiteView removeFromSuperview];
    _whiteView = nil;
    [_rightImage removeFromSuperview];
    _rightImage = nil;
    [_tipLabel removeFromSuperview];
    _tipLabel = nil;
    
    ExchangeRecordViewController *exchangeRecordVC = [[ExchangeRecordViewController alloc] init];
    [self.navigationController pushViewController:exchangeRecordVC animated:YES];
    
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
