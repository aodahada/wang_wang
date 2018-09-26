//
//  EarningsViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/30.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "EarningsViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "EarningListModel.h"
#import "EarnTableViewCell.h"

@interface EarningsViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong)UIButton *leftButton;
@property (nonatomic, strong)UIButton *rightButton;
@property (nonatomic, strong)UITableView *mainTableView;
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, assign)NSInteger currentPage;
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation EarningsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收益明细";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _type = 0;
    _currentPage = 1;
    [self setUpLayout];
    //获取累计奖励金额
    [self getLiJiRewardMethod:1];
    
}

#pragma mark - 布局
- (void)setUpLayout {
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = RGBA(242, 242, 242, 1.0);
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(RESIZE_UI(55));
    }];
    
    UIView *buttonView = [[UIView alloc]init];
    buttonView.backgroundColor = RGBA(242, 242, 242, 1.0);
    [topView addSubview:buttonView];
    [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.centerY.equalTo(topView.mas_centerY);
        make.width.mas_offset(RESIZE_UI(200));
        make.height.mas_offset(RESIZE_UI(30));
    }];
    
    _leftButton = [[UIButton alloc]init];
    [_leftButton setTitle:@"累计财友奖励" forState:UIControlStateNormal];
    _leftButton.tag = 0;
    _leftButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
    _leftButton.layer.borderWidth = 2;
    _leftButton.layer.borderColor = FOURNAVBARCOLOR.CGColor;
    [_leftButton setBackgroundColor:FOURNAVBARCOLOR];
    [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(clickButtonType:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:_leftButton];
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonView.mas_top);
        make.left.equalTo(buttonView.mas_left);
        make.bottom.equalTo(buttonView.mas_bottom);
        make.width.mas_offset(RESIZE_UI(100));
    }];
    
    _rightButton = [[UIButton alloc]init];
    [_rightButton setTitle:@"累计出借收益" forState:UIControlStateNormal];
    _rightButton.tag = 1;
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
    _rightButton.layer.borderWidth = 2;
    _rightButton.layer.borderColor = FOURNAVBARCOLOR.CGColor;
    [_rightButton setBackgroundColor:RGBA(242, 242, 242, 1.0)];
    [_rightButton setTitleColor:FOURNAVBARCOLOR forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(clickButtonType:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:_rightButton];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttonView.mas_top);
        make.right.equalTo(buttonView.mas_right);
        make.bottom.equalTo(buttonView.mas_bottom);
        make.left.equalTo(_leftButton.mas_right);
    }];
    
    UIView *titleView = [[UIView alloc]init];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(RESIZE_UI(42));
    }];
    
    UILabel *userTitleLabel = [[UILabel alloc]init];
    userTitleLabel.text = @"金额(元)";
    userTitleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [titleView addSubview:userTitleLabel];
    [userTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.mas_centerY);
        make.left.equalTo(titleView.mas_left).with.offset(RESIZE_UI(60));
    }];
    
    UILabel *timeTitleLabel = [[UILabel alloc]init];
    timeTitleLabel.text = @"时间";
    timeTitleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [titleView addSubview:timeTitleLabel];
    [timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.mas_centerY);
        make.right.equalTo(titleView.mas_right).with.offset(-RESIZE_UI(80));
    }];
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = RGBA(242, 242, 242, 1.0);
    [self.view addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(1);
    }];
    
    _mainTableView = [[UITableView alloc]init];
    _mainTableView.tableFooterView = [[UIView alloc]init];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.emptyDataSetSource = self;
    _mainTableView.emptyDataSetDelegate = self;
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    _dataArray = [[NSMutableArray alloc]init];
    @weakify(self)
    _mainTableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self)
        _currentPage = 1;
        _dataArray = [[NSMutableArray alloc]init];
        if (_type == 0) {
            [self getLiJiRewardMethod:_currentPage];
        } else {
            [self getLiJiInvestMethod:_currentPage];
        }
    }];
    
    _mainTableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        @strongify(self)
        _currentPage++;
        if (_type == 0) {
            [self getLiJiRewardMethod:_currentPage];
        } else {
            [self getLiJiInvestMethod:_currentPage];
        }
    }];
    
}

- (void)clickButtonType:(UIButton *)btn {
    switch (btn.tag) {
        case 0:
        {
            _type = 0;
            [_leftButton setBackgroundColor:FOURNAVBARCOLOR];
            [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_rightButton setBackgroundColor:RGBA(242, 242, 242, 1.0)];
            [_rightButton setTitleColor:FOURNAVBARCOLOR forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            _type = 1;
            [_rightButton setBackgroundColor:FOURNAVBARCOLOR];
            [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_leftButton setBackgroundColor:RGBA(242, 242, 242, 1.0)];
            [_leftButton setTitleColor:FOURNAVBARCOLOR forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    [_mainTableView.mj_header beginRefreshing];
}

#pragma mark - 获取累计奖励金额
- (void)getLiJiRewardMethod:(NSInteger)page {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Income/award" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid,@"page":@(page)} withBlock:^(id obj) {
        [SVProgressHUD dismiss];
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSArray *data = obj[@"data"];
            for (int i=0; i<data.count; i++) {
                NSDictionary *dic = data[i];
                EarningListModel *earnModel = [EarningListModel mj_objectWithKeyValues:dic];
                [_dataArray addObject:earnModel];
            }
            [_mainTableView reloadData];
        } else {
            NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            [SVProgressHUD dismiss];
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
            [alertView show];
        }
        [_mainTableView.mj_header endRefreshing];
        [_mainTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 获取累计出借收益
- (void)getLiJiInvestMethod:(NSInteger)page {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Income/invest" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid,@"page":@(page)} withBlock:^(id obj) {
        [SVProgressHUD dismiss];
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSArray *data = obj[@"data"];
            for (int i=0; i<data.count; i++) {
                NSDictionary *dic = data[i];
                EarningListModel *earnModel = [EarningListModel mj_objectWithKeyValues:dic];
                [_dataArray addObject:earnModel];
            }
            [_mainTableView reloadData];
        } else {
            NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            [SVProgressHUD dismiss];
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
            [alertView show];
        }
        [_mainTableView.mj_header endRefreshing];
        [_mainTableView.mj_footer endRefreshing];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RESIZE_UI(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EarningListModel *model = _dataArray[indexPath.row];
    EarnTableViewCell *cell = [[EarnTableViewCell alloc]initWithEarnModel:model];
    return cell;
}

#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
//    return [UIImage imageNamed:@"icon_zwjl"];
    return nil;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无记录";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
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
