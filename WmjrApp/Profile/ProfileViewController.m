//
//  ProfileViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/6/17.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "ProfileViewController.h"
#import "MyselfManageFinanceController.h"
//#import "MyselfRecommendatController.h"
#import "MyRecommendatViewController.h"
#import "MyselfPrivilegeStandardController.h"
#import "MyselfTransactionController.h"
#import "MyselfAccountController.h"
#import "MyselfPiggyViewController.h"
#import "MessageWViewController.h"
#import "LoginViewController.h"

@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    
    UILabel *_ydayEarn;//昨日收益
    UILabel *_accountEarn;//累计收益
}

@property (nonatomic, strong) UIButton *messageBtn;  /*  消息 */

@end

@implementation ProfileViewController

- (void)setUpNavigationBar {
    /*  设置颜色 */
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    /*  设置字体颜色 */
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    /* 渲染颜色 */
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    /*  去掉边线 */
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"piggy"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = VIEWBACKCOLOR;
    
}

//头视图
- (UIView *)setUpProfileHeadView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 289)];
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:headView.bounds];
//    imgView.image = [UIImage imageNamed:@"bg_person"];
//    [headView addSubview:imgView];
    headView.backgroundColor = GERENCOLOR;
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, RESIZE_UI(40), RESIZE_UI(150), RESIZE_UI(20))];
    lable.text = @"今日预计收益(元)";
    lable.textAlignment = NSTextAlignmentLeft;
    lable.textColor = VIEWBACKCOLOR;
    lable.font = [UIFont systemFontOfSize:RESIZE_UI(15.0f)];
    [headView addSubview:lable];
    
    /*  消息  */
//    _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _messageBtn = [[UIButton alloc]init];
//    _messageBtn.frame = CGRectMake(SCREEN_WIDTH - 50, RESIZE_UI(35), 40, 30);
    [_messageBtn setTitle:@"消息" forState:UIControlStateNormal];
    [_messageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _messageBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [headView addSubview:_messageBtn];
    [_messageBtn addTarget:self action:@selector(messageBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView.mas_right).with.offset(-10);
        make.width.mas_offset(40);
        make.height.mas_offset(30);
        make.centerY.equalTo(lable.mas_centerY);
    }];
    
    _ydayEarn = [[UILabel alloc] initWithFrame:CGRectMake(RESIZE_UI(45), 120, RESIZE_UI(280), RESIZE_UI(70))];
    _ydayEarn.textAlignment = NSTextAlignmentCenter;
    _ydayEarn.textColor = VIEWBACKCOLOR;
    _ydayEarn.font = [UIFont systemFontOfSize:RESIZE_UI(80.0f)];
    [headView addSubview:_ydayEarn];
    _accountEarn = [[UILabel alloc] initWithFrame:CGRectMake(RESIZE_UI(45), 220, RESIZE_UI(280), RESIZE_UI(20))];
    _accountEarn.textAlignment = NSTextAlignmentCenter;
    _accountEarn.textColor = VIEWBACKCOLOR;
    _accountEarn.font = [UIFont systemFontOfSize:RESIZE_UI(15.0f)];
    [headView addSubview:_accountEarn];
    
    return headView;
}

/* 消息页面 */
- (void)messageBtnAction {
    MessageWViewController *messageVC = [[MessageWViewController alloc] initWithNibName:@"MessageWViewController" bundle:nil];
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, VIEW_WIDTH, VIEW_HEIGHT - 49 + 20) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = [self setUpProfileHeadView];
}

- (void)pushMypristandVC {
    MyselfPrivilegeStandardController *myselfPSVC = [[MyselfPrivilegeStandardController alloc] init];
    [self.navigationController pushViewController:myselfPSVC animated:YES];
}

