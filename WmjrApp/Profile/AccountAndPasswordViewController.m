//
//  AccountAndPasswordViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/8/2.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "AccountAndPasswordViewController.h"
#import "RealNameCertificationViewController.h"
#import "PasswordManageViewController.h"
#import "AliGesturePasswordViewController.h"

@interface AccountAndPasswordViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *mainTableView;

@end

@implementation AccountAndPasswordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MobClick beginLogPageView:@"AccountAndPasswordViewController"];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账号和密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _mainTableView = [[UITableView alloc]init];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.scrollEnabled = NO;
    _mainTableView.tableFooterView = [[UIView alloc]init];
    
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RESIZE_UI(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier  = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"实名认证";
            UILabel *labelForRealName = [[UILabel alloc]init];
            labelForRealName.textColor = RGBA(255, 88, 26, 1.0);
            labelForRealName.font = [UIFont systemFontOfSize:15];
            NSString *isRealName = [SingletonManager sharedManager].userModel.is_real_name;
            if ([isRealName isEqualToString:@"1"]) {
                labelForRealName.text = @"已认证";
            } else {
                labelForRealName.text = @"未认证";
            }
            [cell addSubview:labelForRealName];
            [labelForRealName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.mas_right).with.offset(-37);
                make.centerY.equalTo(cell.mas_centerY);
            }];
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"密码管理";
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"手势绘制";
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            //实名认证
            if ([[SingletonManager sharedManager].userModel.is_real_name isEqualToString:@"0"]) {
                RealNameCertificationViewController *realNameCerVC = [[RealNameCertificationViewController alloc] init];
                [self.navigationController pushViewController:realNameCerVC animated:YES];
            }

        }
            break;
        case 1:
        {
            //密码管理
            PasswordManageViewController *passWordVC = [[PasswordManageViewController alloc]init];
            [self.navigationController pushViewController:passWordVC animated:YES];
        }
            break;
        case 2:
        {
            //手势绘制
            BOOL isSave = [[SingletonManager sharedManager] isSave]; //是否有保存
            if (isSave) {
                AliGesturePasswordViewController *aliGesVC = [[AliGesturePasswordViewController alloc]init];
                aliGesVC.string = @"修改密码";
                aliGesVC.type = @"更多";
                [self presentViewController:aliGesVC animated:YES completion:^{
                    
                }];
            } else {
                [[SingletonManager sharedManager] removeHandGestureInfoDefault];
                AliGesturePasswordViewController *aliGesVC = [[AliGesturePasswordViewController alloc]init];
                aliGesVC.string = @"重置密码";
                aliGesVC.type = @"更多";
                [self presentViewController:aliGesVC animated:YES completion:^{
                    
                }];
            }

        }
            break;
            
        default:
            break;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AccountAndPasswordViewController"];
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
