//
//  CapitalAccountViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/12/28.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "CapitalAccountViewController.h"
#import "CapitalAccountViewCell.h"

@interface CapitalAccountViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSMutableArray *quesArray; /*   */
@property (nonatomic, copy) NSMutableArray *ansArray; /*  */
@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation CapitalAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tabBarController.tabBar.hidden = YES;
    self.title = @"资金账户";
    [self loadRequestData];
    
}

#pragma mark - 获取资金账户数据
- (void)loadRequestData {
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"Page/knowledge" withParamDictionary:@{@"type":@"question"} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSArray *dataArray = obj[@"data"];
            _quesArray = [[NSMutableArray alloc]init];
            _ansArray = [[NSMutableArray alloc]init];
            for (int i=0; i<dataArray.count; i++) {
                NSDictionary *dict = dataArray[i];
                [_quesArray addObject:dict[@"title"]];
                [_ansArray addObject:dict[@"content"]];
            }
            _mainTableView = [[UITableView alloc]init];
            _mainTableView.delegate = self;
            _mainTableView.dataSource = self;
            [_mainTableView registerNib:[UINib nibWithNibName:@"CapitalAccountViewCell" bundle:nil] forCellReuseIdentifier:@"captial"];
            _mainTableView.tableFooterView = [[UIView alloc]init];
            [self.view addSubview:_mainTableView];
            [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
            
            
        }
    }];
}

#pragma mark - uitableview - 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _quesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CapitalAccountViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"captial" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.indexCap setTitle:[NSString stringWithFormat:@"%ld", indexPath.section + 1] forState:UIControlStateNormal];
    cell.questionLab.text = _quesArray[indexPath.section];
    cell.ansLab.text = _ansArray[indexPath.section];
    
    if (indexPath.section == 28
        || indexPath.section == 20) {
        cell.ansLab.font = [UIFont systemFontOfSize:14.0];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *contentStr = _ansArray[indexPath.section];
    CGFloat height = [contentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil].size.height;
    return 85 + height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2.5;
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