- (void)dealloc {
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    
    UIImage *image = [[UIImage imageNamed:@"arrow_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    if ([[SingletonManager sharedManager].uid isEqualToString:@""]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.loginIden = @"login";
        loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UINavigationController *loginNa = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNa animated:YES completion:nil];
        return;
    }
    self.navigationController.navigationBarHidden = YES;
//    NSLog(@"我得id:%@",[SingletonManager sharedManager].uid);
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"User/income" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            _ydayEarn.text = [NSString stringWithFormat:@"%.2f", [[obj[@"data"] objectForKey:@"today_income"] floatValue]];
            _accountEarn.text = [NSString stringWithFormat:@"累计收益  %.2f元", [[obj[@"data"] objectForKey:@"total_income"] floatValue]];
//            NSLog(@"我的累计收益:%.2f",[[obj[@"data"] objectForKey:@"total_income"] floatValue]);
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

- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - UITableView dataSource delegate -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier  = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"icon_zhanghuhdpi1"];
        cell.textLabel.text = @"我的账户";
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                cell.imageView.image = [UIImage imageNamed:@"icon_licai1"];
                cell.textLabel.text = @"我的理财";
            }
                break;
            case 1:
            {
                cell.imageView.image = [UIImage imageNamed:@"icon_tuijianhdpi1"];
                cell.textLabel.text = @"我的推荐";
            }
                break;

            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
            {
//                cell.imageView.image = [UIImage imageNamed:@"icon_hongbao"];
//                cell.textLabel.text = @"我的红包";
                cell.imageView.image = [UIImage imageNamed:@"icon_jifen"];
                cell.textLabel.text = @"我的积分";
            }
                break;
            case 1:
            {
                cell.imageView.image = [UIImage imageNamed:@"icon_cunqianguan1"];
                cell.textLabel.text = @"我的存钱罐";
            }
                break;
            case 2:
            {
                cell.imageView.image = [UIImage imageNamed:@"icon_jiaoyidan1"];
                cell.textLabel.text = @"资金流水";
            }
                break;
                
            default:
                break;
        }
    }
    cell.textLabel.textColor = TITLE_COLOR;

    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            /*  我的账户 */
            UIStoryboard *myselfAccount = [UIStoryboard storyboardWithName:@"MyselfAccountController" bundle:[NSBundle mainBundle]];
            MyselfAccountController *myselfAccountVC = [myselfAccount instantiateViewControllerWithIdentifier:@"MyselfAccount"];
            myselfAccountVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myselfAccountVC animated:YES];
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                /* 我的理财 */
                MyselfManageFinanceController *myselfMFVC = [[MyselfManageFinanceController alloc] init];
                [self.navigationController pushViewController:myselfMFVC animated:YES];
            }
            if (indexPath.row == 1) {
                /* 我的推荐 */
//                MyselfRecommendatController *myselfRecommVC = [[MyselfRecommendatController alloc] init];
                MyRecommendatViewController *myrecommendVC = [[MyRecommendatViewController alloc]initWithNibName:@"MyRecommendatViewController" bundle:nil];
                [self.navigationController pushViewController:myrecommendVC animated:YES];
            }
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
#warning 待定  以后是我的积分
                /* 我的红包  待定 目前是我的积分*/
//                MyselfPrivilegeStandardController *myselfPSVC = [[MyselfPrivilegeStandardController alloc] init];
//                [self.navigationController pushViewController:myselfPSVC animated:YES];
                [[[UIAlertView alloc]initWithTitle:@"该功能正在开发中" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil]show];
            }
            if (indexPath.row == 1) {
                /* 我的存钱罐 */
                MyselfPiggyViewController *myselfPiggyVC = [[MyselfPiggyViewController alloc] init];
                [self.navigationController pushViewController:myselfPiggyVC animated:YES];
            }
            if (indexPath.row == 2) {
                /* 交易单 */
                MyselfTransactionController *myselfTranVC = [[MyselfTransactionController alloc] init];
                [self.navigationController pushViewController:myselfTranVC animated:YES];
            }
        }
            break;
            
        default:
            break;
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
