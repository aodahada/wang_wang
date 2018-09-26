//
//  TaQingActivityViewController.m
//  WmjrApp
//
//  Created by 霍锐 on 2018/4/9.
//  Copyright © 2018年 Baimifan. All rights reserved.
//

#import "TaQingActivityViewController.h"

@interface TaQingActivityViewController ()

@end

@implementation TaQingActivityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"规则说明";
    
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
    imageView.image = [UIImage imageNamed:@"踏青详情页"];
    [mainView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainView.mas_top);
        make.left.equalTo(mainView.mas_left);
        make.right.equalTo(mainView.mas_right);
        make.height.mas_offset(SCREEN_WIDTH*2208/1242);
    }];
    
    [mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageView.mas_bottom);
    }];
    
}

//- (void)viewWillDisappear:(BOOL)animated {
//    /*  设置颜色 */
//    self.navigationController.navigationBar.barTintColor = NAVBARCOLOR;
//    /*  设置字体颜色 */
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
//    /* 渲染颜色 */
//    self.navigationController.navigationBar.tintColor = NAVBARCOLOR;
//    /* 返回 */
//    UIImage *image = [[UIImage imageNamed:@"arrow_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
//    self.navigationItem.leftBarButtonItem = backButton;
//}

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
