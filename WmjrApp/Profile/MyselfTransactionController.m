//
//  MyselfTransactionController.m
//  wangmajinrong
//
//  Created by 1 & 0 on 15/6/25.
//  Copyright (c) 2015年 Baimifan. All rights reserved.
//

#import "MyselfTransactionController.h"
#import "MyselfTransCell.h"
#import "TradeModel.h"

@interface MyselfTransactionController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIView *_aView;
    UITableView *_tableView;
    UIView *_redLine;
}

@property (nonatomic, copy) NSArray *dateArray; /* 时间间隔数组 */
@property (nonatomic, strong) NSMutableArray *tradeArray;

@end

@implementation MyselfTransactionController

- (void)configNagationBar {
    self.title = @"资金流水";
    
    _dateArray = [[SingletonManager sharedManager] getStartDateAndEndDate];
}

- (void)configView {
    _tradeArray = [NSMutableArray array];
    
    NetManager *manager = [[NetManager alloc] init];
    if ([_isWithDraw isEqualToString:@"yes"]) {
        /* 提现查询 */
        [SVProgressHUD showWithStatus:@"正在加载"];
        [manager postDataWithUrlActionStr:@"Trade/withdraw_query" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"page":@"", @"size":@"", @"start_time":_dateArray[1], @"end_time":_dateArray[0]} withBlock:^(id obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                [SVProgressHUD dismiss];
                NSArray *array = [TradeModel mj_keyValuesArrayWithObjectArray:obj[@"data"]];
                for (NSDictionary *dic in array) {
                    TradeModel *model = [[TradeModel alloc] init];
                    [model mj_setKeyValues:dic];
                    model.type = @"3";
                    [_tradeArray addObject:model];
                }
                [_tableView reloadData];
            }
        }];
    } else {
        /* 充值记录 */
        [SVProgressHUD showWithStatus:@"正在加载"];
        [manager postDataWithUrlActionStr:@"Trade/deposit_query" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"page":@"", @"size":@"", @"start_time":_dateArray[1], @"end_time":_dateArray[0]} withBlock:^(id obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                [SVProgressHUD dismiss];
                NSArray *array = [TradeModel mj_keyValuesArrayWithObjectArray:obj[@"data"]];
                for (NSDictionary *dic in array) {
                    TradeModel *model = [[TradeModel alloc] init];
                    [model mj_setKeyValues:dic];
                    model.type = @"1";
                    [_tradeArray addObject:model];
                }
                [_tableView reloadData];
            } else {
                NSLog(@"%@", [obj[@"data"] objectForKey:@"mes"]);
            }
        }];
    }
    
    _aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, RESIZE_UI(50))];
    _aView.backgroundColor = [UIColor whiteColor];
    NSArray *titArray = @[@"充值", @"交易", @"提现"];
    [self.view addSubview:_aView];
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH / 3 * i, 0, SCREEN_WIDTH / 3, RESIZE_UI(50));
        button.tag = 101 + i;
        [button setTitle:titArray[i] forState:UIControlStateNormal];
        if ([_isWithDraw isEqualToString:@"yes"]) {
            if (i == 2) {
                [button setTitleColor:BASECOLOR forState:UIControlStateNormal];
            } else {
                [button setTitleColor:AUXILY_COLOR forState:UIControlStateNormal];
            }
        } else {
            if (i == 0) {
                [button setTitleColor:BASECOLOR forState:UIControlStateNormal];
            } else {
                [button setTitleColor:AUXILY_COLOR forState:UIControlStateNormal];
            }
        }
        button.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(20.0f)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_aView addSubview:button];
    }
    if ([_isWithDraw isEqualToString:@"yes"]) {
        _redLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3*2, RESIZE_UI(48), SCREEN_WIDTH / 3, RESIZE_UI(2))];
    } else {
        _redLine = [[UIView alloc] initWithFrame:CGRectMake(0, RESIZE_UI(48), SCREEN_WIDTH / 3, RESIZE_UI(2))];
    }
    _redLine.backgroundColor = BASECOLOR;
    [self.view addSubview:_redLine];
}

