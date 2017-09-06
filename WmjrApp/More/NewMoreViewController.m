//
//  NewMoreViewController.m
//  WmjrApp
//
//  Created by horry on 2016/11/2.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "NewMoreViewController.h"
#import "RealNameCertificationViewController.h"
#import "PasswordManageViewController.h"
#import "LoginViewController.h"
#import "MMPopupWindow.h"
#import "MMPopupItem.h"
#import "AgViewController.h"
#import "BaseNavigationController.h"
#import "AliGesturePasswordViewController.h"
#import "HelpViewController.h"
#import "FeedbackViewController.h"
#import "BaseNavigationController.h"

@interface NewMoreViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation NewMoreViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"NewMoreViewController"];
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人管理";
    self.view.backgroundColor = RGBA(237, 240, 242, 1.0);
    // Do any additional setup after loading the view.
    UITableView *tabViewForMore = [[UITableView alloc]init];
    tabViewForMore.delegate = self;
    tabViewForMore.dataSource = self;
    tabViewForMore.bounces = NO;
    tabViewForMore.showsVerticalScrollIndicator = NO;
    tabViewForMore.backgroundColor = RGBA(237, 240, 242, 1.0);
    tabViewForMore.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tabViewForMore];
    [tabViewForMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-RESIZE_UI(44));
    }];
    
    UIButton *buttonForExit = [[UIButton alloc]init];
    [buttonForExit setBackgroundColor:RGBA(236, 100, 52, 1.0)];
    buttonForExit.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
    [buttonForExit setTitle:@"退出" forState:UIControlStateNormal];
    [buttonForExit addTarget:self action:@selector(exitMethod) forControlEvents:UIControlEventTouchUpInside];
    [buttonForExit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:buttonForExit];
    [buttonForExit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_offset(RESIZE_UI(44));
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"NewMoreViewController"];
}

#pragma mark - 退出登录
- (void)exitMethod {
    /* 安全退出 */
    MMPopupItemHandler block = ^(NSInteger index){
        if (index == 0) {
            return ;
        }
        if (index == 1) {
            /* 将当前的uid置为空 */
            [SingletonManager sharedManager].uid = @"";
            [SingletonManager sharedManager].userModel = nil;
            [[NSUserDefaults standardUserDefaults] setValue:[SingletonManager sharedManager].uid forKey:@"uid"];
            [[NSUserDefaults standardUserDefaults] setValue:[SingletonManager sharedManager].userModel forKey:@"userModel"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"mobile"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"passWord"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"logout" object:nil];
#warning 待定
            //可能退出时也要删除手势密码
            //                [KeychainData forgotPsw];
            [[SingletonManager sharedManager] removeHandGestureInfoDefault];

            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.loginIden = @"login";
            loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            BaseNavigationController *loginNa = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:loginNa animated:YES completion:^{
            }];
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    NSArray *items =
    @[MMItemMake(@"取消", MMItemTypeNormal, block),
      MMItemMake(@"确定", MMItemTypeNormal, block)];
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
                                                         detail:@"是否确定退出"
                                                          items:items];
    [alertView show];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    } else  {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        return 41;
    } else {
        return 0;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *viewForHeader = [[UIView alloc]init];
    viewForHeader.backgroundColor = RGBA(237, 240, 242, 1.0);
    if (section == 1) {
        UIView *whiteView = [[UIView alloc]init];
        whiteView.backgroundColor = [UIColor whiteColor];
        [viewForHeader addSubview:whiteView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewForHeader.mas_top).with.offset(12);
            make.left.equalTo(viewForHeader.mas_left);
            make.right.equalTo(viewForHeader.mas_right);
            make.bottom.equalTo(viewForHeader.mas_bottom).with.offset(-1);
        }];
        
        UILabel *labelForLine = [[UILabel alloc]init];
        labelForLine.backgroundColor = RGBA(42, 103, 170, 1.0);
        [whiteView addSubview:labelForLine];
        [labelForLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(whiteView.mas_centerY);
            make.left.equalTo(whiteView.mas_left);
            make.height.mas_offset(17);
            make.width.mas_offset(5);
        }];

        UILabel *labelForTitle = [[UILabel alloc]init];
        labelForTitle.text = @"新浪账户中心";
        labelForTitle.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
        labelForTitle.textColor = RGBA(153, 153, 153, 1.0);
        [whiteView addSubview:labelForTitle];
        [labelForTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(whiteView.mas_centerY);
            make.left.equalTo(whiteView.mas_left).with.offset(13);
        }];
    }
    return viewForHeader;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return RESIZE_UI(60);
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *Cellindentifier = @"Cellindentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellindentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cellindentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
        cell.textLabel.textColor = RGBA(20, 20, 23, 1.0);
    }
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"关于我们";
                break;
            case 1:
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"帮助中心";
                break;
            case 2:
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"意见反馈";
                break;
            case 3:
            {
                cell.textLabel.text = @"当前版本";
                NSString *app_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                UILabel *labelForVersion = [[UILabel alloc]init];
                labelForVersion.text = app_version;
                labelForVersion.textColor = RGBA(255, 88, 26, 1.0);
                labelForVersion.font = [UIFont systemFontOfSize:15];
                [cell addSubview:labelForVersion];
                [labelForVersion mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.mas_right).with.offset(-12);
                    make.centerY.equalTo(cell.mas_centerY);
                }];
            }
                break;
                
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:{
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"账户管理";
            }
                
                break;
            case 1:{
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"安全中心";
            }
                break;

            case 2:{
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"我的授权";
                
            }
                
                break;
            default:
                break;
        }
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                //关于我们
                AgViewController *agVC =[[AgViewController alloc] init];
                agVC.title = @"关于我们";
                agVC.webUrl = @"http://api.wmjr888.com/home/page/app/id/12";
                [self.navigationController pushViewController:agVC animated:YES];
//                BaseNavigationController *baseNa = [[BaseNavigationController alloc] initWithRootViewController:agVC];
//                [self presentViewController:baseNa animated:YES completion:^{
//                }];
            }
                break;
            case 1:{
                //帮助中心
                HelpViewController *helpVC = [[HelpViewController alloc] initWithStyle:(UITableViewStyleGrouped)];
                [self.navigationController pushViewController:helpVC animated:YES];
            }
                break;
            case 2:{
                //意见反馈
                FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
                [self.navigationController pushViewController:feedbackVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:{
                //账户管理
                [self jumpToXinLangMethod:@"DEFAULT" andTitle:@"账户管理"];
            }
                break;
            case 1:{
                //安全中心
                [self jumpToXinLangMethod:@"SAFETY_CENTER" andTitle:@"安全中心"];
            }
                break;
            case 2:{
                //我的授权
                [self jumpToXinLangMethod:@"WITHHOLD" andTitle:@"我的授权"];
            }
                break;
                
            default:
                break;
        }
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 13;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (void)jumpToXinLangMethod:(NSString *)default_page andTitle:(NSString *)title{
    
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"请稍后"];
    [manager postDataWithUrlActionStr:@"Sina/index" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"default_page":default_page} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSDictionary *dic = obj[@"data"];
            AgViewController *agVC =[[AgViewController alloc] init];
            agVC.title = title;
            agVC.webUrl = dic[@"redirect_url"];
//            BaseNavigationController *baseNa = [[BaseNavigationController alloc] initWithRootViewController:agVC];
            [SVProgressHUD dismiss];
//            [self presentViewController:baseNa animated:YES completion:^{
//            }];
            [self.navigationController pushViewController:agVC animated:YES];
        }else {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
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
