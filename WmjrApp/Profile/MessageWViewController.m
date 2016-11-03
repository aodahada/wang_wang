//
//  MessageWViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/11/20.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "MessageWViewController.h"
#import "MessageViewCell.h"
#import "MessageModel.h"

@interface MessageWViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *messTbale;
@property (nonatomic, strong) NSMutableArray *messArray;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation MessageWViewController

- (void)dealloc {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    _messArray = [NSMutableArray array];
    
    [_messTbale registerNib:[UINib nibWithNibName:@"MessageViewCell" bundle:nil] forCellReuseIdentifier:@"messCell"];
    _messTbale.tableFooterView = [[UIView alloc]init];
    
    //下拉刷新
    _messTbale.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self getDataWithNetManager:self.currentPage];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _messTbale.mj_header.automaticallyChangeAlpha = YES;
    
    _messTbale.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage ++;
        [self getDataWithNetManager:self.currentPage];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getDataWithNetManager:1];
}

#pragma mark - 数据处理 －
- (void)getDataWithNetManager:(NSInteger)currentPage {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"消息获取中"];
    [manager postDataWithUrlActionStr:@"User/msg" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid, @"page":@(currentPage), @"size":@""} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            [SVProgressHUD dismiss];
            NSArray *array = [MessageModel mj_keyValuesArrayWithObjectArray:obj[@"data"]];
            for (NSDictionary *dic in array) {
                MessageModel *messageModel = [[MessageModel alloc] init];
                [messageModel mj_setKeyValues:dic];
                [_messArray addObject:messageModel];
            }
            [_messTbale reloadData];
            if (_messArray.count == 0) {
                UILabel *lable =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
                lable.center = self.view.center;
                lable.textColor = [UIColor grayColor];
                lable.text = @"暂无消息";
                lable.textAlignment = NSTextAlignmentCenter;
                lable.font = [UIFont systemFontOfSize:15.0f];
                [self.view addSubview:lable];
            }
            [_messTbale.mj_header endRefreshing];
            [_messTbale.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - uitableView -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *model = _messArray[indexPath.row];
    MessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([model.type isEqualToString:@"1"]) {
        cell.cerLab.text = @"充值";
    } else if ([model.type isEqualToString:@"2"]) {
        cell.cerLab.text = @"提现";
    } else if ([model.type isEqualToString:@"3"]) {
        cell.cerLab.text = @"购入";
    } else if ([model.type isEqualToString:@"4"]) {
        cell.cerLab.text = @"赎回";
    } else {
        cell.cerLab.text = @"其他消息";
    }
    cell.introLab.text = model.content;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
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
