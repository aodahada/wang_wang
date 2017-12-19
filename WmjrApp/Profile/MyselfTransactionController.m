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
#import "DatePickSelectView.h"

@interface MyselfTransactionController ()<UITableViewDelegate, UITableViewDataSource,DatePickSelectViewDelete>
{
    UIView *_aView;
    UITableView *_tableView;
    UIView *_redLine;
    UIDatePicker *datePicker;
    UIButton *startDateBtn;
    UIButton *endDateBtn;
    UILabel *tipLabel;
}

@property (nonatomic, copy) NSMutableArray *dateArray; /* 时间间隔数组 */
@property (nonatomic, strong) NSMutableArray *tradeArray;
@property (nonatomic, strong)DatePickSelectView *datePickSelectView;
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UITapGestureRecognizer *tap;
@property (nonatomic, assign)BOOL isStart;
@property (nonatomic, assign)NSInteger type;//0充值 1交易 2提现

@end

@implementation MyselfTransactionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"交易记录";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate date];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSString *dateNewString = [self updateDateStyle:dateString];
    NSString *endDate = [self conbineEndDate:dateNewString];
    NSString *startDate = [self conbineStartDate:dateNewString];
    _dateArray = [[NSMutableArray alloc]initWithArray:@[endDate,startDate]];
//        _dateArray = [[SingletonManager sharedManager] getStartDateAndEndDate];
    
    if ([_isWithDraw isEqualToString:@"yes"]){
        _type = 2;
    } else {
        _type = 0;
    }
    
    [self configView];
    
    //日期view
    UIView *dateView = [[UIView alloc]initWithFrame:CGRectMake(0, RESIZE_UI(50), SCREEN_WIDTH, RESIZE_UI(50))];
    dateView.backgroundColor = RGBA(239, 239, 244, 1.0);
    [self.view addSubview:dateView];
    
    startDateBtn = [[UIButton alloc]init];
    [startDateBtn setTitle:dateString forState:UIControlStateNormal];
    startDateBtn.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(11)];
    [startDateBtn setTitleColor:RGBA(125, 125, 125, 1.0) forState:UIControlStateNormal];
    startDateBtn.layer.borderWidth = 1.0f;
    startDateBtn.layer.borderColor = RGBA(168, 168, 168, 1.0).CGColor;
    [startDateBtn addTarget:self action:@selector(showPickView:) forControlEvents:UIControlEventTouchUpInside];
    startDateBtn.tag = 0;
    [dateView addSubview:startDateBtn];
    [startDateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dateView.mas_centerY);
        make.left.equalTo(dateView.mas_left).with.offset(RESIZE_UI(15));
        make.width.mas_offset(RESIZE_UI(100));
        make.height.mas_offset(RESIZE_UI(35));
    }];
    
    UILabel *labelForTag = [[UILabel alloc]init];
    labelForTag.text = @"至";
    labelForTag.font = [UIFont systemFontOfSize:RESIZE_UI(11)];
    labelForTag.backgroundColor = RGBA(235, 235, 237, 1.0);
    [dateView addSubview:labelForTag];
    [labelForTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(startDateBtn.mas_centerY);
        make.left.equalTo(startDateBtn.mas_right).with.offset(RESIZE_UI(15));
    }];
    
    endDateBtn = [[UIButton alloc]init];
    [endDateBtn setTitle:dateString forState:UIControlStateNormal];
    [endDateBtn setTitleColor:RGBA(125, 125, 125, 1.0) forState:UIControlStateNormal];
    endDateBtn.layer.borderWidth = 1.0f;
    endDateBtn.layer.borderColor = RGBA(168, 168, 168, 1.0).CGColor;
    endDateBtn.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(11)];
    [endDateBtn addTarget:self action:@selector(showPickView:) forControlEvents:UIControlEventTouchUpInside];
    endDateBtn.tag = 1;
    [dateView addSubview:endDateBtn];
    [endDateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dateView.mas_centerY);
        make.left.equalTo(labelForTag.mas_right).with.offset(RESIZE_UI(15));
        make.width.mas_offset(RESIZE_UI(100));
        make.height.mas_offset(RESIZE_UI(35));
    }];
    
    UIButton *searchBtn = [[UIButton alloc]init];
    [searchBtn setTitle:@"查询" forState:UIControlStateNormal];
    [searchBtn setTitleColor:RGBA(75, 75, 75, 1.0) forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchMethod) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.layer.borderWidth = 1.0f;
    searchBtn.layer.borderColor = RGBA(75, 75, 75, 1.0).CGColor;
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [dateView addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(dateView.mas_centerY);
        make.right.equalTo(dateView.mas_right).with.offset(-RESIZE_UI(15));
        make.height.mas_offset(RESIZE_UI(25));
        make.width.mas_offset(RESIZE_UI(50));
    }];
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = RGBA(239, 239, 244, 1.0);
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[MyselfTransCell class] forCellReuseIdentifier:@"cell"];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
//    //当tradeArray为空时
//    [self tradeNilMethod];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MobClick beginLogPageView:@"MyselfTransactionController"];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MyselfTransactionController"];
}

