//
//  MyselfPiggyViewController.m
//  wangmajinrong
//
//  Created by Baimifan on 15/11/24.
//  Copyright © 2015年 Baimifan. All rights reserved.
//

#import "MyselfPiggyViewController.h"

@interface MyselfPiggyViewController ()

@property (weak, nonatomic) IBOutlet UILabel *getEarnLab;
@property (weak, nonatomic) IBOutlet UIImageView *brokenLineImg;
@property (weak, nonatomic) IBOutlet UILabel *yEarnLab;

@property (nonatomic, copy) NSString *path;

@end

@implementation MyselfPiggyViewController

- (void)setUpNavigationBar {
    self.title = @"我的存钱罐";
    self.navigationController.navigationBar.barTintColor = GERENCOLOR;
    /*  设置字体颜色 */
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    /* 渲染颜色 */
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    /*  去掉边线 */
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"piggy"] forBarMetrics:UIBarMetricsDefault];
    
    UIImage *image = [[UIImage imageNamed:@"arrow_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.view.backgroundColor = VIEWBACKCOLOR;
    /* 获得收益 */
    _getEarnLab.textColor = VIEWBACKCOLOR;
}

- (void)backBtnAction {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    /*  设置颜色 */
    self.navigationController.navigationBar.barTintColor = VIEWBACKCOLOR;
    /*  设置字体颜色 */
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:TITLE_COLOR};
    /* 渲染颜色 */
    self.navigationController.navigationBar.tintColor = TITLE_COLOR;
    /*  去掉边线 */
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navibar_color"] forBarMetrics:UIBarMetricsDefault];
    self.tabBarController.tabBar.hidden = NO;
    
    UIImage *image = [[UIImage imageNamed:@"arrow_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"User/income" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if ([obj[@"result"] isEqualToString:@"1"]) {
            _yEarnLab.text = [NSString stringWithFormat:@"%.2f", [[obj[@"data"] objectForKey:@"today_income"] floatValue]];
            _getEarnLab.text = [NSString stringWithFormat:@"%.2f", [[obj[@"data"] objectForKey:@"total_income"] floatValue]];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpNavigationBar];
    
    [self getDataWithNetManager];
    
}

- (void)getDataWithNetManager {
    NetManager *manager = [[NetManager alloc] init];
    [manager postDataWithUrlActionStr:@"Product/pot" withParamDictionary:@{@"member_id":[SingletonManager sharedManager].uid} withBlock:^(id obj) {
        if (obj) {
            _path = [obj[@"data"] objectForKey:@"path"];
            [_brokenLineImg sd_setImageWithURL:[NSURL URLWithString:_path] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
        }
    }];
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
