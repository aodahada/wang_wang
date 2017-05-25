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
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return 3;
    } else {
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 13;
    } else if (section == 1) {
        return 12;
    } else if (section == 2) {
        return 26;
    } else {
        return 0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = RGBA(237, 240, 242, 1.0);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return 212;
    } else {
        return 44;
    }
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (indexPath.row) {
            case 0:{
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
                cell.textLabel.text = @"密码管理";
                break;
            case 2:
                cell.textLabel.text = @"手势绘制";
                break;
            case 3:
                cell.textLabel.text = @"关于我们";
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:{
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"帮助中心";
            }
                
                break;
            case 1:{
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"意见反馈";
            }
                break;

            case 2:{
                cell.textLabel.text = @"联系客服";
                UILabel *labelForPhone = [[UILabel alloc]init];
                labelForPhone.text = [SingletonManager sharedManager].companyTel;
                labelForPhone.textColor = RGBA(255, 88, 26, 1.0);
                labelForPhone.font = [UIFont systemFontOfSize:15];
                [cell addSubview:labelForPhone];
                [labelForPhone mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.mas_right).with.offset(-12);
                    make.centerY.equalTo(cell.mas_centerY);
                }];
            }
                
                break;
            default:
                break;
        }
    } else if (indexPath.section == 2) {
        UILabel *labelForLogOut = [[UILabel alloc]init];
        labelForLogOut.text = @"退出登录";
        labelForLogOut.font = [UIFont systemFontOfSize:RESIZE_UI(17)];
        labelForLogOut.textColor = RGBA(153, 153, 153, 1.0);
        [cell addSubview:labelForLogOut];
        [labelForLogOut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.mas_centerX);
            make.centerY.equalTo(cell.mas_centerY);
        }];
    } else {
        cell.backgroundColor = RGBA(237, 240, 242, 1.0);
        UIImageView *imageViewFor = [[UIImageView alloc]init];
        imageViewFor.image = [UIImage imageNamed:@"wang"];
        [cell addSubview:imageViewFor];
        [imageViewFor mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).with.offset(65);
            make.height.width.mas_offset(RESIZE_UI(73));
            make.centerX.equalTo(cell.mas_centerX);
        }];
        
        NSString *app_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        UILabel *labelForVersion = [[UILabel alloc]init];
        labelForVersion.text = [NSString stringWithFormat:@"旺马财富%@版本",app_version];
        labelForVersion.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
        labelForVersion.textColor = RGBA(38, 44, 50, 1.0);
        [cell addSubview:labelForVersion];
        [labelForVersion mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageViewFor.mas_bottom).with.offset(12);
            make.height.mas_offset(RESIZE_UI(22));
            make.centerX.mas_equalTo(cell.mas_centerX);
        }];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                //实名认证
                if ([[SingletonManager sharedManager].userModel.is_real_name isEqualToString:@"0"]) {
                    RealNameCertificationViewController *realNameCerVC = [[RealNameCertificationViewController alloc] init];
                    [self.navigationController pushViewController:realNameCerVC animated:YES];
                }
            }
                break;
            case 1:{
                //密码管理
                PasswordManageViewController *passWordVC = [[PasswordManageViewController alloc]init];
                [self.navigationController pushViewController:passWordVC animated:YES];
            }
                break;
            case 2:{
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
            case 3:{
                //关于我们
                AgViewController *agVC =[[AgViewController alloc] init];
                agVC.title = @"关于我们";
                agVC.webUrl = @"http://api.wmjr888.com/home/page/app/id/12";
                BaseNavigationController *baseNa = [[BaseNavigationController alloc] initWithRootViewController:agVC];
                [self presentViewController:baseNa animated:YES completion:^{
                }];
                
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:{
                //帮助中心
                HelpViewController *helpVC = [[HelpViewController alloc] initWithStyle:(UITableViewStyleGrouped)];
                [self.navigationController pushViewController:helpVC animated:YES];
            }
                break;
            case 1:{
                //意见反馈
                FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
                [self.navigationController pushViewController:feedbackVC animated:YES];
            }
                break;
            case 2:{
                //联系客服
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[SingletonManager sharedManager].companyTel];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 2) {
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
    } else {
        
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
