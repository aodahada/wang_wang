//
//  MyselfManageFinanceController.m
//  wangmajinrong
//
//  Created by 1 & 0 on 15/6/25.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "MyselfManageFinanceController.h"
#import "MyselfManageFinanceCell.h"
#import "TrandDetailViewController.h"
#import "HRBuyViewController.h"

@interface MyselfManageFinanceController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    UIImageView *_markImg;
    BOOL flag;
    
    UILabel *_newEarn;//今日收益
    UILabel *_accountEarn;//累计收益
    UILabel *_conductNum;//理财金额
    
    UIView *_aView;
    UIView *_redLine;
    NSString *_tempString;
}

@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@property (nonatomic, strong) NSMutableArray *financeArray;

@property (nonatomic, copy) NSString *totalEarn; /* 总收益 */

@end

@implementation MyselfManageFinanceController

- (void)setUpNavigationBar {
    self.title = @"我的理财";
    /*  设置颜色 */
    self.navigationController.navigationBar.barTintColor = RGBA(0, 108, 175, 1.0);
    //    /*  设置字体颜色 */
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:VIEWBACKCOLOR};
    //    /* 渲染颜色 */
    self.navigationController.navigationBar.tintColor = RGBA(0, 108, 175, 1.0);
    
    /*  去掉边线 */
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"piggy"] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *image = [[UIImage imageNamed:@"arrow_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    if ([_isPay isEqualToString:@"YES"]) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"购买成功" message:@"购买成功,可能会由于银行系统问题导致延迟，请您稍等" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
        
//        //1.创建本地通知
//        UILocalNotification *locaNote = [[UILocalNotification alloc]init];
//        //2.设置本地通知内容
//        //2.1设置通知发出时间
//        locaNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
//        //2.2设置通知的内容
//        locaNote.alertBody = @"您有新产品购买成功，可能由于银行系统原因导致延迟，请您谅解";
//        //2.3设置滑块文字
//        locaNote.alertAction = @"好的";
//        //2.4决定alertAction是否生效
//        locaNote.hasAction = NO;
//        //2.5设置点击启动的图片
//        locaNote.alertLaunchImage = @"";//这里不管写什么都是按照工程启动图片显示
//        //2.6设置alertTitle
//        locaNote.alertTitle = @"有新产品购买成功";
//        //2.7设置通知音效
//        locaNote.soundName = UILocalNotificationDefaultSoundName;//自定义的话写@"buyao.wav"
//        //2.8设置图标右上角的数字
//        locaNote.applicationIconBadgeNumber = 0;
//        
//        locaNote.userInfo = @{@"newBuy":@"newBuy"};
//        
//        //3.调用通知
//        [[UIApplication sharedApplication]scheduleLocalNotification:locaNote];
        
    }
    
}

- (void)backBtnAction {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//头视图
- (UIView *)setUpProfileHeadView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, RESIZE_UI(280))];
    headView.backgroundColor = RGBA(0, 108, 175, 1.0);
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(RESIZE_UI(45), RESIZE_UI(10), RESIZE_UI(280), RESIZE_UI(20))];
    lable.text = @"今日预计收益(元)";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:RESIZE_UI(15.0f)];
    [headView addSubview:lable];
    _newEarn = [[UILabel alloc] initWithFrame:CGRectMake(RESIZE_UI(45), RESIZE_UI(50), RESIZE_UI(280), RESIZE_UI(80))];
    _newEarn.textAlignment = NSTextAlignmentCenter;
    _newEarn.textColor = [UIColor whiteColor];
    _newEarn.font = [UIFont systemFontOfSize:RESIZE_UI(80.0f)];
    [headView addSubview:_newEarn];
    _accountEarn = [[UILabel alloc] initWithFrame:CGRectMake(RESIZE_UI(45), RESIZE_UI(140), RESIZE_UI(280), RESIZE_UI(20))];
    _accountEarn.textAlignment = NSTextAlignmentCenter;
    _accountEarn.textColor = [UIColor whiteColor];
    _accountEarn.font = [UIFont systemFontOfSize:RESIZE_UI(15.0f)];
    [headView addSubview:_accountEarn];
    
    UIView *whiteLine = [[UIView alloc] initWithFrame:RESIZE_FRAME(CGRectMake(15, 180, 345, 1))];
    whiteLine.backgroundColor = [UIColor whiteColor];
    whiteLine.alpha = .4;
    [headView addSubview:whiteLine];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = RESIZE_FRAME(CGRectMake(15, 200, 100, 20));
    [btn setBackgroundImage:[UIImage imageNamed:@"licaijine_tag.png"] forState:UIControlStateNormal];
    btn.enabled = NO;
    [headView addSubview:btn];
    
    _conductNum = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(230, 200, 120, 20))];
    _conductNum.textAlignment = NSTextAlignmentRight;
    _conductNum.textColor = [UIColor whiteColor];
    _conductNum.font = [UIFont systemFontOfSize:RESIZE_UI(15.0f)];
    [headView addSubview:_conductNum];
    
    _aView = [[UIView alloc] initWithFrame:CGRectMake(0, RESIZE_UI(240), SCREEN_WIDTH, RESIZE_UI(50))];
    _aView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:_aView];
    NSArray *titArray = @[@"持有中", @"已赎回"];
    for (NSInteger i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH / 2 * i, 0, SCREEN_WIDTH / 2, RESIZE_UI(50));
        button.tag = 101 + i;
        [button setTitle:titArray[i] forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:RGBA(0, 108, 175, 1.0) forState:UIControlStateNormal];
        } else {
            [button setTitleColor:AUXILY_COLOR forState:UIControlStateNormal];
        }
        button.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(20.0f)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_aView addSubview:button];
    }
    _redLine = [[UIView alloc] initWithFrame:CGRectMake(0, RESIZE_UI(288), SCREEN_WIDTH / 2, RESIZE_UI(2))];
    _redLine.backgroundColor = RGBA(0, 108, 175, 1.0);
    [headView addSubview:_redLine];
    
    return headView;
}

