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
@property (weak, nonatomic) IBOutlet UILabel *hongbaoBenXi;//top红包本息
@property (weak, nonatomic) IBOutlet UILabel *hongbaoLabel;//top红包label


@end

@implementation TrandDetailViewController

- (void)setUpNavigationBar {
    self.title = @"交易详情";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationBar];
    
    _name.text = self.nameStr;
    _earnTotal.text = self.earnToatl;
    _hongbaoBenXi.font = [UIFont systemFontOfSize:RESIZE_UI(16)];
    if ([self.redpacket isEqualToString:@"0"]) {
        _hongbaoBenXi.hidden = YES;
        _hongbaoLabel.hidden = YES;
        
    } else {
        _hongbaoBenXi.hidden = NO;
        _hongbaoLabel.hidden = NO;
        _hongbaoBenXi.text = [NSString stringWithFormat:@"+%@(元)",self.redpacket];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"TrandDetailViewController"];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"TrandDetailViewController"];
}

#pragma mark - uitableview -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.redpacket isEqualToString:@"0"]) {
        return 6;
    } else {
        return 7;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier  = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
    }
    if ([self.redpacket isEqualToString:@"0"]) {
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"投资金额  (元)";
                cell.detailTextLabel.text = self.totalNum;
                cell.detailTextLabel.textColor = AUXILY_COLOR;
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"代收本息  (元)";
                cell.detailTextLabel.text = self.earnNum;
                cell.detailTextLabel.textColor = AUXILY_COLOR;
            }
                break;
            case 2:
            {
                cell.textLabel.text = @"预期年化收益  (%)";
                UILabel *jiaxiLabel = [[UILabel alloc]init];
                double returnrate_plus = [self.returnrate_plus doubleValue];
                if ([[SingletonManager convertNullString:self.returnrate_plus] isEqualToString:@"0"]) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%g", [self.earnP floatValue] * 100];
                    cell.detailTextLabel.textColor = AUXILY_COLOR;
                } else {
//                    NSNumber *returnrate_plusNumber = [NSNumber numberWithDouble:returnrate_plus*100];
//                    NSString *returnrate_plusStr = [NSString stringWithFormat:@"%@％",returnrate_plusNumber];
                    jiaxiLabel.text = [NSString stringWithFormat:@"+%g",returnrate_plus*100];
                    jiaxiLabel.textColor = [UIColor redColor];
                    jiaxiLabel.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
                    [cell addSubview:jiaxiLabel];
                    [jiaxiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(cell.mas_centerY);
                        make.right.equalTo(cell.mas_right).with.offset(-RESIZE_UI(10));
                    }];
                    
                    UILabel *yearEarn = [[UILabel alloc]init];
                    yearEarn.text = [NSString stringWithFormat:@"%g", ([self.earnP doubleValue]-returnrate_plus) * 100];
                    yearEarn.textColor = AUXILY_COLOR;
                    yearEarn.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
                    [cell addSubview:yearEarn];
                    [yearEarn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(cell.mas_centerY);
                        make.right.equalTo(jiaxiLabel.mas_left).with.offset(-RESIZE_UI(5));
                    }];
                }
                
            }
                break;
            case 3:
            {
                cell.textLabel.text = @"购买日期";
                cell.detailTextLabel.textColor = COLOR_WITH_HEX(0xFF6405);
                cell.detailTextLabel.text = self.createtime;
            }
                break;
            case 4:
            {
                cell.textLabel.text = @"结息日期";
                cell.detailTextLabel.textColor = COLOR_WITH_HEX(0xFF6405);
                cell.detailTextLabel.text = self.duedate;
            }
                break;
            case 5:
            {
                cell.textLabel.text = @"最后还款日期";
                cell.detailTextLabel.text = self.expirydate;
                [cell.detailTextLabel setTextColor:RGBA(255, 100, 5, 1.0)];
            }
                break;
                
            default:
                break;
        }

    } else {
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"投资金额  (元)";
                cell.detailTextLabel.text = self.totalNum;
                cell.detailTextLabel.textColor = AUXILY_COLOR;
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"代收本息  (元)";
                cell.detailTextLabel.text = self.earnNum;
                cell.detailTextLabel.textColor = AUXILY_COLOR;
            }
                break;
            case 2:
            {
                cell.textLabel.text = @"红包本息";
                cell.detailTextLabel.text = self.redpacket;
                cell.detailTextLabel.textColor = AUXILY_COLOR;
            }
                break;
            case 3:
//            {
//                cell.textLabel.text = @"预期年化收益  (%)";
//                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", [self.earnP floatValue] * 100];
//                cell.detailTextLabel.textColor = AUXILY_COLOR;
//            }
//                break;
            {
                cell.textLabel.text = @"预期年化收益  (%)";
                UILabel *jiaxiLabel = [[UILabel alloc]init];
                double returnrate_plus = [self.returnrate_plus doubleValue];
                if ([[SingletonManager convertNullString:self.returnrate_plus] isEqualToString:@"0"]) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%g", [self.earnP floatValue] * 100];
                    cell.detailTextLabel.textColor = AUXILY_COLOR;
                } else {
                    jiaxiLabel.text = [NSString stringWithFormat:@"+%g",returnrate_plus*100];
                    jiaxiLabel.textColor = [UIColor redColor];
                    jiaxiLabel.font = [UIFont systemFontOfSize:RESIZE_UI(13)];
                    [cell addSubview:jiaxiLabel];
                    [jiaxiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(cell.mas_centerY);
                        make.right.equalTo(cell.mas_right).with.offset(-RESIZE_UI(10));
                    }];
                    
                    UILabel *yearEarn = [[UILabel alloc]init];
                    yearEarn.text = [NSString stringWithFormat:@"%g", ([self.earnP doubleValue]-returnrate_plus) * 100];
                    yearEarn.textColor = AUXILY_COLOR;
                    yearEarn.font = [UIFont systemFontOfSize:RESIZE_UI(15)];
                    [cell addSubview:yearEarn];
                    [yearEarn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(cell.mas_centerY);
                        make.right.equalTo(jiaxiLabel.mas_left).with.offset(-RESIZE_UI(5));
                    }];
                }
                
            }
                break;
            case 4:
            {
                cell.textLabel.text = @"购买日期";
                cell.detailTextLabel.textColor = COLOR_WITH_HEX(0xFF6405);
                cell.detailTextLabel.text = self.createtime;
            }
                break;
            case 5:
            {
                cell.textLabel.text = @"结息日期";
                cell.detailTextLabel.textColor = COLOR_WITH_HEX(0xFF6405);
                cell.detailTextLabel.text = self.duedate;
            }
                break;
            case 6:
            {
                cell.textLabel.text = @"最后还款日期";
                cell.detailTextLabel.text = self.expirydate;
                [cell.detailTextLabel setTextColor:RGBA(255, 100, 5, 1.0)];
            }
                break;
                
            default:
                break;
        }

    }
    cell.textLabel.textColor = TITLE_COLOR;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RESIZE_UI(60);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = [UIColor whiteColor];
    
    UILabel *prompt = [[UILabel alloc] init];
    prompt.text = @"注:(还款如果遇到节假日,则还款日期顺延)";
    prompt.textAlignment = NSTextAlignmentLeft;
    prompt.textColor = AUXILY_COLOR;
    prompt.font = [UIFont systemFontOfSize:12.0f];
    [aView addSubview:prompt];
    [prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(aView.mas_centerX);
        make.centerY.equalTo(aView.mas_centerY);
    }];
    
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
