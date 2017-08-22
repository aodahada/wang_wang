//
//  MyRedPackageViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/8/22.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "MyRedPackageViewController.h"
#import "MyRedPackageTableViewCell.h"
#import "RedPackageModel.h"
#import "MyUnuseRedPackageViewController.h"

@interface MyRedPackageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *redPackageArray;

@end

@implementation MyRedPackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的红包";
    self.view.backgroundColor = RGBA(243, 244, 246, 1.0);
    
    [self getDataMethod];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MyRedPackageViewController"];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MyRedPackageViewController"];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - 获取红包数据
- (void)getDataMethod {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Redpacket/my" withParamDictionary:@{@"member_id":@"90221",@"status":@"2"} withBlock:^(id obj) {
        _redPackageArray = [[NSMutableArray alloc]init];
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                NSArray *dataArray = obj[@"data"];
                for (int i=0; i<dataArray.count; i++) {
                    NSDictionary *dict = dataArray[i];
                    RedPackageModel *redPackageModel = [RedPackageModel mj_objectWithKeyValues:dict];
                    [_redPackageArray addObject:redPackageModel];
                }
                
                
                UIButton *watchButotn = [[UIButton alloc]init];
                [watchButotn setTitle:@"查看失效红包>>" forState:UIControlStateNormal];
                watchButotn.titleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
                [watchButotn setTitleColor:RGBA(0, 104, 178, 1.0) forState:UIControlStateNormal];
                [watchButotn addTarget:self action:@selector(watchUnuseRed) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:watchButotn];
                [watchButotn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view.mas_bottom).with.offset(-RESIZE_UI(12));
                    make.centerX.equalTo(self.view.mas_centerX);
                    make.width.mas_offset(RESIZE_UI(111));
                    make.height.mas_offset(RESIZE_UI(21));
                }];
                
                UITableView *mainTableView = [[UITableView alloc]init];
                [mainTableView registerClass:[MyRedPackageTableViewCell class] forCellReuseIdentifier:@"MyRedPackageTableViewCell"];
                mainTableView.tableFooterView = [[UIView alloc]init];
                mainTableView.backgroundColor = RGBA(243, 244, 246, 1.0);
                mainTableView.delegate = self;
                mainTableView.dataSource = self;
                [self.view addSubview:mainTableView];
                [mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view.mas_top).with.offset(RESIZE_UI(12));
                    make.left.equalTo(self.view.mas_left).with.offset(RESIZE_UI(7));
                    make.right.equalTo(self.view.mas_right).with.offset(-RESIZE_UI(7));
                    make.bottom.equalTo(watchButotn.mas_top).with.offset(-RESIZE_UI(10));
                }];

                
                [SVProgressHUD dismiss];
                return ;
            } else {
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _redPackageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RESIZE_UI(130);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = RGBA(243, 244, 246, 1.0);
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RedPackageModel *redPackageModel = _redPackageArray[indexPath.row];
    MyRedPackageTableViewCell *cell = [[MyRedPackageTableViewCell alloc]initWithModel:redPackageModel andIsOut:NO];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - 查看失效红包
- (void)watchUnuseRed {
    MyUnuseRedPackageViewController *myUnuseVC = [[MyUnuseRedPackageViewController alloc]init];
    [self.navigationController pushViewController:myUnuseVC animated:YES];
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
