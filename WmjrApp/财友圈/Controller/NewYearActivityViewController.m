//
//  NewYearActivityViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/1/29.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "NewYearActivityViewController.h"
#import "NewYearRuleViewController.h"

@interface NewYearActivityViewController ()

@end

@implementation NewYearActivityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"新年要畅想 来领年终奖";
    
    UIScrollView *mainScrollView = [[UIScrollView alloc]init];
    mainScrollView.backgroundColor = [UIColor whiteColor];
    mainScrollView.bounces = NO;
    [self.view addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *mainView = [[UIView alloc]init];
    mainView.backgroundColor = [UIColor whiteColor];
    [mainScrollView addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScrollView);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"年终奖详情页"];
    [mainView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainView.mas_top);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(RESIZE_UI(1231));
    }];
    
    [mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageView.mas_bottom);
    }];
    
    UIButton *backButton = [[UIButton alloc]init];
    [backButton addTarget:self action:@selector(investMethod) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(mainView.mas_bottom);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_equalTo(RESIZE_UI(40));
    }];
    
    UIButton *ruleButton = [[UIButton alloc]init];
    [ruleButton addTarget:self action:@selector(watchRule) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:ruleButton];
    [ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(mainView.mas_bottom).with.offset(-RESIZE_UI(50));
        make.right.equalTo(mainView.mas_right);
        make.width.mas_offset(RESIZE_UI(200));
        make.height.mas_offset(RESIZE_UI(40));
    }];
    
}

- (void)watchRule {
    NewYearRuleViewController *newYearVC = [[NewYearRuleViewController alloc]init];
    [self.navigationController pushViewController:newYearVC animated:YES];
}

- (void)investMethod {
    self.tabBarController.selectedIndex = 1;
    [self.navigationController popViewControllerAnimated:YES];
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
