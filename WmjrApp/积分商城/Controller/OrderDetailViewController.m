//
//  OrderDetailViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/10/19.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "IntegralOrderModel.h"
#import "IntegralOrderListCell.h"
#import "OrderAddressTableViewCell.h"
#import "DeliverInfoObject.h"
#import "MyRedPackageViewController.h"

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation OrderDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"OrderDetailViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"OrderDetailViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    self.view.backgroundColor = RGBA(238, 240, 242, 1.0);
    
    CGFloat height;
    if ([_integralOrderModel.type_id isEqualToString:@"1"]) {
        height = RESIZE_UI(150)+1+RESIZE_UI(112)+RESIZE_UI(12)+RESIZE_UI(44)+1+RESIZE_UI(44)+1+RESIZE_UI(140);
    } else {
        height = RESIZE_UI(150);
    }
    
    UIScrollView *mainScrollView = [[UIScrollView alloc]init];
    [self.view addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    UIView *mainView = [[UIView alloc]init];
    mainView.backgroundColor = RGBA(238, 240, 242, 1.0);
    [mainScrollView addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScrollView);
        make.width.equalTo(self.view.mas_width);
        make.height.mas_offset(height);
    }];
    
    CGFloat tableHeight;
    if ([_integralOrderModel.type_id isEqualToString:@"1"]) {
        tableHeight = RESIZE_UI(150)+1+RESIZE_UI(112);
    } else {
        tableHeight = RESIZE_UI(150);
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
    
    UIView *redView = [[UIView alloc]init];
    redView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:redView];
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).with.offset(1);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(49));
    }];
    
    UILabel *redTip1 = [[UILabel alloc]init];
    redTip1.text = @"请到“";
    redTip1.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [redView addSubview:redTip1];
    [redTip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(redView.mas_centerY);
        make.left.equalTo(redView.mas_left).with.offset(RESIZE_UI(12));
    }];
    
    UILabel *redTip2 = [[UILabel alloc]init];
    redTip2.text = @"我的红包";
    redTip2.textColor = RGBA(252, 62, 25, 1.0);
    redTip2.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [redView addSubview:redTip2];
    [redTip2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(redView.mas_centerY);
        make.left.equalTo(redTip1.mas_right);
    }];
    
    UILabel *redTip3 = [[UILabel alloc]init];
    redTip3.text = @"\"查看";
    redTip3.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [redView addSubview:redTip3];
    [redTip3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(redView.mas_centerY);
        make.left.equalTo(redTip2.mas_right);
    }];
    
    UIButton *watchRed = [[UIButton alloc]init];
    [watchRed setTitle:@"立即查看" forState:UIControlStateNormal];
    watchRed.layer.masksToBounds = YES;
    watchRed.layer.cornerRadius = RESIZE_UI(5);
    watchRed.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [watchRed setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [watchRed setBackgroundColor:RGBA(255, 86, 30, 1.0)];
    [watchRed addTarget:self action:@selector(watchRedBallMethod) forControlEvents:UIControlEventTouchUpInside];
    [redView addSubview:watchRed];
    [watchRed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(redView.mas_centerY);
        make.right.equalTo(redView.mas_right).with.offset(-RESIZE_UI(15));
        make.width.mas_offset(RESIZE_UI(77));
        make.height.mas_offset(RESIZE_UI(33));
    }];
    
    if ([_integralOrderModel.type_id isEqualToString:@"1"]) {
        UIView *transportView = [[UIView alloc]init];
        transportView.backgroundColor = [UIColor whiteColor];
        [mainView addSubview:transportView];
        [transportView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_bottom).with.offset(RESIZE_UI(12));
            make.left.equalTo(self.tableView.mas_left);
            make.right.equalTo(self.tableView.mas_right);
            make.height.mas_offset(RESIZE_UI(44));
        }];
        
        UILabel *transportTitle = [[UILabel alloc]init];
        transportTitle.text = @"配送方式:";
        transportTitle.textColor = RGBA(102, 102, 102, 1.0);
        transportTitle.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        [transportView addSubview:transportTitle];
        [transportTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(transportView.mas_centerY);
            make.left.equalTo(transportView.mas_left).with.offset(RESIZE_UI(12));
        }];
        
        DeliverInfoObject *deliverInfo = _integralOrderModel.deliver_info;
        
        UILabel *transportContent = [[UILabel alloc]init];
        transportContent.text = deliverInfo.express;
        [transportView addSubview:transportContent];
        [transportContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(transportView.mas_centerY);
            make.right.equalTo(transportView.mas_right).with.offset(-RESIZE_UI(12));
        }];
        
        UIView *transNumView = [[UIView alloc]init];
        transNumView.backgroundColor = [UIColor whiteColor];
        [mainView addSubview:transNumView];
        [transNumView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(transportView.mas_bottom).with.offset(1);
            make.left.equalTo(mainView.mas_left);
            make.right.equalTo(mainView.mas_right);
            make.height.mas_offset(RESIZE_UI(44));
        }];
        
        UILabel *transNumTitle = [[UILabel alloc]init];
        transNumTitle.text = @"运单号:";
        transNumTitle.textColor = RGBA(102, 102, 102, 1.0);
        transNumTitle.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        [transNumView addSubview:transNumTitle];
        [transNumTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(transNumView.mas_centerY);
            make.left.equalTo(transNumView.mas_left).with.offset(RESIZE_UI(12));
        }];
        
        UILabel *transNumContent = [[UILabel alloc]init];
        transNumContent.text = deliverInfo.waybill_no;
        transNumContent.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        [transNumView addSubview:transNumContent];
        [transNumContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(transNumView.mas_centerY);
            make.right.equalTo(transNumView.mas_right).with.offset(-RESIZE_UI(12));
        }];
        
        //备注view
        UIView *remarkView = [[UIView alloc]init];
        remarkView.backgroundColor = [UIColor whiteColor];
        [mainView addSubview:remarkView];
        [remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(transNumView.mas_bottom).with.offset(1);
            make.left.equalTo(mainView.mas_left);
            make.right.equalTo(mainView.mas_right);
            make.height.mas_offset(RESIZE_UI(140));
        }];
        
        UILabel *remarkTitle = [[UILabel alloc]init];
        remarkTitle.text = @"备注:";
        remarkTitle.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        remarkTitle.textColor = RGBA(102, 102, 102, 1.0);
        [mainView addSubview:remarkTitle];
        [remarkTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(remarkView.mas_top).with.offset(RESIZE_UI(12));
            make.left.equalTo(remarkView.mas_left).with.offset(RESIZE_UI(12));
        }];
        
        UITextView *remarkContent = [[UITextView alloc]init];
        remarkContent.text = deliverInfo.remarks;
        //    remarkContent.text = @"待定hi阿萨德hi按时大会是滴哈斯的hi按时嗲沙嗲海蒂诗嗲好嗲上帝是大四大行1";
        remarkContent.textColor = RGBA(153, 153, 153, 1.0);
        remarkContent.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
        [remarkView addSubview:remarkContent];
        [remarkContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(remarkTitle.mas_top).with.offset(-8);
            make.left.equalTo(remarkTitle.mas_right).with.offset(RESIZE_UI(12));
            make.bottom.equalTo(remarkView.mas_bottom).with.offset(RESIZE_UI(-20));
            make.right.equalTo(remarkView.mas_right).with.offset(-RESIZE_UI(14));
        }];
    }
    
    
}

#pragma mark - 查看红包
- (void)watchRedBallMethod {
    MyRedPackageViewController *myRedVC = [[MyRedPackageViewController alloc] init];
    [self.navigationController pushViewController:myRedVC animated:YES];
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
    
    if ([_integralOrderModel.type_id isEqualToString:@"1"]) {
        if (indexPath.section == 0) {
            return RESIZE_UI(150);
        } else {
            return RESIZE_UI(112);
        }
    } else {
        return RESIZE_UI(150);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_integralOrderModel.type_id isEqualToString:@"1"]) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        IntegralOrderListCell *cell = [[IntegralOrderListCell alloc]initWithIntegralOrderModel:_integralOrderModel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        OrderAddressTableViewCell *cell = [[OrderAddressTableViewCell alloc] initWithIntegralAddressModel:_integralOrderModel.receive_info];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
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
