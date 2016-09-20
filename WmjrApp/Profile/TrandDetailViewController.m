//
//  TrandDetailViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 16/1/28.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "TrandDetailViewController.h"

@interface TrandDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *trandDetailTable;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *earnTotal;


@end

@implementation TrandDetailViewController

- (void)setUpNavigationBar {
    self.title = @"交易详情";
    /*  设置颜色 */
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.92f green:0.58f blue:0.00f alpha:1.00f];
    /*  设置字体颜色 */
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    /* 渲染颜色 */
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    /*  去掉边线 */
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"piggy"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationBar];
    
    _name.text = self.nameStr;
    _earnTotal.text = self.earnToatl;
}

#pragma mark - uitableview -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier  = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"投资金额  (元)";
            cell.detailTextLabel.text = self.totalNum;;
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"代收本息  (元)";
            cell.detailTextLabel.text = self.earnNum;
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"预期年化收益  (%)";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", [self.earnP floatValue] * 100];
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"购买日期";
            cell.detailTextLabel.text = self.createtime;
        }
            break;
        case 4:
        {
            cell.textLabel.text = @"结息日期";
            cell.detailTextLabel.text = self.duedate;
        }
            break;
        case 5:
        {
            cell.textLabel.text = @"最后还款日期";
            cell.detailTextLabel.text = self.expirydate;
        }
            break;
            
        default:
            break;
    }
    cell.textLabel.textColor = TITLE_COLOR;
    cell.detailTextLabel.textColor = AUXILY_COLOR;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = [UIColor whiteColor];
    
    UILabel *prompt = [[UILabel alloc] initWithFrame:RESIZE_FRAME(CGRectMake(15, 5, 355, 15))];
    prompt.text = @"注:(还款如果遇到节假日,则还款日期顺延)";
    prompt.textAlignment = NSTextAlignmentLeft;
    prompt.textColor = AUXILY_COLOR;
    prompt.font = [UIFont systemFontOfSize:10.0f];
    [aView addSubview:prompt];
    
    return aView;
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
