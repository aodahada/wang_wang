//
//  ScordRecordViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/10/19.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "ScordRecordViewController.h"
#import "ScoreRecordCell.h"
#import "ScoreModel.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface ScordRecordViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong)NSMutableArray *scoreArray;//积分数组
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)NSInteger currentPage;

@end

@implementation ScordRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"积分记录";
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentPage = 1;
    _scoreArray = [[NSMutableArray alloc]init];
    [self getScoreRecordMethod];
}

#pragma mark - 获取积分记录
- (void)getScoreRecordMethod {
    NetManager *manager = [[NetManager alloc] init];
    [SVProgressHUD showWithStatus:@"加载中"];
    //[SingletonManager sharedManager].uid
    [manager postDataWithUrlActionStr:@"Score/my" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid,@"page":@(self.currentPage)} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSArray *array = obj[@"data"];
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic = array[i];
                ScoreModel *scoreModel = [ScoreModel mj_objectWithKeyValues:dic];
                [_scoreArray addObject:scoreModel];
            }
            
            self.tableView = [[UITableView alloc]init];
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            self.tableView.emptyDataSetSource = self;
            self.tableView.emptyDataSetDelegate = self;
            self.tableView.tableFooterView = [[UIView alloc]init];
            self.tableView.backgroundColor = RGBA(238, 240, 242, 1.0);
            [self.view addSubview:self.tableView];
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                self.currentPage ++;
                [self getScoreRecordMethod];
            }];
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
            
            if (array.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RESIZE_UI(89);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _scoreArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoreRecordCell *cell = [[ScoreRecordCell alloc]initWithScoreModel:_scoreArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"image_zwhb-2"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无积分记录";
    
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
