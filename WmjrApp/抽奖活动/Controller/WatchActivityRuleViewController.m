//
//  WatchActivityRuleViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/12/15.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "WatchActivityRuleViewController.h"

@interface WatchActivityRuleViewController ()

@property (nonatomic, strong) UIScrollView *ScrollViewMain;
@property (nonatomic, strong) UIView *viewMain;

@end

@implementation WatchActivityRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"活动细则";
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    mainImageView.image = [UIImage imageNamed:@"活动细则"];
    [_viewMain addSubview:mainImageView];
    [mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewMain.mas_top);
        make.left.equalTo(_viewMain.mas_left);
        make.right.equalTo(_viewMain.mas_right);
        make.height.mas_offset(SCREEN_WIDTH/375*821);
    }];
    
    //返回顶部按钮
    UIButton *backToTopButton = [[UIButton alloc]init];
    [backToTopButton addTarget:self action:@selector(backToTop) forControlEvents:UIControlEventTouchUpInside];
    [_viewMain addSubview:backToTopButton];
    [backToTopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_viewMain.mas_bottom).with.offset(RESIZE_UI(-20));
        make.width.mas_offset(RESIZE_UI(200));
        make.height.mas_offset(RESIZE_UI(40));
        make.centerX.equalTo(_viewMain.mas_centerX);
    }];
    
    [_viewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(mainImageView.mas_bottom);
    }];
}

#pragma mark - 返回顶部
- (void)backToTop {
    [_ScrollViewMain setContentOffset:CGPointMake(0, 0) animated:YES];
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