- (void)buttonAction:(UIButton *)btn {
    NSString *stateStr = nil;
    [btn setTitleColor:RGBA(0, 108, 175, 1.0) forState:UIControlStateNormal];
    if ([btn.titleLabel.text isEqualToString:@"持有中"]) {
        stateStr = @"4";
        [UIView animateWithDuration:.3 animations:^{
            _redLine.frame = CGRectMake(0, RESIZE_UI(288), SCREEN_WIDTH / 2, RESIZE_UI(2));
            UIButton *button = (UIButton *)[_aView viewWithTag:102];
            [button setTitleColor:AUXILY_COLOR forState:UIControlStateNormal];
        } completion:nil];
    }
    if ([btn.titleLabel.text isEqualToString:@"已赎回"]) {
        stateStr = @"3";
        [UIView animateWithDuration:.3 animations:^{
            _redLine.frame = CGRectMake(SCREEN_WIDTH / 2, RESIZE_UI(288), SCREEN_WIDTH / 2, RESIZE_UI(2));
            UIButton *button = (UIButton *)[_aView viewWithTag:101];
            [button setTitleColor:AUXILY_COLOR forState:UIControlStateNormal];
        } completion:nil];
    }
    
    [_financeArray removeAllObjects];
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"正在加载"];
    [manager postDataWithUrlActionStr:@"Product/myProduct" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"page":@"", @"size":@"",@"state":stateStr} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [SVProgressHUD dismiss];
            NSArray *array = [FinancialModel mj_keyValuesArrayWithObjectArray:obj[@"data"]];
            for (NSDictionary *dic in array) {
                FinancialModel *model = [[FinancialModel alloc] init];
                [model mj_setKeyValues:dic];
                [_financeArray addObject:model];
            }
            [_tableView reloadData];
        }
    }];
    stateStr = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _financeArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.tag = 101;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = [self setUpProfileHeadView];
    [_tableView registerClass:[MyselfManageFinanceCell class] forCellReuseIdentifier:@"cell1"];
    
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"正在加载"];
    [manager postDataWithUrlActionStr:@"Product/myProduct" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"page":@"", @"size":@"",@"state":@"4"} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [SVProgressHUD dismiss];
             [_financeArray removeAllObjects];
            NSArray *array = [FinancialModel mj_keyValuesArrayWithObjectArray:obj[@"data"]];
            for (NSDictionary *dic in array) {
                FinancialModel *model = [[FinancialModel alloc] init];
                [model mj_setKeyValues:dic];
                [_financeArray addObject:model];
            }
            [_tableView reloadData];
        }
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    /* 设置导航条 */
    [self setUpNavigationBar];
    
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"User/income" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            _newEarn.text = [NSString stringWithFormat:@"%.2f", [[obj[@"data"] objectForKey:@"today_income"] floatValue]];
            _totalEarn = [NSString stringWithFormat:@"%.2f", [[obj[@"data"] objectForKey:@"total_income"] floatValue]];
            _accountEarn.text = [NSString stringWithFormat:@"累计收益  %.2f元", [[obj[@"data"] objectForKey:@"total_income"] floatValue]];
            _conductNum.text = [NSString stringWithFormat:@" %.2f元", [[obj[@"data"] objectForKey:@"total_invest"] floatValue]];
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - UITableView -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _financeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FinancialModel *model = _financeArray[indexPath.row];
    MyselfManageFinanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FinancialModel *model = _financeArray[indexPath.row];
    /*跳转到产品介绍*/
    TrandDetailViewController *trandDetailVC = [[TrandDetailViewController alloc] init];
    trandDetailVC.nameStr = model.name;
    trandDetailVC.earnToatl = [NSString stringWithFormat:@"%.2f", [model.money floatValue] *[model.returnrate floatValue] / 365 *[model.day intValue]];
    trandDetailVC.totalNum = model.money;
    trandDetailVC.earnNum = [NSString stringWithFormat:@"%.2f", [model.money floatValue] + [model.money floatValue] *[model.returnrate floatValue] / 365 *[model.day intValue]];
    trandDetailVC.earnP = model.returnrate;
    trandDetailVC.duedate = model.duedate;
    trandDetailVC.expirydate = model.expirydate;
    trandDetailVC.createtime = model.createtime;
    [self.navigationController pushViewController:trandDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return RESIZE_UI(110);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return RESIZE_UI(10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
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
