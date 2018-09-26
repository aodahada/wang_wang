//
//  JiaXiActivityViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/12/16.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "JiaXiActivityViewController.h"

@interface JiaXiActivityViewController ()

@property (nonatomic, strong) UIScrollView *ScrollViewMain;
@property (nonatomic, strong) UIView *viewMain;

@end

@implementation JiaXiActivityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JiaXiActivityViewController"];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"疯狂加息";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat picHeight = SCREEN_WIDTH/375*667;
    
    _ScrollViewMain = [[UIScrollView alloc]init];
    _ScrollViewMain.backgroundColor = [UIColor whiteColor];
    _ScrollViewMain.bounces = NO;
    [self.view addSubview:_ScrollViewMain];
    [_ScrollViewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _viewMain = [[UIView alloc]init];
    _viewMain.backgroundColor = [UIColor whiteColor];
    [_ScrollViewMain addSubview:_viewMain];
    [_viewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_ScrollViewMain);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
    UIImageView *mainImageView = [[UIImageView alloc]init];
    mainImageView.image = [UIImage imageNamed:@"详情页"];
    mainImageView.userInteractionEnabled = YES;
    [_viewMain addSubview:mainImageView];
    [mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewMain.mas_top);
        make.left.equalTo(_viewMain.mas_left);
        make.right.equalTo(_viewMain.mas_right);
        make.height.mas_offset(picHeight);
    }];
    
    UIButton *investButton = [[UIButton alloc]init];
    [investButton addTarget:self action:@selector(investMethod) forControlEvents:UIControlEventTouchUpInside];
    [investButton setBackgroundImage:[UIImage imageNamed:@"btn_ljtz"] forState:UIControlStateNormal];
    [mainImageView addSubview:investButton];
    [investButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(RESIZE_UI(103));
        make.height.mas_offset(RESIZE_UI(34));
        make.centerX.equalTo(_viewMain.mas_centerX);
        make.top.equalTo(_viewMain.mas_top).with.offset(picHeight/2+RESIZE_UI(10));
    }];
    
    [_viewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(mainImageView.mas_bottom);
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JiaXiActivityViewController"];
}

#pragma mark - 立即出借
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
