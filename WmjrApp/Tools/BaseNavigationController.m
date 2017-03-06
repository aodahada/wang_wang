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
    
    //    self.view.backgroundColor = VIEWBACKCOLOR;
    self.view.backgroundColor = RGBA(239, 239, 239, 1.0);
    /*  设置颜色 */
//    self.navigationBar.barTintColor = VIEWBACKCOLOR;
    self.navigationBar.barTintColor = RGBA(0, 108, 175, 1.0);
    /*  设置字体颜色 */
//    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:TITLE_COLOR};
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    /* 渲染颜色 */
//    self.navigationBar.tintColor = TITLE_COLOR;
    self.navigationBar.tintColor = RGBA(0, 108, 175, 1.0);
    /*  去掉边线 */
//    [self.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navibar_color"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"piggy"] forBarMetrics:UIBarMetricsDefault];

}

/*  设置导航条上的按钮 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
//        UIImage *image = [[UIImage imageNamed:@"arrow_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *image = [[UIImage imageNamed:@"arrow_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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