- (void)configView {
    _tradeArray = [NSMutableArray array];
    
    if ([_isWithDraw isEqualToString:@"yes"]) {
        /* 提现查询 */
        [self withDrawInterface];
    } else {
        /* 充值记录 */
        [self rechargeInterface];
    }
    //tradeArray为空时
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
    [btn setTitleColor:BASECOLOR forState:UIControlStateNormal];
    if ([btn.titleLabel.text isEqualToString:@"充值"]) {
        _type = 0;
        [UIView animateWithDuration:.3 animations:^{
            _redLine.frame = CGRectMake(0, RESIZE_UI(48), SCREEN_WIDTH / 3, RESIZE_UI(2));
            UIButton *button2 = (UIButton *)[_aView viewWithTag:102];
            [button2 setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
            UIButton *button3 = (UIButton *)[_aView viewWithTag:103];
            [button3 setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
        } completion:nil];
        [_tradeArray removeAllObjects];
        //充值接口
        [self rechargeInterface];
    }
    if ([btn.titleLabel.text isEqualToString:@"交易"]) {
        _type = 1;
        [UIView animateWithDuration:.3 animations:^{
            _redLine.frame = CGRectMake(SCREEN_WIDTH / 3, RESIZE_UI(48), SCREEN_WIDTH / 3, RESIZE_UI(2));
            UIButton *button1 = (UIButton *)[_aView viewWithTag:101];
            [button1 setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
            UIButton *button3 = (UIButton *)[_aView viewWithTag:103];
            [button3 setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
        } completion:nil];
        [_tradeArray removeAllObjects];
        //交易接口
        [self tradeInterface];
    }
    if ([btn.titleLabel.text isEqualToString:@"提现"]) {
        _type = 2;
        [UIView animateWithDuration:.3 animations:^{
            _redLine.frame = CGRectMake(SCREEN_WIDTH / 3 * 2, RESIZE_UI(48), SCREEN_WIDTH / 3, RESIZE_UI(2));
            UIButton *button1 = (UIButton *)[_aView viewWithTag:101];
            [button1 setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
            UIButton *button2 = (UIButton *)[_aView viewWithTag:102];
            [button2 setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
        } completion:nil];
        [_tradeArray removeAllObjects];
        //提现接口
        [self withDrawInterface];
    }
    //tradeArray为空时
    [self tradeNilMethod];
}

#pragma mark - 充值接口
- (void)rechargeInterface {
    NetManager *manager = [[NetManager alloc] init];
    _tradeArray = [[NSMutableArray alloc]init];
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSLog(@"开始时间;%@",_dateArray[1]);
    NSLog(@"结束时间:%@",_dateArray[0]);
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
            //当tradeArray为空时
            [self tradeNilMethod];
            [_tableView reloadData];
        } else {
            [SVProgressHUD dismiss];
            NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            [SVProgressHUD dismiss];
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
            [alertView show];
        }
    }];
}

#pragma mark - 交易接口
- (void)tradeInterface {
    NetManager *manager = [[NetManager alloc] init];
    _tradeArray = [[NSMutableArray alloc]init];
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
            //当tradeArray为空时
            [self tradeNilMethod];
            [_tableView reloadData];
        } else {
            [SVProgressHUD dismiss];
            NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            [SVProgressHUD dismiss];
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
            [alertView show];
        }
    }];

}

