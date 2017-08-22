//
//  MyUnuseRedPackageViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/8/22.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "MyUnuseRedPackageViewController.h"
#import "RedPackageModel.h"
#import "MyRedPackageTableViewCell.h"

@interface MyUnuseRedPackageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *redPackageArray;

@end

@implementation MyUnuseRedPackageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已失效红包";
    self.view.backgroundColor = RGBA(243, 244, 246, 1.0);
    
    [self getDataMethod];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"MyUnuseRedPackageViewController"];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MyUnuseRedPackageViewController"];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - 获取红包数据
- (void)getDataMethod {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    [manager postDataWithUrlActionStr:@"Redpacket/my" withParamDictionary:@{@"member_id":@"90221",@"status":@"1"} withBlock:^(id obj) {
        _redPackageArray = [[NSMutableArray alloc]init];
        if (obj) {
            if ([obj[@"result"] isEqualToString:@"1"]) {
                NSArray *dataArray = obj[@"data"];
                for (int i=0; i<dataArray.count; i++) {
                    NSDictionary *dict = dataArray[i];
                    RedPackageModel *redPackageModel = [RedPackageModel mj_objectWithKeyValues:dict];
                    [_redPackageArray addObject:redPackageModel];
                }
                
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
                    make.bottom.equalTo(self.view.mas_bottom);
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
    MyRedPackageTableViewCell *cell = [[MyRedPackageTableViewCell alloc]initWithModel:redPackageModel andIsOut:YES];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
