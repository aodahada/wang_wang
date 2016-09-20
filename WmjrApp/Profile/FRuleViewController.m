//
//  FRuleViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 16/1/28.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "FRuleViewController.h"

@interface FRuleViewController ()

@property (weak, nonatomic) IBOutlet UILabel *FRContent;

@end

@implementation FRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"奖励规则";
    self.tabBarController.tabBar.hidden = YES;
    _FRContent.text = [NSString stringWithFormat:@"%@ \n %@", @"（1） 旺马财富的好友奖励采用一级奖励制度，您推荐的好友投资成功后，您都会获得一定比例的奖励，具体计算公式为：我的奖励=好友投资收益*6% ;", @"（2）您的好友投资成功后（产品募集结束还款）， 在“ 即将获得的收益” 将自动显示；"];
    _FRContent.textColor = TITLE_COLOR;
    
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
