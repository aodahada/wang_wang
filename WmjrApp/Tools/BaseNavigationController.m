//
//  BaseNavigationController.m
//  NaviDemo
//
//  Created by Baimifan on 15/11/16.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpNavigationBar];
    
}

/*  导航栏设置 */
- (void)setUpNavigationBar {
    /*  设置透明度 */
    self.navigationBar.translucent = NO;
    /*  设置颜色 */
    self.navigationBar.barTintColor = VIEWBACKCOLOR;
    /*  设置字体颜色 */
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:TITLE_COLOR};
    /* 渲染颜色 */
    self.navigationBar.tintColor = TITLE_COLOR;
    /*  去掉边线 */
    [self.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navibar_color"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = VIEWBACKCOLOR;
}

/*  设置导航条上的按钮 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        UIImage *image = [[UIImage imageNamed:@"arrow_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
        viewController.navigationItem.leftBarButtonItem = backButton;
    }
     [super pushViewController:viewController animated:animated];
}

/*  返回 */
- (void)backClick {
    [self popViewControllerAnimated:YES];
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
