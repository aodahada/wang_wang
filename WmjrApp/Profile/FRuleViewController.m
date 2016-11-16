//
//  FRuleViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 16/1/28.
//  Copyright © 2016年 Baimifan. All rights reserved.
//

#import "FRuleViewController.h"

@interface FRuleViewController ()

@end

@implementation FRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"奖励规则";
    self.tabBarController.tabBar.hidden = YES;
    UIImageView *imageViewForMess = [[UIImageView alloc]init];
    imageViewForMess.image = [UIImage imageNamed:@"image_guize"];
    [self.view addSubview:imageViewForMess];
    [imageViewForMess mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(10);
        make.height.mas_offset(RESIZE_UI(302));
        make.width.mas_offset(RESIZE_UI(375));
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /*  设置颜色 */
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    /*  设置字体颜色 */
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    /* 渲染颜色 */
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    /*  去掉边线 */
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navibar_color"] forBarMetrics:UIBarMetricsDefault];
    
//    UIImage *image = [[UIImage imageNamed:@"arrow_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
}

- (void)backBtnAction {
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