- (void)buttonAction:(UIButton *)btn {
    NetManager *manager = [[NetManager alloc] init];
    [btn setTitleColor:BASECOLOR forState:UIControlStateNormal];
    if ([btn.titleLabel.text isEqualToString:@"充值"]) {
        [UIView animateWithDuration:.3 animations:^{
            _redLine.frame = CGRectMake(0, RESIZE_UI(48), SCREEN_WIDTH / 3, RESIZE_UI(2));
            UIButton *button2 = (UIButton *)[_aView viewWithTag:102];
            [button2 setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
            UIButton *button3 = (UIButton *)[_aView viewWithTag:103];
            [button3 setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
        } completion:nil];
        [_tradeArray removeAllObjects];
        [SVProgressHUD showWithStatus:@"正在加载"];
        [manager postDataWithUrlActionStr:@"Trade/deposit_query" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"page":@"", @"size":@"", @"start_time":_dateArray[1], @"end_time":_dateArray[0]} withBlock:^(id obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                 [SVProgressHUD dismiss];
                NSArray *array = [TradeModel mj_keyValuesArrayWithObjectArray:obj[@"data"]];
                for (NSDictionary *dic in array) {
                    TradeModel *model = [[TradeModel alloc] init];
                    [model mj_setKeyValues:dic];
                    model.type = @"1";
                    [_tradeArray addObject:model];
                }
                [_tableView reloadData];
            }
        }];
    }
    if ([btn.titleLabel.text isEqualToString:@"交易"]) {
        [UIView animateWithDuration:.3 animations:^{
            _redLine.frame = CGRectMake(SCREEN_WIDTH / 3, RESIZE_UI(48), SCREEN_WIDTH / 3, RESIZE_UI(2));
            UIButton *button1 = (UIButton *)[_aView viewWithTag:101];
            [button1 setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
            UIButton *button3 = (UIButton *)[_aView viewWithTag:103];
            [button3 setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
        } completion:nil];
        [_tradeArray removeAllObjects];
        /* 交易记录 */
        [SVProgressHUD showWithStatus:@"正在加载" maskType:(SVProgressHUDMaskTypeBlack)];
        [manager postDataWithUrlActionStr:@"Trade/trade_query" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"page":@"", @"size":@"", @"start_time":_dateArray[1], @"end_time":_dateArray[0]} withBlock:^(id obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                 [SVProgressHUD dismiss];
                NSArray *array = [TradeModel mj_keyValuesArrayWithObjectArray:obj[@"data"]];
                for (NSDictionary *dic in array) {
                    TradeModel *model = [[TradeModel alloc] init];
                    [model mj_setKeyValues:dic];
                    model.type = @"2";
                    [_tradeArray addObject:model];
                }
                [_tableView reloadData];
            }
        }];
    }
    if ([btn.titleLabel.text isEqualToString:@"提现"]) {
        [UIView animateWithDuration:.3 animations:^{
            _redLine.frame = CGRectMake(SCREEN_WIDTH / 3 * 2, RESIZE_UI(48), SCREEN_WIDTH / 3, RESIZE_UI(2));
            UIButton *button1 = (UIButton *)[_aView viewWithTag:101];
            [button1 setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
            UIButton *button2 = (UIButton *)[_aView viewWithTag:102];
            [button2 setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
        } completion:nil];
        [_tradeArray removeAllObjects];
        /* 提现查询 */
        [SVProgressHUD showWithStatus:@"正在加载"];
        [manager postDataWithUrlActionStr:@"Trade/withdraw_query" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"page":@"", @"size":@"", @"start_time":_dateArray[1], @"end_time":_dateArray[0]} withBlock:^(id obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                [SVProgressHUD dismiss];
                NSArray *array = [TradeModel mj_keyValuesArrayWithObjectArray:obj[@"data"]];
                for (NSDictionary *dic in array) {
                    TradeModel *model = [[TradeModel alloc] init];
                    [model mj_setKeyValues:dic];
                    model.type = @"3";
                    [_tradeArray addObject:model];
                }
                [_tableView reloadData];
            }
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNagationBar];
    [self configView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, RESIZE_UI(50), SCREEN_WIDTH, SCREEN_HEIGHT - BOTH_HEIGHT - RESIZE_UI(50)) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[MyselfTransCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - UITableView -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tradeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TradeModel *model = _tradeArray[indexPath.row];
    MyselfTransCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RESIZE_UI(70);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
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
