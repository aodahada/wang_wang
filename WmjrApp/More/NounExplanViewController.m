//
//  NounExplanViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/11/24.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "NounExplanViewController.h"
#import "NounExplanViewCell.h"

@interface NounExplanViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *nounExplanArray;
@property (nonatomic, copy) NSMutableArray *titleArray;
@property (nonatomic, copy) NSMutableArray *contentArray;

@end

@implementation NounExplanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.title = @"名词解释";
    [self loadRequestData];
    
}

#pragma mark - 获取资金账户数据
- (void)loadRequestData {
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"Page/knowledge" withParamDictionary:@{@"type":@"term"} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            NSArray *dataArray = obj[@"data"];
            _titleArray = [[NSMutableArray alloc]init];
            _contentArray = [[NSMutableArray alloc]init];
            for (int i=0; i<dataArray.count; i++) {
                NSDictionary *dict = dataArray[i];
                [_titleArray addObject:dict[@"title"]];
                [_contentArray addObject:dict[@"content"]];
            }
            _mainTableView = [[UITableView alloc]init];
            _mainTableView.delegate = self;
            _mainTableView.dataSource = self;
            [_mainTableView registerNib:[UINib nibWithNibName:@"NounExplanViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
            _mainTableView.tableFooterView = [[UIView alloc]init];
            [self.view addSubview:_mainTableView];
            [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
            
            
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma uitableView - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NounExplanViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.indexBtn setTitle:[NSString stringWithFormat:@"%ld", indexPath.section + 1] forState:UIControlStateNormal];
    cell.nounLab.text = _titleArray[indexPath.section];
    cell.complainLab.text = _contentArray[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *contentStr = _contentArray[indexPath.section];
    CGFloat height = [contentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil].size.height;
    return height + 70;
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
