//
//  MoneyOrderMainViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/11/17.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "MoneyOrderMainViewController.h"
#import "ImmediatelyMoneyOrderViewController.h"
#import "ApplyRecordViewController.h"

@interface MoneyOrderMainViewController ()

@end

@implementation MoneyOrderMainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我有汇票";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"申请记录" style:UIBarButtonItemStylePlain target:self action:@selector(watchApplyRecord)];
    [rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:RESIZE_UI(15)], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self setUpLayout];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - 查看申请记录
- (void)watchApplyRecord {
    ApplyRecordViewController *applyRecordVC = [[ApplyRecordViewController alloc]init];
    [self.navigationController pushViewController:applyRecordVC animated:YES];
}

#pragma mark - 界面布局
- (void)setUpLayout {
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.image = [UIImage imageNamed:@"image_banner"];
    [self.view addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(RESIZE_UI(180));
    }];
    
    UIButton *personalButton = [[UIButton alloc]init];
    [personalButton setBackgroundImage:[UIImage imageNamed:@"image_geren"] forState:UIControlStateNormal];
    [personalButton addTarget:self action:@selector(jumpToImmediatelyApplyPersonal) forControlEvents:UIControlEventTouchUpInside];
    [personalButton setAdjustsImageWhenHighlighted:NO];
    [self.view addSubview:personalButton];
    [personalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImageView.mas_bottom).with.offset(RESIZE_UI(38));
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_offset(RESIZE_UI(258));
        make.height.mas_offset(RESIZE_UI(125));
    }];
    
    UIButton *enterpriseButton = [[UIButton alloc]init];
    [enterpriseButton setBackgroundImage:[UIImage imageNamed:@"image_qiye"] forState:UIControlStateNormal];
    [enterpriseButton addTarget:self action:@selector(jumpToImmediatelyApplyEnterprise) forControlEvents:UIControlEventTouchUpInside];
    [enterpriseButton setAdjustsImageWhenHighlighted:NO];
    [self.view addSubview:enterpriseButton];
    [enterpriseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(personalButton.mas_bottom).with.offset(RESIZE_UI(10));
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_offset(RESIZE_UI(258));
        make.height.mas_offset(RESIZE_UI(125));
    }];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.textColor = RGBA(139, 139, 139, 1.0);
    tipLabel.text = @"备注:票据融资平台隶属上海旺马平台票据事业部";
    tipLabel.font = [UIFont systemFontOfSize:RESIZE_UI(12)];
    tipLabel.numberOfLines = 2;
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(enterpriseButton.mas_bottom).with.offset(RESIZE_UI(7));
        make.left.equalTo(enterpriseButton.mas_left).with.offset(RESIZE_UI(10));
        make.right.equalTo(enterpriseButton.mas_right);
    }];
    
}

#pragma mark - 跳转立即申请(个人)
- (void)jumpToImmediatelyApplyPersonal {
    ImmediatelyMoneyOrderViewController *immediatelyVC = [[ImmediatelyMoneyOrderViewController alloc]init];
    immediatelyVC.identifier = 1;
    [self.navigationController pushViewController:immediatelyVC animated:YES];
}

#pragma mark - 跳转立即申请(企业)
- (void)jumpToImmediatelyApplyEnterprise {
    ImmediatelyMoneyOrderViewController *immediatelyVC = [[ImmediatelyMoneyOrderViewController alloc]init];
    immediatelyVC.identifier = 2;
    [self.navigationController pushViewController:immediatelyVC animated:YES];
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
