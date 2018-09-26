//
//  PasswordManageViewController.m
//  WmjrApp
//
//  Created by horry on 2016/11/2.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "PasswordManageViewController.h"
#import "ResetLoginPasswordViewController.h"
#import "RestPassWordViewController.h"

@interface PasswordManageViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PasswordManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"密码管理";
    self.view.backgroundColor = RGBA(238, 238, 238, 1.0);
    // Do any additional setup after loading the view.
    UITableView *tabViewForMore = [[UITableView alloc]init];
    tabViewForMore.delegate = self;
    tabViewForMore.dataSource = self;
    tabViewForMore.backgroundColor = RGBA(237, 240, 242, 1.0);
    tabViewForMore.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tabViewForMore];
    [tabViewForMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(13);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PasswordManageViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PasswordManageViewController"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *Cellindentifier = @"Cellindentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellindentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cellindentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = RGBA(20, 20, 23, 1.0);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"修改登录密码";
    } else {
        cell.textLabel.text = @"修改交易密码";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        /* 修改登录密码 */
        ResetLoginPasswordViewController *resetLoginPVC = [[ResetLoginPasswordViewController alloc] init];
        [self.navigationController pushViewController:resetLoginPVC animated:YES];
    } else {
        /* 修改交易密码 */
        [self resetPasswordMethod];
    }
}

#pragma mark - 修改交易密码接口
- (void)resetPasswordMethod {
    
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"请稍后"];
    [manager postDataWithUrlActionStr:@"User/new_set_trade_pwd" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                
                NSDictionary *dataDic = obj[@"data"];
                NSString *redirect_url = dataDic[@"redirect_url"];
                RestPassWordViewController *restPassVC = [[RestPassWordViewController alloc]initWithNibName:@"RestPassWordViewController" bundle:nil];
                restPassVC.redirect_url = redirect_url;
                [self.navigationController pushViewController:restPassVC animated:YES];
                [SVProgressHUD dismiss];
                return ;
            } else {
                NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
                MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
                alertConfig.defaultTextOK = @"确定";
                [SVProgressHUD dismiss];
                MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
                [alertView show];
            }
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
