//
//  LiBaoViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2017/12/15.
//  Copyright © 2017年 Baimifan. All rights reserved.
//

#import "LiBaoViewController.h"
#import "LotteryActivityViewController.h"

@interface LiBaoViewController ()

@property (nonatomic, strong) UIScrollView *ScrollViewMain;
@property (nonatomic, strong) UIView *viewMain;

@end

@implementation LiBaoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"LiBaoViewController"];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"双旦活动";
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
    mainImageView.image = [UIImage imageNamed:@"加息+给我红包"];
    mainImageView.userInteractionEnabled = YES;
    [_viewMain addSubview:mainImageView];
    [mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_viewMain.mas_top);
        make.left.equalTo(_viewMain.mas_left);
        make.right.equalTo(_viewMain.mas_right);
        make.height.mas_offset(picHeight);
    }];
    
    UIButton *topButton = [[UIButton alloc]init];
    [topButton setBackgroundColor:[UIColor clearColor]];
    [topButton addTarget:self action:@selector(topButtonMethod) forControlEvents:UIControlEventTouchUpInside];
    [mainImageView addSubview:topButton];
    [topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainImageView.mas_top);
        make.left.equalTo(mainImageView.mas_left);
        make.right.equalTo(mainImageView.mas_right);
        make.height.mas_offset(picHeight/2);
    }];
    
    UIButton *bottomButton = [[UIButton alloc]init];
    [bottomButton setBackgroundColor:[UIColor clearColor]];
    [bottomButton addTarget:self action:@selector(bottomButton) forControlEvents:UIControlEventTouchUpInside];
    [mainImageView addSubview:bottomButton];
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topButton.mas_bottom);
        make.left.equalTo(mainImageView.mas_left);
        make.right.equalTo(mainImageView.mas_right);
        make.bottom.equalTo(mainImageView.mas_bottom);
    }];
    
    
    [_viewMain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(mainImageView.mas_bottom);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LiBaoViewController"];
}

#pragma mark - 上半部分的按钮
- (void)topButtonMethod {
    LotteryActivityViewController *lotteryVC = [[LotteryActivityViewController alloc]init];
    [self.navigationController pushViewController:lotteryVC animated:YES];
}

#pragma mark - 下半部分的按钮
- (void)bottomButton {
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
