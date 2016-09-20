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

@property (weak, nonatomic) IBOutlet UITableView *nounTable;
@property (nonatomic, strong) NSMutableArray *nounExplanArray;
@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, copy) NSArray *contentArray;

@end

@implementation NounExplanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.title = @"名词解释";
    
    _nounExplanArray = [NSMutableArray array];
    NSDictionary *nounDic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NounExplanViewController.plist" ofType:nil]];
    _titleArray = [NSArray arrayWithArray:[nounDic allKeys]];
    _contentArray = [NSArray arrayWithArray:[nounDic allValues]];
    
    [_nounTable registerNib:[UINib nibWithNibName:@"NounExplanViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
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
