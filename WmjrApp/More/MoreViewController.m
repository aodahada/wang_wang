//
//  MoreViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/6/17.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "MoreViewController.h"
#import "AccountSettingViewController.h"
#import "MyRecommendatViewController.h"
#import "AboutUsViewController.h"
#import "JoinUsViewController.h"
#import "FeedbackViewController.h"
#import "LoginViewController.h"
#import "HelpViewController.h"
#import "MMPopupWindow.h"
#import "MMPopupItem.h"
#import "AgViewController.h"
#import "BaseNavigationController.h"
#import "AliGesturePasswordViewController.h"
//#import "KeychainData.h"

@interface MoreViewController ()<UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_updateArray;
}

@end

@implementation MoreViewController

/*  设置导航条 */
- (void)configNagationBar {
    self.title = @"更多";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    [self configNagationBar];
    [[MMPopupWindow sharedWindow] cacheWindow];
    
    _updateArray = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[SingletonManager sharedManager].uid isEqualToString:@""]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.loginIden = @"login";
        loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UINavigationController *loginNa = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNa animated:YES completion:nil];
        return;
    }
    self.tabBarController.tabBar.hidden = NO;
    /*  设置颜色 */
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    /*  设置字体颜色 */
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    /* 渲染颜色 */
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    /*  去掉边线 */
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navibar_color"] forBarMetrics:UIBarMetricsDefault];
    
//    UIImage *image = [[UIImage imageNamed:@"arrow_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
//    
//    self.navigationItem.leftBarButtonItem = backButton;
}

//- (void)backBtnAction {
//    [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark - UITableView delegate dataSource -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.imageView.image = [UIImage imageNamed:@"shezhi_icon.png"];
                cell.textLabel.text = @"账户设置";
                break;
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"yqhy_icon.png"];
                cell.textLabel.text = @"邀请好友";
                break;
            case 2:
                cell.imageView.image = [UIImage imageNamed:@"help_icon.png"];
                cell.textLabel.text = @"关于我们";
                break;
            case 3:
                cell.imageView.image = [UIImage imageNamed:@"icon_shoushi"];
                cell.textLabel.text = @"手势绘制";
                break;
                
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                cell.imageView.image = [UIImage imageNamed:@"icon_bangzhu"];
                cell.textLabel.text = @"帮助中心";
                break;
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"yjfk_icon.png"];
                cell.textLabel.text = @"意见反馈";
                break;
            case 2:
                cell.imageView.image = [UIImage imageNamed:@"jcgx_icon.png"];
                cell.textLabel.text = @"检查更新";
                break;
                
            default:
                break;
        }
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.textColor = TITLE_COLOR;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                /* 个人设置 */
                AccountSettingViewController *accountVC = [[AccountSettingViewController alloc] init];
                [self.navigationController pushViewController:accountVC animated:YES];
            }
                break;
            case 1:
            {
                /* 邀请好友 */
                MyRecommendatViewController *myselfRecommVC = [[MyRecommendatViewController alloc] initWithNibName:@"MyRecommendatViewController" bundle:nil];
                [self.navigationController pushViewController:myselfRecommVC animated:YES];
            }
                break;
            case 2:
            {
                /* 关于我们 */
//                AboutUsViewController *aboutUVC = [[AboutUsViewController alloc] init];
//                [self.navigationController pushViewController:aboutUVC animated:YES];
                
                AgViewController *agVC =[[AgViewController alloc] init];
                agVC.title = @"关于我们";
                agVC.webUrl = @"http://api.wmjr888.com/home/page/app/id/12";
                BaseNavigationController *baseNa = [[BaseNavigationController alloc] initWithRootViewController:agVC];
                [self presentViewController:baseNa animated:YES completion:^{
                }];
                
            }
                break;
            case 3:
            {
                /* 手势绘制 */
//                JoinUsViewController *joinUVC = [[JoinUsViewController alloc] init];
//                [self.navigationController pushViewController:joinUVC animated:YES];
                
                
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
                //手势绘制
                
                
            }
                break;
                
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
            {
                /* 帮助中心 */
                HelpViewController *helpVC = [[HelpViewController alloc] initWithStyle:(UITableViewStyleGrouped)];
                [self.navigationController pushViewController:helpVC animated:YES];
            }
                break;
            case 1:
            {
                /*  意见反馈 */
                FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
                [self.navigationController pushViewController:feedbackVC animated:YES];
            }
                break;
//            case 2:
//            {
//                /*检查更新*/
//                [self getNewVersionMethod];
//                
//            }
//                break;
            default:
                break;
        }
    }

}

#pragma mark - 获取最新版本号
- (void)getNewVersionMethod {
    
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"检测新版本中.."];
    [manager postDataWithUrlActionStr:@"Public/update" withParamDictionary:@{@"platform":@"ios"} withBlock:^(id obj) {
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                
                NSString *app_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                
                NSDictionary *dicForMes = obj[@"data"];
                NSString *newVersion = dicForMes[@"version"];
                if (![newVersion isEqualToString:app_version]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您当前的版本不是最新版本" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                    [alert show];
                    [SVProgressHUD dismiss];
                } else {
                    [SVProgressHUD showInfoWithStatus:@"已经是最新版本!"];
                }
                
                return ;
            }
            if ([obj[@"result"] isEqualToString:@"1000"]) {
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/wang-ma-cai-fu/id1071502298?l=zh&ls=1&mt=8"]];
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
