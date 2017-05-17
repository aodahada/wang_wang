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
