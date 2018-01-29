//
//  SortCaiYouViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/28.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "SortCaiYouViewController.h"
#import "SortCaiYouTableViewCell.h"
#import "GetContactPersonList.h"

@interface SortCaiYouViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UIButton *leftButton;
@property (nonatomic, strong)UIButton *rightButton;
@property (nonatomic, strong)UITableView *mainTableView;
@property (nonatomic, copy) NSString *contactListString;
@property (nonatomic, strong) NSMutableArray *contactListArray;

@end

@implementation SortCaiYouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"财友圈";
    self.view.backgroundColor = [UIColor whiteColor];
    //获取通讯录
    _contactListString = [[GetContactPersonList sharedManager] getPeronListMethod];
//    [self setUpLayout];
    
    [self qianchengBangMethod:1];
    
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
    [_leftButton setTitle:@"钱程榜" forState:UIControlStateNormal];
    _leftButton.tag = 0;
    _leftButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
    _leftButton.layer.borderWidth = 2;
    _leftButton.layer.borderColor = NEWYEARCOLOR.CGColor;
    [_leftButton setBackgroundColor:NEWYEARCOLOR];
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
    [_rightButton setTitle:@"人脉榜" forState:UIControlStateNormal];
    _rightButton.tag = 1;
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
    _rightButton.layer.borderWidth = 2;
    _rightButton.layer.borderColor = NEWYEARCOLOR.CGColor;
    [_rightButton setBackgroundColor:RGBA(242, 242, 242, 1.0)];
    [_rightButton setTitleColor:NEWYEARCOLOR forState:UIControlStateNormal];
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
    
    UILabel *indexTitleLabel = [[UILabel alloc]init];
    indexTitleLabel.text = @"排名";
    indexTitleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [titleView addSubview:indexTitleLabel];
    [indexTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.mas_centerY);
        make.left.equalTo(titleView.mas_left).with.offset(RESIZE_UI(20));
    }];
    
    UILabel *userTitleLabel = [[UILabel alloc]init];
    userTitleLabel.text = @"用户名";
    userTitleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [titleView addSubview:userTitleLabel];
    [userTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.mas_centerY);
        make.left.equalTo(titleView.mas_left).with.offset(RESIZE_UI(113));
    }];
    
    UILabel *timeTitleLabel = [[UILabel alloc]init];
    timeTitleLabel.text = @"累计奖励金额(元)";
    timeTitleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [titleView addSubview:timeTitleLabel];
    [timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.mas_centerY);
        make.right.equalTo(titleView.mas_right).with.offset(-RESIZE_UI(30));
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
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    _mainTableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        
    }];
    
    _mainTableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
        
        
    }];
    
}

- (void)clickButtonType:(UIButton *)btn {
    switch (btn.tag) {
        case 0:
        {
            [_leftButton setBackgroundColor:NEWYEARCOLOR];
            [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_rightButton setBackgroundColor:RGBA(242, 242, 242, 1.0)];
            [_rightButton setTitleColor:NEWYEARCOLOR forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
            [_rightButton setBackgroundColor:NEWYEARCOLOR];
            [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_leftButton setBackgroundColor:RGBA(242, 242, 242, 1.0)];
            [_leftButton setTitleColor:NEWYEARCOLOR forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 钱程榜
- (void)qianchengBangMethod:(NSInteger)qianchengPage {
    NetManager *manager = [[NetManager alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"member_id"] = [SingletonManager sharedManager].uid;
    dict[@"contact"] = _contactListString;
    dict[@"page"] = @(qianchengPage);
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Focus/prospect" withParamDictionary:dict withBlock:^(id obj) {
        [SVProgressHUD dismiss];
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSDictionary *dic = obj[@"data"];
            NSLog(@"上传是的海盗成功");
        } else {
            NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
            [alertView show];
        }
    }];
}

#pragma mark - 人脉榜
- (void)renmaiBangMethod:(NSInteger)renmaiPage {
    NetManager *manager = [[NetManager alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"member_id"] = [SingletonManager sharedManager].uid;
    dict[@"contact"] = _contactListString;
    dict[@"page"] = @(renmaiPage);
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Focus/rich" withParamDictionary:dict withBlock:^(id obj) {
        [SVProgressHUD dismiss];
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSDictionary *dic = obj[@"data"];
            NSLog(@"上传是的海盗成功");
        } else {
            NSString *msgStr = [obj[@"data"] objectForKey:@"mes"];
            MMAlertViewConfig *alertConfig = [MMAlertViewConfig globalConfig];
            alertConfig.defaultTextOK = @"确定";
            MMAlertView *alertView = [[MMAlertView alloc] initWithConfirmTitle:@"提示" detail:msgStr];
            [alertView show];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RESIZE_UI(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SortCaiYouTableViewCell *cell = [[SortCaiYouTableViewCell alloc]init];
    return cell;
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
