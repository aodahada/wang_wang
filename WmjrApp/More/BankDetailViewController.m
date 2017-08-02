//
//  BankDetailViewController.m
//  WmjrApp
//
//  Created by Baimifan on 2017/5/17.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "BankDetailViewController.h"
#import "ListBankTableViewCell.h"
#import "BankModel.h"

@interface BankDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *bankArray;

@end

@implementation BankDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title  =  @"绑定银行卡限额说明";
    self.view.backgroundColor  =RGBA(37, 108, 175, 1.0);
    
    [self getBankList];
    
}

#pragma mark - 获取银行限额列表
- (void)getBankList {
    
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    _bankArray = [[NSMutableArray alloc]init];
    [manager postDataWithUrlActionStr:@"Bank/index" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSMutableArray *array = obj[@"data"];
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic = array[i];
                BankModel *bankModel = [BankModel mj_objectWithKeyValues:dic];
                [_bankArray addObject:bankModel];
            }
            
            UITableView *listTableView = [[UITableView alloc]init];
            listTableView.backgroundColor = RGBA(37, 108, 175, 1.0);
            listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            listTableView.delegate  = self;
            listTableView.dataSource = self;
            [listTableView registerClass:[ListBankTableViewCell class] forCellReuseIdentifier:@"ListBankTableViewCell"];
            [self.view addSubview:listTableView];
            [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];

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
    return RESIZE_UI(40);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = RGBA(37, 108, 175, 1.0);
    UILabel *bankLabel = [[UILabel alloc]init];
    bankLabel.text = @"银行(借记卡)";
    bankLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    bankLabel.textColor = RGBA(167, 210, 238, 1.0);
    [headerView addSubview:bankLabel];
    [bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).with.offset(RESIZE_UI(20));
        make.centerY.equalTo(headerView.mas_centerY).with.offset(RESIZE_UI(10));
    }];
    
    UILabel *firstLabel = [[UILabel alloc]init];
    firstLabel.text = @"首次绑卡支付";
    firstLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    firstLabel.textColor = RGBA(167, 210, 238, 1.0);
    [headerView addSubview:firstLabel];
    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_centerY).with.offset(RESIZE_UI(10));
        make.left.equalTo(headerView.mas_left).with.offset(RESIZE_UI(130));
    }];
    
    UILabel *alreadyLabel = [[UILabel alloc]init];
    alreadyLabel.text = @"已绑卡支付";
    alreadyLabel.font = [UIFont systemFontOfSize:RESIZE_UI(14)];
    alreadyLabel.textColor = RGBA(167, 210, 238, 1.0);
    [headerView addSubview:alreadyLabel];
    [alreadyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_centerY).with.offset(RESIZE_UI(10));
        make.right.equalTo(headerView.mas_right).with.offset(-RESIZE_UI(45));
    }];
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _bankArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RESIZE_UI(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListBankTableViewCell *cell = [[ListBankTableViewCell alloc]initWithBankModel:_bankArray[indexPath.row]];
    cell.backgroundColor = RGBA(37, 108, 175, 1.0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
