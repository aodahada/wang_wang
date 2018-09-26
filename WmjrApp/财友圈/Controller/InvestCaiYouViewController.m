//
//  InvestCaiYouViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/28.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "InvestCaiYouViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "CaiYouTableViewCell.h"
#import "MyReCommandModel.h"

@interface InvestCaiYouViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *caiyouArray;//财友数组
@property (nonatomic, strong)UITableView *mainTableView;

@end

@implementation InvestCaiYouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"邀请财友人数";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getCaiYouListMethod];
}

#pragma mark - 获取财友列表
- (void)getCaiYouListMethod {
        
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];//8996
    [manager postDataWithUrlActionStr:@"User/invite" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            _caiyouArray = [[NSMutableArray alloc]init];
            NSArray *arrayForList = obj[@"data"];
            for (int i=0; i<arrayForList.count; i++) {
                NSDictionary *dicForModel = arrayForList[i];
                MyReCommandModel *myRecommandModel = [MyReCommandModel mj_objectWithKeyValues:dicForModel];
                [_caiyouArray addObject:myRecommandModel];
            }
            [self setUpLayout];
            [SVProgressHUD dismiss];
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

#pragma mark - 界面布局
- (void)setUpLayout {
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(RESIZE_UI(50));
    }];
    
    UILabel *userTitleLabel = [[UILabel alloc]init];
    userTitleLabel.text = @"用户名";
    userTitleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [topView addSubview:userTitleLabel];
    [userTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(topView.mas_left).with.offset(RESIZE_UI(90));
    }];
    
    UILabel *timeTitleLabel = [[UILabel alloc]init];
    timeTitleLabel.text = @"时间";
    timeTitleLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    [topView addSubview:timeTitleLabel];
    [timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView.mas_centerY);
        make.right.equalTo(topView.mas_right).with.offset(-RESIZE_UI(80));
    }];
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = RGBA(242, 242, 242, 1.0);
    [self.view addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(2);
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
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _caiyouArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RESIZE_UI(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyReCommandModel *model = _caiyouArray[indexPath.row];
    CaiYouTableViewCell *cell = [[CaiYouTableViewCell alloc]initWithReCommandModel:model withRow:indexPath.row];
    return cell;
}

#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"icon_zwjl"];
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