#pragma mark - 提现接口
- (void)withDrawInterface {
    NetManager *manager = [[NetManager alloc] init];
    _tradeArray = [[NSMutableArray alloc]init];
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
            //当tradeArray为空时
            [self tradeNilMethod];
            [_tableView reloadData];
        } else {
            [SVProgressHUD dismiss];
            NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            [SVProgressHUD dismiss];
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
            [alertView show];
        }
    }];
}

- (NSString *)updateDateStyle:(NSString *)date{
    NSString *updateStyle = [date stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return updateStyle;
}

- (NSString *)conbineStartDate:(NSString *)startDate {
    NSString *startStr = [NSString stringWithFormat:@"%@000000",startDate];
    return startStr;
}

- (NSString *)conbineEndDate:(NSString *)endDate {
    NSString *endStr = [NSString stringWithFormat:@"%@235959",endDate];
    return endStr;
}

#pragma mark - tradeArray为空时
- (void)tradeNilMethod {
    if (_tradeArray.count == 0) {
        if (!tipLabel) {
            tipLabel = [[UILabel alloc]init];
            tipLabel.text = @"没有数据";
            tipLabel.textColor = RGBA(128, 128, 128, 1.0);
            tipLabel.font = [UIFont systemFontOfSize:RESIZE_UI(25)];
            [_tableView addSubview:tipLabel];
            [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_tableView.mas_centerX);
                make.centerY.equalTo(_tableView.mas_centerY);
            }];
        }
    } else {
        [tipLabel removeFromSuperview];
        tipLabel = nil;
    }
}

#pragma mark - 查询
- (void)searchMethod {
    if (_type==0) {
        [self rechargeInterface];
    } else if(_type==1){
        [self tradeInterface];
    } else {
        [self withDrawInterface];
    }
}

#pragma mark - UITableView -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tradeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TradeModel *model = _tradeArray[indexPath.row];
    MyselfTransCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RESIZE_UI(70);
}

- (void)showPickView:(UIButton *)btn {
    
    if (btn.tag == 0) {
        _isStart = YES;
    } else {
        _isStart = NO;
    }
    _backView = [[UIView alloc]init];
    [self.view addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-RESIZE_UI(290));
    }];
    
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod)];
    [_backView addGestureRecognizer:_tap];
    if(!_datePickSelectView){
        _datePickSelectView = [[DatePickSelectView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, RESIZE_UI(290))];
        _datePickSelectView.delegate = self;
        [self.view addSubview:_datePickSelectView];
    }
    [UIView animateWithDuration:0.5 animations:^{
        _datePickSelectView.frame = CGRectMake(0, SCREEN_HEIGHT-RESIZE_UI(290), SCREEN_WIDTH, RESIZE_UI(290));
    }];
    
}

- (void)tapMethod {
    [_backView removeGestureRecognizer:_tap];
    _tap = nil;
    [_backView removeFromSuperview];
    _backView = nil;
    [UIView animateWithDuration:0.5 animations:^{
        _datePickSelectView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, RESIZE_UI(290));
    }];
}

#pragma DatePickSelectView Delegate
- (void)confirmSelectDate:(NSString *)date {
//    NSLog(@"我的日子：%@",date);
    NSString *dateString = [self updateDateStyle:date];
    if (_isStart) {
        NSString *startDate = [self conbineStartDate:dateString];
        _dateArray[1] = startDate;
        [startDateBtn setTitle:date forState:UIControlStateNormal];
    } else {
        NSString *endDate = [self conbineEndDate:dateString];
        _dateArray[0] = endDate;
        [endDateBtn setTitle:date forState:UIControlStateNormal];
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
